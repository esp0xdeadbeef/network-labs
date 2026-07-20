#!/usr/bin/env bash
# GAMP-ID: FS-720-HDS-010-SDS-010-SMS-010
# GAMP-SCOPE: software-module-test — test clients substrate identity
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
hat_dir="${repo_root}/GAMP/HAT/emulated-isp-residential-testnet"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL fs720-hds010-sds010-sms010-test-clients-substrate: $*" >&2
  exit 1
}

echo "--- Check 1: collect active HAT endpoint substrate records ---"
nix eval --json --impure --expr "
  let
    root = \"${hat_dir}\";
    nixos = import (root + \"/inventory-nixos.nix\");
    clab = import (root + \"/inventory-clab.nix\");
  in {
    nixos = (nixos.deployment.hosts.s-router-test-clients or { }).hat.endpointClients or { };
    clab = (clab.deployment.hosts.s-router-clab or { }).hat.endpointClients or { };
  }
" >"${tmp_dir}/endpoint-substrates.json" || fail "could not evaluate HAT endpoint substrate records"

python3 - "${tmp_dir}/endpoint-substrates.json" <<'PY'
import copy
import json
import sys

path = sys.argv[1]
with open(path, encoding="utf-8") as handle:
    data = json.load(handle)

forbidden_fields = {
    "routeAuthority",
    "dnsAuthority",
    "firewallAuthority",
    "natAuthority",
    "publicIngress",
    "managementAccess",
    "discoveryAuthority",
    "dnsPolicy",
    "routePolicy",
    "natBehavior",
    "firewallPolicy",
    "routes",
}


def fail(message):
    raise AssertionError(message)


def validate(records):
    for substrate in ("nixos", "clab"):
        endpoints = records.get(substrate)
        if not isinstance(endpoints, dict) or not endpoints:
            fail(f"{substrate}: endpoint fixture records are missing")
        for name, endpoint in endpoints.items():
            if not isinstance(name, str) or not name:
                fail(f"{substrate}: empty endpoint identity")
            if not isinstance(endpoint, dict):
                fail(f"{substrate}.{name}: endpoint record is not an object")
            if endpoint.get("owningSubstrate") != substrate:
                fail(f"{substrate}.{name}: owningSubstrate mismatch")
            for field in ("tenant", "assignment", "persistenceExpectation", "managementBoundary"):
                if field not in endpoint:
                    fail(f"{substrate}.{name}: missing {field}")
            if forbidden_fields.intersection(endpoint):
                fail(f"{substrate}.{name}: endpoint substrate carries authority field")
            management = endpoint["managementBoundary"]
            if not isinstance(management, dict):
                fail(f"{substrate}.{name}: managementBoundary is not an object")
            if management.get("fixturePlacementCreatesManagementAccess") is not False:
                fail(f"{substrate}.{name}: fixture placement creates management access")
            if not management.get("mode"):
                fail(f"{substrate}.{name}: managementBoundary.mode missing")
            persistence = endpoint["persistenceExpectation"]
            if not isinstance(persistence, dict):
                fail(f"{substrate}.{name}: persistenceExpectation is not an object")
            if "required" not in persistence or "kind" not in persistence:
                fail(f"{substrate}.{name}: persistenceExpectation missing required/kind")
            if endpoint.get("assignment") == "static-ipv4-or-ipv6-client":
                has_v4 = bool(endpoint.get("ipv4"))
                has_v6 = bool(endpoint.get("ipv6"))
                if endpoint.get("addressDelivery") != "endpoint-configured" or not (has_v4 or has_v6):
                    fail(f"{substrate}.{name}: static endpoint lacks endpoint-configured address identity")
                if has_v4 and not endpoint.get("gateway4"):
                    fail(f"{substrate}.{name}: static IPv4 endpoint lacks gateway4")
                if has_v6 and not endpoint.get("gateway6"):
                    fail(f"{substrate}.{name}: static IPv6 endpoint lacks gateway6")
            surfaces = endpoint.get("serviceSurfaces") or {}
            if surfaces:
                if not isinstance(surfaces, dict):
                    fail(f"{substrate}.{name}: serviceSurfaces is not an object")
                for surface_name, surface in surfaces.items():
                    if not isinstance(surface, dict):
                        fail(f"{substrate}.{name}.{surface_name}: service surface is not an object")
                    for field in ("gampId", "service", "protocol", "ports"):
                        if field not in surface:
                            fail(f"{substrate}.{name}.{surface_name}: missing service surface {field}")


validate(data)
print("PASS active endpoint substrate records preserve identity, persistence, services, and management boundary")

missing_tenant = copy.deepcopy(data)
first_nixos = next(iter(missing_tenant["nixos"]))
del missing_tenant["nixos"][first_nixos]["tenant"]
try:
    validate(missing_tenant)
except AssertionError as exc:
    assert "missing tenant" in str(exc), exc
else:
    fail("seeded negative missing tenant was accepted")
print("PASS seeded negative missing tenant rejected")

authority = copy.deepcopy(data)
first_clab = next(iter(authority["clab"]))
authority["clab"][first_clab]["dnsPolicy"] = {"authoritative": True}
try:
    validate(authority)
except AssertionError as exc:
    assert "authority field" in str(exc), exc
else:
    fail("seeded negative DNS policy authority was accepted")
print("PASS seeded negative DNS policy authority rejected")

management = copy.deepcopy(data)
management["nixos"][first_nixos]["managementBoundary"]["fixturePlacementCreatesManagementAccess"] = True
try:
    validate(management)
except AssertionError as exc:
    assert "management access" in str(exc), exc
else:
    fail("seeded negative management access was accepted")
print("PASS seeded negative management access rejected")

static_gap = copy.deepcopy(data)
static_name = next(
    name
    for name, endpoint in static_gap["nixos"].items()
    if endpoint.get("assignment") == "static-ipv4-or-ipv6-client"
)
static_gap["nixos"][static_name].pop("ipv4", None)
static_gap["nixos"][static_name].pop("ipv6", None)
try:
    validate(static_gap)
except AssertionError as exc:
    assert "static endpoint" in str(exc), exc
else:
    fail("seeded negative static address gap was accepted")
print("PASS seeded negative static address gap rejected")
PY

echo "PASS fs720-hds010-sds010-sms010-test-clients-substrate"
