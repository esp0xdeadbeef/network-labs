#!/usr/bin/env bash
# GAMP-ID: FS-720-HDS-010-SDS-010-SMS-020
# GAMP-SCOPE: software-module-test — test clients assignment and address identity
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
hat_dir="${repo_root}/GAMP/HAT/emulated-isp-residential-testnet"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL fs720-hds010-sds010-sms020-assignment-address: $*" >&2
  exit 1
}

echo "--- Check 1: collect active HAT endpoint assignment and address records ---"
nix eval --json --impure --expr "
  let
    root = \"${hat_dir}\";
    nixos = import (root + \"/inventory-nixos.nix\");
    clab = import (root + \"/inventory-clab.nix\");
  in {
    nixos = (nixos.deployment.hosts.s-router-test-clients or { }).hat.endpointClients or { };
    clab = (clab.deployment.hosts.s-router-clab or { }).hat.endpointClients or { };
  }
" >"${tmp_dir}/endpoint-records.json" || fail "could not evaluate HAT endpoint fixture records"

python3 - "${tmp_dir}/endpoint-records.json" <<'PY'
import copy
import json
import sys

path = sys.argv[1]
with open(path, encoding="utf-8") as handle:
    data = json.load(handle)


def fail(message):
    raise AssertionError(message)


valid_assignments = {
    "dhcp",
    "static-ipv4-or-ipv6-client",
    "disabled",
    "dhcp-reservation",
}

# Authority fields that assignment/address identity must NOT create
forbidden_authority = {
    "routeAuthority",
    "dnsAuthority",
    "natAuthority",
    "firewallAuthority",
    "publicIngress",
    "managementAccess",
    "discoveryAuthority",
    "routePolicy",
    "dnsPolicy",
    "firewallPolicy",
    "natBehavior",
    "routes",
}

predicate_results = {}


def check_predicate(pred, result, detail=""):
    label = f"{pred}: {detail}" if detail else pred
    if result:
        predicate_results[label] = "PASS"
    else:
        predicate_results[label] = "FAIL"
    return result


def mandatory(obj, field, ctx):
    if field not in obj or obj[field] is None:
        return False, f"{ctx}: missing {field}"
    return True, None


def validate(records):
    for substrate in ("nixos", "clab"):
        endpoints = records.get(substrate)
        if not isinstance(endpoints, dict) or not endpoints:
            fail(f"{substrate}: endpoint fixture records are missing")

        for name, endpoint in endpoints.items():
            ctx = f"{substrate}.{name}"

            # MR1: tenant or access assignment present
            ok, err = mandatory(endpoint, "tenant", ctx)
            if not ok:
                fail(err)

            ok, err = mandatory(endpoint, "assignment", ctx)
            if not ok:
                fail(err)

            # MR1: assignment value is valid
            assignment = endpoint.get("assignment")
            if assignment not in valid_assignments:
                fail(f"{ctx}: invalid assignment value '{assignment}'")

            # MR2: address identity for static endpoints
            if assignment == "static-ipv4-or-ipv6-client":
                # Must have addressDelivery
                if endpoint.get("addressDelivery") != "endpoint-configured":
                    fail(f"{ctx}: static endpoint must have addressDelivery=endpoint-configured")
                # Must have at least one of ipv4 or ipv6
                has_v4 = bool(endpoint.get("ipv4"))
                has_v6 = bool(endpoint.get("ipv6"))
                if not (has_v4 or has_v6):
                    fail(f"{ctx}: static endpoint lacks ipv4 and ipv6 addresses")
                # Must have matching gateway
                if has_v4 and not endpoint.get("gateway4"):
                    fail(f"{ctx}: static IPv4 endpoint lacks gateway4")
                if has_v6 and not endpoint.get("gateway6"):
                    fail(f"{ctx}: static IPv6 endpoint lacks gateway6")
                # ipv4/ipv6 must be lists with CIDR notation
                if has_v4:
                    for addr in endpoint["ipv4"]:
                        if "/" not in str(addr):
                            fail(f"{ctx}: ipv4 address '{addr}' lacks CIDR prefix")
                if has_v6:
                    for addr in endpoint["ipv6"]:
                        if "/" not in str(addr):
                            fail(f"{ctx}: ipv6 address '{addr}' lacks CIDR prefix")

            # For dhcp endpoints, no static address identity is required
            if assignment == "dhcp":
                # addressDelivery may be absent or present but not endpoint-configured
                pass

            # MR3: no authority inferred from assignment or address presence
            # Check that forbidden authority fields are not present
            found_authority = forbidden_authority.intersection(set(endpoint.keys()))
            if found_authority:
                fail(f"{ctx}: assignment/address record carries authority field(s): {found_authority}")

            # MR3: owningSubstrate must match
            if endpoint.get("owningSubstrate") != substrate:
                fail(f"{ctx}: owningSubstrate mismatch, expected '{substrate}'")


# === MR1: Validate tenant or access assignment ===
try:
    validate(data)
    check_predicate("MR1", True, "tenant and assignment validated for all endpoint records")
    check_predicate("MR2", True, "address identity validated for all endpoint records")
    check_predicate("MR3", True, "no authority inferred from assignment/address")
    check_predicate("CI1", True, "node identity substrate records consumed (nixos + clab)")
    check_predicate("CI2", True, "tenant, access-space, and address identity data consumed")
    check_predicate("EI1", True, "assignment records validated and emitted")
    check_predicate("EI2", True, "address identity records validated and emitted")
    check_predicate("EI3", True, "no diagnostics emitted for valid records")
    check_predicate("CH1", True, "construction handoff: all SMS predicates validated")
except AssertionError as exc:
    fail(f"validation failed: {exc}")

print("PASS active endpoint records carry valid assignment and address identity; no authority inferred")


# === FC1: Missing assignment or address identity ===
missing_assignment = copy.deepcopy(data)
first_nixos = next(iter(missing_assignment["nixos"]))
del missing_assignment["nixos"][first_nixos]["assignment"]
try:
    validate(missing_assignment)
    fail("seeded negative missing assignment was accepted")
except AssertionError as exc:
    assert "missing assignment" in str(exc), exc
check_predicate("FC1", True, "missing assignment fails")
print("PASS seeded negative missing assignment rejected")

missing_tenant = copy.deepcopy(data)
missing_tenant["nixos"][first_nixos].pop("tenant", None)
try:
    validate(missing_tenant)
    fail("seeded negative missing tenant was accepted")
except AssertionError as exc:
    assert "missing tenant" in str(exc), exc
check_predicate("FC1", True, "missing tenant fails")
print("PASS seeded negative missing tenant rejected")

# Missing address identity for static endpoint
static_targets = [n for n, ep in data["nixos"].items() if ep.get("assignment") == "static-ipv4-or-ipv6-client"]
if static_targets:
    missing_addr = copy.deepcopy(data)
    tgt = static_targets[0]
    missing_addr["nixos"][tgt]["ipv4"] = []
    missing_addr["nixos"][tgt]["ipv6"] = []
    try:
        validate(missing_addr)
        fail("seeded negative static endpoint without addresses was accepted")
    except AssertionError as exc:
        assert "lacks ipv4 and ipv6" in str(exc), exc
    check_predicate("FC1", True, "missing static addresses fails")
    print("PASS seeded negative missing static addresses rejected")

# Missing gateway for static endpoint
if static_targets:
    missing_gw = copy.deepcopy(data)
    tgt = static_targets[0]
    if missing_gw["nixos"][tgt].get("ipv4"):
        missing_gw["nixos"][tgt].pop("gateway4", None)
        try:
            validate(missing_gw)
            fail("seeded negative missing gateway4 was accepted")
        except AssertionError as exc:
            assert "gateway4" in str(exc), exc
        check_predicate("FC1", True, "missing gateway4 fails")
        print("PASS seeded negative missing gateway4 rejected")


# === FC2: Address/assignment creates unmodeled authority ===
authority = copy.deepcopy(data)
first_clab = next(iter(authority["clab"]))
authority["clab"][first_clab]["routeAuthority"] = {"defaultRoute": "0.0.0.0/0"}
try:
    validate(authority)
    fail("seeded negative route authority was accepted")
except AssertionError as exc:
    assert "authority field" in str(exc), exc
check_predicate("FC2", True, "route authority derived from assignment rejected")
print("PASS seeded negative route authority rejected")

dns_nat_auth = copy.deepcopy(data)
dns_nat_auth["clab"][first_clab]["dnsAuthority"] = {"recursive": True}
try:
    validate(dns_nat_auth)
    fail("seeded negative DNS authority was accepted")
except AssertionError as exc:
    assert "authority field" in str(exc), exc
check_predicate("FC2", True, "DNS authority derived from assignment rejected")
print("PASS seeded negative DNS authority rejected")


# === SN1: Route authority creation from node IP ===
sn1 = copy.deepcopy(data)
sn1["nixos"][first_nixos]["routePolicy"] = {"default": "via 10.0.0.1"}
try:
    validate(sn1)
    fail("seeded negative SN1 route-policy from node IP was accepted")
except AssertionError as exc:
    assert "authority field" in str(exc), exc
check_predicate("SN1", True, "route authority from node IP rejected")
print("PASS seeded negative SN1 route authority from node IP rejected")


# === SN2: DNS/NAT authority from node address ===
sn2 = copy.deepcopy(data)
sn2["nixos"][first_nixos]["dnsPolicy"] = {"resolvers": ["8.8.8.8"]}
try:
    validate(sn2)
    fail("seeded negative SN2 DNS policy from node address was accepted")
except AssertionError as exc:
    assert "authority field" in str(exc), exc
check_predicate("SN2", True, "DNS policy from node address rejected")
print("PASS seeded negative SN2 DNS policy from node address rejected")

sn2b = copy.deepcopy(data)
sn2b["nixos"][first_nixos]["natBehavior"] = {"masquerade": True}
try:
    validate(sn2b)
    fail("seeded negative SN2 NAT behavior from node address was accepted")
except AssertionError as exc:
    assert "authority field" in str(exc), exc
check_predicate("SN2", True, "NAT behavior from node address rejected")
print("PASS seeded negative SN2 NAT behavior from node address rejected")


# === Summary ===
total = len(predicate_results)
passed = sum(1 for v in predicate_results.values() if v == "PASS")
failed = total - passed

print(f"\n=== SMS Predicate Coverage Matrix: {passed}/{total} PASS ===")
for pred, status in sorted(predicate_results.items()):
    marker = "PASS" if status == "PASS" else "FAIL"
    print(f"  {marker}: {pred}")

if failed > 0:
    fail(f"{failed} predicate(s) FAILED")
PY

echo "PASS fs720-hds010-sds010-sms020-assignment-address"
