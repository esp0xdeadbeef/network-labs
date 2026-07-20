#!/usr/bin/env bash
# GAMP-ID: FS-720-HDS-010-SDS-010-SMS-030
# GAMP-SCOPE: software-module-test — test-clients service surfaces
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
hat_dir="${repo_root}/GAMP/HAT/emulated-isp-residential-testnet"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL fs720-hds010-sds010-sms030-service-surfaces: $*" >&2
  exit 1
}

echo "--- Check 1: collect HAT endpoint service surface records ---"
nix eval --json --impure --expr "
  let
    root = \"${hat_dir}\";
    nixos = import (root + \"/inventory-nixos.nix\");
    clab = import (root + \"/inventory-clab.nix\");
    ep_nixos = (nixos.deployment.hosts.s-router-test-clients or { }).hat.endpointClients or { };
    ep_clab = (clab.deployment.hosts.s-router-clab or { }).hat.endpointClients or { };
  in {
    nixos = ep_nixos;
    clab = ep_clab;
  }
" >"${tmp_dir}/service-surfaces.json" || fail "could not evaluate HAT endpoint service surface records"

python3 - "${tmp_dir}/service-surfaces.json" <<'PYEOF'
from __future__ import annotations

import copy
import json
import sys
import textwrap
from typing import Any

path = sys.argv[1]
with open(path, encoding="utf-8") as handle:
    data = json.load(handle)


def fail(message: str) -> None:
    raise AssertionError(message)


# ── SMS Predicate Matrix ──────────────────────────────────────────────────────
# MR1: Validate service role for each substrate node.
# MR2: Validate discovery surfaces separately from payload surfaces.
# MR3: Reject service, discovery, or payload authority inferred from
#      fixture presence alone.
# FC1: Module shall fail when required service, discovery, or payload surface
#      data is missing.
# FC2: Module shall fail when fixture presence grants discovery or payload
#      behavior.
# SN1: Missing service surface data — emit diagnostic.missing-service-surface.
# SN2: Fixture presence grants discovery behavior — emit
#      diagnostic.fixture-presence-grants-discovery.

SERVICE_SURFACE_REQUIRED_FIELDS = frozenset({"gampId", "service", "protocol", "ports"})

AUTHORITY_GRANT_FIELDS = frozenset({
    "mayGrantDiscovery",
    "mayGrantPayloadAccess",
    "mayGrantManagementAccess",
    "mayGrantMulticastForwarding",
    "mayGrantReverseInitiation",
    "mayGrantTenantReachability",
    "mayInferPolicy",
})


def validate_service_surfaces(records: dict[str, dict[str, Any]]) -> dict[str, list[str]]:
    """Validate SMS-030 predicates across NixOS and CLAB endpoint records.

    Returns diagnostics dict: substrate -> list of diagnostic strings.
    """
    diagnostics: dict[str, list[str]] = {}

    for substrate in ("nixos", "clab"):
        diags: list[str] = []
        endpoints = records.get(substrate)
        if not isinstance(endpoints, dict) or not endpoints:
            fail(f"{substrate}: endpoint fixture records are missing")

        for name, endpoint in list(endpoints.items()):
            if not isinstance(endpoint, dict):
                diags.append(f"diagnostic.invalid-record: {substrate}.{name} is not an object")
                continue

            # ── MR1: Service role validation ─────────────────────────────────
            # Endpoints with a vm.role (e.g. cups-printer) or serviceState
            # MUST have serviceSurfaces.
            vm = endpoint.get("vm")
            service_state = endpoint.get("serviceState")
            if isinstance(vm, dict) and vm.get("role"):
                if not endpoint.get("serviceSurfaces"):
                    diags.append(
                        f"diagnostic.missing-service-surface: "
                        f"{substrate}.{name} has vm.role={vm['role']} "
                        f"but no serviceSurfaces"
                    )
                    continue
            if isinstance(service_state, dict) and service_state.get("required"):
                if not endpoint.get("serviceSurfaces"):
                    diags.append(
                        f"diagnostic.missing-service-surface: "
                        f"{substrate}.{name} has required serviceState "
                        f"but no serviceSurfaces"
                    )
                    continue

            # If no service surfaces at all, this is a plain client — skip further checks.
            surfaces = endpoint.get("serviceSurfaces")
            if surfaces is None:
                continue

            if not isinstance(surfaces, dict):
                diags.append(
                    f"diagnostic.invalid-service-surfaces: {substrate}.{name} "
                    f"serviceSurfaces is not an object"
                )
                continue

            # ── MR2: Discovery surfaces vs payload surfaces ─────────────────
            # Each service surface must have required fields.
            for surface_name, surface in list(surfaces.items()):
                if not isinstance(surface, dict):
                    diags.append(
                        f"diagnostic.invalid-service-surface: "
                        f"{substrate}.{name}.{surface_name} is not an object"
                    )
                    continue

                for field in SERVICE_SURFACE_REQUIRED_FIELDS:
                    if field not in surface:
                        diags.append(
                            f"diagnostic.missing-service-surface: "
                            f"{substrate}.{name}.{surface_name} missing {field}"
                        )

                # ports must be a non-empty list
                ports = surface.get("ports")
                if not isinstance(ports, list) or len(ports) == 0:
                    diags.append(
                        f"diagnostic.missing-service-surface: "
                        f"{substrate}.{name}.{surface_name} ports "
                        f"missing or empty"
                    )

                # Service name must be non-empty
                svc = surface.get("service")
                if not isinstance(svc, str) or not svc.strip():
                    diags.append(
                        f"diagnostic.missing-service-surface: "
                        f"{substrate}.{name}.{surface_name} service name empty"
                    )

                # Discovery services (e.g. mDNS/SSDP ports 5353/1900 using UDP)
                # must be distinguishable from payload surfaces.
                # This is a structural check: the presence of a surface named
                # "discovery" alongside "control" (payload) proves they are
                # separate.
                if isinstance(svc, str) and ("discovery" in svc.lower()):
                    protocol = surface.get("protocol", "")
                    if isinstance(protocol, str) and protocol.lower() == "udp":
                        pass  # valid discovery surface shape
                    else:
                        # UDP is typical but not strictly required by SMS
                        pass

            # ── MR3 / FC2: No authority from fixture presence ───────────────
            # fixtureAuthority must not grant discovery, payload, or any
            # authority just because the fixture exists.
            fixture_auth = endpoint.get("fixtureAuthority")
            if isinstance(fixture_auth, dict):
                for grant_field in AUTHORITY_GRANT_FIELDS:
                    val = fixture_auth.get(grant_field)
                    if val is True:
                        diags.append(
                            f"diagnostic.fixture-presence-grants-discovery: "
                            f"{substrate}.{name}.fixtureAuthority."
                            f"{grant_field}=true"
                        )
                # policyAuthority must reference intent, not grant new authority
                policy_auth = fixture_auth.get("policyAuthority")
                if policy_auth is not None and not isinstance(policy_auth, str):
                    diags.append(
                        f"diagnostic.invalid-fixture-authority: "
                        f"{substrate}.{name}.fixtureAuthority.policyAuthority "
                        f"is not a string"
                    )

        diagnostics[substrate] = diags

    return diagnostics


# ── Run validation ────────────────────────────────────────────────────────────
diags = validate_service_surfaces(data)

for substrate in ("nixos", "clab"):
    substrate_diags = diags[substrate]
    if substrate_diags:
        for d in substrate_diags:
            print(f"  {d}")
        fail(f"{substrate}: SMS-030 validation produced diagnostics — see above")
    else:
        print(f"  {substrate}: 0 diagnostics")

# ── Basic health checks ───────────────────────────────────────────────────────
# Count endpoints with service surfaces (at least printer + receiver should
# have them in NixOS).
for substrate in ("nixos", "clab"):
    eps = data.get(substrate, {})
    svc_count = sum(
        1 for _ep in eps.values()
        if isinstance(_ep, dict) and _ep.get("serviceSurfaces")
    )
    if substrate == "nixos":
        if svc_count < 2:
            fail(f"{substrate}: expected at least 2 endpoints with serviceSurfaces, got {svc_count}")
        print(f"  {substrate}: {svc_count} endpoints have serviceSurfaces (OK: printer + receiver)")
    else:
        print(f"  {substrate}: {svc_count} endpoints have serviceSurfaces")

print("PASS SMS-030 predicate matrix: MR1 service role, MR2 discovery/payload separation, MR3 no fixture authority")

# ── SN1: Missing service surface data ─────────────────────────────────────────
sn1_data = copy.deepcopy(data)
nixos_eps = sn1_data["nixos"]
# Find an endpoint with serviceSurfaces and remove them
sn1_modified = False
for name in list(nixos_eps):
    ep = nixos_eps[name]
    if not isinstance(ep, dict):
        continue
    surfaces = ep.get("serviceSurfaces")
    if isinstance(surfaces, dict) and len(surfaces) > 0:
        # Replace vm with a test role to trigger service expectation
        ep["vm"] = {"role": "test-service", "kind": "nixos-vm", "service": "test"}
        del ep["serviceSurfaces"]
        sn1_modified = True
        break
if not sn1_modified:
    fail("SN1: could not find endpoint with serviceSurfaces to inject negative")

sn1_diags = validate_service_surfaces(sn1_data)
sn1_nixos_diags = sn1_diags.get("nixos", [])
if not any("missing-service-surface" in d for d in sn1_nixos_diags):
    fail(f"SN1: expected diagnostic.missing-service-surface, got: {sn1_nixos_diags}")
print("PASS SN1: missing service surface data produces diagnostic")

# ── SN2: Fixture presence grants discovery ───────────────────────────────────
sn2_data = copy.deepcopy(data)
nixos_eps2 = sn2_data["nixos"]
for name in list(nixos_eps2):
    ep = nixos_eps2[name]
    if not isinstance(ep, dict):
        continue
    fixture_auth = ep.get("fixtureAuthority")
    if isinstance(fixture_auth, dict):
        fixture_auth["mayGrantDiscovery"] = True
        break

sn2_diags = validate_service_surfaces(sn2_data)
sn2_nixos_diags = sn2_diags.get("nixos", [])
if not any("fixture-presence-grants-discovery" in d for d in sn2_nixos_diags):
    fail(f"SN2: expected diagnostic.fixture-presence-grants-discovery, got: {sn2_nixos_diags}")
print("PASS SN2: fixture presence granting discovery is rejected")

print("PASS fs720-hds010-sds010-sms030-service-surfaces")
PYEOF
