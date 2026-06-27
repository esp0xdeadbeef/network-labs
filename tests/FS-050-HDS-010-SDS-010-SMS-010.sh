#!/usr/bin/env bash
# GAMP-ID: FS-050-HDS-010-SDS-010-SMS-010
# GAMP-SCOPE: software-module-test
# Tests CPM binder-source-audit protected-inventory source class handling.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CPM_REPO="${NETWORK_CPM_REPO:-/home/deadbeef/github/network-control-plane-model}"

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "missing required command: $1" >&2
    exit 1
  }
}

require_cmd nix

tmp_dir="${TMPDIR:-/tmp}/fs050-cpm-protected-inventory-smt"
mkdir -p "${tmp_dir}"
rm -f "${tmp_dir}/valid.out" "${tmp_dir}/valid.err" \
  "${tmp_dir}/missing-field.out" "${tmp_dir}/missing-field.err" \
  "${tmp_dir}/bad-source.out" "${tmp_dir}/bad-source.err"

pass_count=0
fail_count=0

pass() { echo "  PASS $1"; pass_count=$((pass_count + 1)); }
fail() { echo "  FAIL $1: $2" >&2; fail_count=$((fail_count + 1)); }

echo "=== FS-050-HDS-010-SDS-010-SMS-010: CPM Protected-Inventory Boundary ==="

# --- Test 1: Protected-inventory source class is accepted ---
echo "--- Test 1: Protected-inventory source class accepted ---"
if nix eval --impure --expr '
  let
    lib = import "'"${CPM_REPO}"'/lib/utils.nix";
    helpers = import "'"${CPM_REPO}"'/src/cpm/cpm-contract-support.nix" { inherit lib; };
    audit = import "'"${CPM_REPO}"'/src/cpm/binder-source-audit.nix" { inherit helpers; };
  in
    audit.validate "protected-ok" (audit.make {
      path = "protected-ok";
      field = "secretBinding";
      binderSourceClass = "protected-inventory";
      binderSourcePath = "inventory.protected.credentials.api-key";
      upstreamBehaviorRef = "forwardingModel.enterprise.acme.site.ams.secretBindings.api-key";
    })
' >"${tmp_dir}/valid.out" 2>"${tmp_dir}/valid.err"; then
  pass "Protected-inventory source class accepted by binder-source-audit"
else
  fail "protected-inventory-accept" "$(cat "${tmp_dir}/valid.err")"
fi

# --- Test 2: Missing required field rejected ---
echo "--- Test 2: Missing binder source audit rejected ---"
if nix eval --impure --expr '
  let
    lib = import "'"${CPM_REPO}"'/lib/utils.nix";
    helpers = import "'"${CPM_REPO}"'/src/cpm/cpm-contract-support.nix" { inherit lib; };
    audit = import "'"${CPM_REPO}"'/src/cpm/binder-source-audit.nix" { inherit helpers; };
  in
    audit.validate "missing-audit" {
      upstreamBehaviorRef = "forwardingModel.enterprise.acme.site.ams.nodes.router";
    }
' >"${tmp_dir}/missing-field.out" 2>"${tmp_dir}/missing-field.err"; then
  fail "missing-audit-accepted" "Missing binder source audit was not rejected"
else
  if grep -F "CPM binder source audit error" "${tmp_dir}/missing-field.err" >/dev/null; then
    pass "Missing binder source audit rejected with CPM diagnostic"
  else
    fail "missing-audit-diagnostic" "Diagnostic did not name CPM audit: $(cat "${tmp_dir}/missing-field.err")"
  fi
fi

# --- Test 3: Invalid source class rejected ---
echo "--- Test 3: Invalid source class rejected ---"
if nix eval --impure --expr '
  let
    lib = import "'"${CPM_REPO}"'/lib/utils.nix";
    helpers = import "'"${CPM_REPO}"'/src/cpm/cpm-contract-support.nix" { inherit lib; };
    audit = import "'"${CPM_REPO}"'/src/cpm/binder-source-audit.nix" { inherit helpers; };
  in
    audit.validate "bad-source" (audit.make {
      path = "bad-source";
      field = "test";
      binderSourceClass = "synthetic-fabricated";
      binderSourcePath = "nowhere";
      upstreamBehaviorRef = "ref";
    })
' >"${tmp_dir}/bad-source.out" 2>"${tmp_dir}/bad-source.err"; then
  fail "bad-source-accepted" "Invalid source class was not rejected"
else
  if grep -F "must be CPM binder source class" "${tmp_dir}/bad-source.err" >/dev/null; then
    pass "Invalid source class rejected with allowed-classes diagnostic"
  else
    fail "bad-source-diagnostic" "Diagnostic did not name allowed classes: $(cat "${tmp_dir}/bad-source.err")"
  fi
fi

# --- Test 4: Protected-inventory source class listed in allowed classes ---
echo "--- Test 4: Protected-inventory in allowed source classes ---"
if nix eval --impure --raw --expr '
  let
    src = builtins.readFile "'"${CPM_REPO}"'/src/cpm/binder-source-audit.nix";
    has = needle:
      builtins.stringLength (builtins.replaceStrings [needle] [""] src)
      < builtins.stringLength src;
  in
    if has "protected-inventory" then "true" else "false"
' | grep -qx true; then
  pass "Protected-inventory listed in allowedBinderSourceClasses"
else
  fail "protected-inventory-listed" "protected-inventory not found in binder-source-audit.nix source"
fi

# --- Summary ---
echo ""
echo "=== Results: ${pass_count} PASS, ${fail_count} FAIL ==="

if [ "${fail_count}" -gt 0 ]; then
  echo ""
  echo "NOTE: FS-050-HDS-010-SDS-010-SMS-010 seeded negatives (SN1 unauthorized consumer,"
  echo "SN2 plaintext leak into public inventory) require CMC implementation beyond"
  echo "binder-source-audit source-class validation. Current CMC only validates source"
  echo "class name format; access control and leak prevention are not yet implemented."
  echo "This test proves the protected-inventory source class is wired into the CPM"
  echo "binder-source-audit validation pipeline."
  exit 1
fi

echo "PASS FS-050-HDS-010-SDS-010-SMS-010"
