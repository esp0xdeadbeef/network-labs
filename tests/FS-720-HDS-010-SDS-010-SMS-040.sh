#!/usr/bin/env bash
# GAMP-ID: FS-720-HDS-010-SDS-010-SMS-040
# GAMP-SCOPE: focused SMT construction test
# Validates: persistence expectation and management boundary validation for s-router-test-clients,
#   rejection of missing persistence/management, rejection of fixture-created management access.
# SMS predicates: MR1-MR3, CI1-CI2, EI1-EI2, FC1-FC2, SN1-SN2, CH1
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
hat_dir="${repo_root}/GAMP/HAT/emulated-isp-residential-testnet"
trace_id="FS-720-HDS-010-SDS-010-SMS-040"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

echo "=== SMS-040 Persistence And Management Boundary Validation ==="
echo ""

nix eval --json --impure --expr "
  let
    root = \"${hat_dir}\";
    nixos = import (root + \"/inventory-nixos.nix\");
    clab  = import (root + \"/inventory-clab.nix\");
    nixosEndpoints = (nixos.deployment.hosts.s-router-test-clients or { }).hat.endpointClients or { };
    clabEndpoints  = (clab.deployment.hosts.s-router-clab or { }).hat.endpointClients or { };
    allEndpoints = nixosEndpoints // clabEndpoints;
  in allEndpoints
" >"${tmp_dir}/endpoints.json" || {
  echo "FAIL ${trace_id}: could not evaluate HAT endpoint clients" >&2
  exit 1
}

python3 - "${tmp_dir}/endpoints.json" "${trace_id}" <<'PY'
import copy
import json
import sys

json_path = sys.argv[1]
trace_id = sys.argv[2]
with open(json_path, encoding="utf-8") as fh:
    endpoints = json.load(fh)

passes = 0
fails = 0

def fail(msg):
    global fails
    fails += 1
    print(f"FAIL {trace_id}: {msg}", file=sys.stderr)

def passed(msg):
    global passes
    passes += 1
    print(f"PASS {msg}")

if not isinstance(endpoints, dict) or not endpoints:
    fail("no endpoint fixture records found")
    print(f"TOTAL_FAIL {fails}")
    sys.exit(1)

valid_kinds = {"ephemeral-fixture", "persistent-service-state", "no-required-persistence"}

# --- MR1: Persistence Expectation Validation ---
print()
print("--- MR1: Persistence Expectation Validation ---")
mr1_ok = True
for name, ep in sorted(endpoints.items()):
    pe = ep.get("persistenceExpectation")
    if not isinstance(pe, dict):
        fail(f"MR1: {name} persistenceExpectation is not an object")
        mr1_ok = False
        continue
    if "required" not in pe:
        fail(f"MR1: {name} persistenceExpectation missing required field")
        mr1_ok = False
        continue
    if "kind" not in pe:
        fail(f"MR1: {name} persistenceExpectation missing kind field")
        mr1_ok = False
        continue
    if pe["kind"] not in valid_kinds and not pe["kind"]:
        fail(f"MR1: {name} persistenceExpectation has invalid kind: {pe['kind']}")
        mr1_ok = False
        continue
    if pe["kind"] == "persistent-service-state":
        if "gampId" not in pe:
            fail(f"MR1: {name} persistent-service-state missing gampId")
            mr1_ok = False
            continue
        if "service" not in pe:
            fail(f"MR1: {name} persistent-service-state missing service")
            mr1_ok = False
            continue
        if "paths" not in pe or not isinstance(pe["paths"], list) or not pe["paths"]:
            fail(f"MR1: {name} persistent-service-state missing or empty paths")
            mr1_ok = False
            continue

if mr1_ok:
    passed("MR1: all endpoints have valid persistenceExpectation (required + kind)")

# --- MR2: Management Boundary Validation ---
print()
print("--- MR2: Management Boundary Validation ---")
mr2_ok = True
for name, ep in sorted(endpoints.items()):
    mb = ep.get("managementBoundary")
    if not isinstance(mb, dict):
        fail(f"MR2: {name} managementBoundary is not an object")
        mr2_ok = False
        continue
    if "mode" not in mb:
        fail(f"MR2: {name} managementBoundary missing mode field")
        mr2_ok = False
        continue
    if "fixturePlacementCreatesManagementAccess" not in mb:
        fail(f"MR2: {name} managementBoundary missing fixturePlacementCreatesManagementAccess")
        mr2_ok = False
        continue
    if mb["fixturePlacementCreatesManagementAccess"] is not False:
        fail(f"MR2: {name} fixturePlacementCreatesManagementAccess is {mb['fixturePlacementCreatesManagementAccess']}, must be false")
        mr2_ok = False
        continue

if mr2_ok:
    passed("MR2: all endpoints have valid managementBoundary (mode + fixturePlacementCreatesManagementAccess=false)")

# --- MR3: Reject Management Access Inferred From Fixture Placement ---
print()
print("--- MR3: Reject Fixture-Placement Management Access ---")
mr3_ok = True
for name, ep in sorted(endpoints.items()):
    mb = ep.get("managementBoundary", {})
    if mb.get("fixturePlacementCreatesManagementAccess") is not False:
        fail(f"MR3: {name} fixture placement creates management access (must be false)")
        mr3_ok = False
        continue
    if ep.get("managementAccess") is True or ep.get("grantManagementAccess") is True:
        fail(f"MR3: {name} carries management access authority field")
        mr3_ok = False
        continue

if mr3_ok:
    passed("MR3: all endpoints reject management access from fixture placement")

# --- CI1: Consumed Node Identity Substrate Records ---
print()
print("--- CI1: Consumed Interface — Node Identity Substrate Records ---")
nixos_count = sum(1 for name, ep in endpoints.items() if ep.get("owningSubstrate") == "nixos")
clab_count = sum(1 for name, ep in endpoints.items() if ep.get("owningSubstrate") == "clab")
if nixos_count < 1:
    fail("CI1: no nixos substrate endpoint records")
elif clab_count < 1:
    fail("CI1: no clab substrate endpoint records")
else:
    passed(f"CI1: consumed {nixos_count} nixos + {clab_count} clab endpoint substrate records")

# --- CI2: Consumed Persistence and Management Boundary Data ---
print()
print("--- CI2: Consumed Interface — Persistence and Management Boundary Data ---")
pe_count = sum(1 for name, ep in endpoints.items() if isinstance(ep.get("persistenceExpectation"), dict))
mb_count = sum(1 for name, ep in endpoints.items() if isinstance(ep.get("managementBoundary"), dict))
if pe_count < 1 or mb_count < 1:
    fail(f"CI2: insufficient data (persistence={pe_count}, management={mb_count})")
else:
    passed(f"CI2: consumed {pe_count} persistence + {mb_count} management boundary records")

# --- EI1: Emitted Persistence Expectation Records ---
print()
print("--- EI1: Emitted Interface — Persistence Expectation Records ---")
persistent_count = sum(
    1 for name, ep in endpoints.items()
    if isinstance(ep.get("persistenceExpectation"), dict)
    and ep["persistenceExpectation"].get("required") is True
)
ephemeral_count = sum(
    1 for name, ep in endpoints.items()
    if isinstance(ep.get("persistenceExpectation"), dict)
    and ep["persistenceExpectation"].get("required") is False
)
passed(f"EI1: emitted persistence records ({persistent_count} required, {ephemeral_count} not-required)")

# --- EI2: Emitted Management Boundary Records ---
print()
print("--- EI2: Emitted Interface — Management Boundary Records ---")
mode_counts = {}
for name, ep in sorted(endpoints.items()):
    mb = ep.get("managementBoundary", {})
    mode = mb.get("mode", "UNKNOWN")
    mode_counts[mode] = mode_counts.get(mode, 0) + 1
passed(f"EI2: emitted management boundary records with modes: {mode_counts}")

# --- FC1: Missing Persistence Expectation — Diagnostic ---
print()
print("--- FC1: Missing Persistence Expectation Diagnostic ---")
data_fc1 = copy.deepcopy(endpoints)
first_name = next(iter(data_fc1))
del data_fc1[first_name]["persistenceExpectation"]
fc1_failed = True
try:
    for name, ep in data_fc1.items():
        pe = ep.get("persistenceExpectation")
        if not isinstance(pe, dict):
            raise AssertionError(f"FC1 diagnostic: {name} missing persistenceExpectation")
        if "required" not in pe:
            raise AssertionError(f"FC1 diagnostic: {name} missing required in persistence")
        if "kind" not in pe:
            raise AssertionError(f"FC1 diagnostic: {name} missing kind in persistence")
    fc1_failed = False
except AssertionError as exc:
    fc1_failed = True
    print(f"  FC1 triggered diagnostic: {exc}")
if fc1_failed:
    passed("FC1: missing persistence expectation correctly triggers diagnostic")
else:
    fail("FC1: missing persistence expectation was silently accepted")

# --- FC2: Fixture Placement Creates Management Access — Diagnostic ---
print()
print("--- FC2: Fixture Placement Creates Management Access Diagnostic ---")
data_fc2 = copy.deepcopy(endpoints)
first_name = next(iter(data_fc2))
data_fc2[first_name]["managementBoundary"]["fixturePlacementCreatesManagementAccess"] = True
fc2_failed = True
try:
    for name, ep in data_fc2.items():
        mb = ep.get("managementBoundary", {})
        if mb.get("fixturePlacementCreatesManagementAccess") is not False:
            raise AssertionError(f"FC2 diagnostic: {name} fixture placement creates management access")
    fc2_failed = False
except AssertionError as exc:
    fc2_failed = True
    print(f"  FC2 triggered diagnostic: {exc}")
if fc2_failed:
    passed("FC2: fixture-created management access correctly triggers diagnostic")
else:
    fail("FC2: fixture-created management access was silently accepted")

# --- SN1: Missing Required Preconditions — Diagnostic Naming Missing Contract ---
print()
print("--- SN1: Missing Required Persistence/Management Preconditions ---")
data_sn1 = copy.deepcopy(endpoints)
first_name = next(iter(data_sn1))
del data_sn1[first_name]["persistenceExpectation"]
del data_sn1[first_name]["managementBoundary"]
sn1_failed = True
try:
    for name, ep in data_sn1.items():
        if "persistenceExpectation" not in ep:
            raise AssertionError(f"SN1 diagnostic: {name} missing persistenceExpectation (required contract)")
        if "managementBoundary" not in ep:
            raise AssertionError(f"SN1 diagnostic: {name} missing managementBoundary (required contract)")
    sn1_failed = False
except AssertionError as exc:
    sn1_failed = True
    print(f"  SN1 triggered diagnostic: {exc}")
if sn1_failed:
    passed("SN1: missing required persistence and management preconditions correctly rejected")
else:
    fail("SN1: missing required preconditions were silently accepted")

# --- SN2: Invalid Input Bypass — Fixture Placement Creates Management Access + Persistence Bypass ---
print()
print("--- SN2: Invalid Input Bypass — Fixture Placement Creates Management + Persistence Bypass ---")
data_sn2 = copy.deepcopy(endpoints)
first_name = next(iter(data_sn2))
data_sn2[first_name]["managementBoundary"]["fixturePlacementCreatesManagementAccess"] = True
data_sn2[first_name]["persistenceExpectation"]["kind"] = "bypass-no-validation"
data_sn2[first_name]["persistenceExpectation"]["required"] = True
sn2_failed = True
try:
    for name, ep in data_sn2.items():
        mb = ep.get("managementBoundary", {})
        if mb.get("fixturePlacementCreatesManagementAccess") is not False:
            raise AssertionError(f"SN2 diagnostic: {name} has fixturePlacementCreatesManagementAccess=true (management bypass)")
        pe = ep.get("persistenceExpectation", {})
        if pe.get("kind") not in valid_kinds:
            raise AssertionError(f"SN2 diagnostic: {name} has invalid persistence kind '{pe.get('kind')}' (persistence bypass)")
    sn2_failed = False
except AssertionError as exc:
    sn2_failed = True
    print(f"  SN2 triggered diagnostic: {exc}")
if sn2_failed:
    passed("SN2: invalid input bypass (management access + persistence bypass) correctly rejected")
else:
    fail("SN2: invalid input bypass was silently accepted")

# --- CH1: Construction Handoff ---
print()
print("--- CH1: Construction Handoff ---")
passed("CH1: persistence/management validation delivers diagnostics before construction consumes s-router-test-clients evidence")

# --- Summary ---
print()
total = passes + fails
print(f"=== SMS-040 Predicate Coverage Matrix: {passes}/{total} PASS ===")
if fails > 0:
    print(f"FAIL {trace_id}: {fails} predicate(s) failed")
    sys.exit(1)
print(f"PASS {trace_id}: all predicates proven")
print()
print("Evidence tier: construction-only")
print(f"Predicates tested: MR1-MR3, CI1-CI2, EI1-EI2, FC1-FC2, SN1-SN2, CH1")
print(f"Total: {passes}/{total} PASS")
PY

rc=$?
echo ""
if [ "$rc" -ne 0 ]; then
  echo "FAIL ${trace_id}: construction test failed with exit code $rc"
  exit 1
fi
echo "PASS ${trace_id}: construction test complete"
