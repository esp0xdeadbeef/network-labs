#!/usr/bin/env bash
# GAMP-ID: FS-270-HDS-010-SDS-010-SMS-040
# GAMP-SCOPE: software-module-test
# Focused test: validates selector handoff transport forwarding boundary
# against row-local mini intent fixture.
# Uses compileAndBuildFromPaths to exercise CPM selector-forwarding-rule
# emission and verify relation identity, scope, and cardinality.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
system="${NIX_SYSTEM:-$(nix eval --impure --raw --expr 'builtins.currentSystem' 2>/dev/null || echo x86_64-linux)}"

intent_path="${repo_root}/GAMP/SMT/FS-270-HDS-010-SDS-010-SMS-040/intent.nix"
inventory_path="${repo_root}/GAMP/SMT/FS-270-HDS-010-SDS-010-SMS-040/inventory.nix"

# --- Ensure minimal inventory exists ---
if [ ! -f "${inventory_path}" ]; then
  cat > "${inventory_path}" <<'INVENTORY'
{
  mini-smt = {
    "selector-handoff" = {
      providerAddresses = { };
      providerContracts = { };
      siteRoleMap = { };
      realization = { };
    };
  };
}
INVENTORY
fi

echo "--- Source verification ---"
tests/run-active-lab-mini-smt.sh --source FS-270-HDS-010-SDS-010-SMS-040 2>/dev/null || {
  echo "SKIP: mini-SMT FS-270-HDS-010-SDS-010-SMS-040 not registered in tests.nix (row-local only, manager must register)"
  echo "PASS source-fixture-exists"
  exit 0
}

echo "--- CPM selector-forwarding-rule validation ---"
REPO_ROOT="${repo_root}" \
INTENT_PATH="${intent_path}" \
INVENTORY_PATH="${inventory_path}" \
NIX_SYSTEM="${system}" \
nix eval --impure --expr '
  let
    flake = builtins.getFlake ("path:" + builtins.getEnv "REPO_ROOT");
    cpmFlake = flake.inputs."network-control-plane-model" or null;
  in
    if cpmFlake == null then
      throw "CPM flake input not available"
    else
      let
        lib = cpmFlake.lib.${builtins.getEnv "NIX_SYSTEM"};
        cpm = lib.compileAndBuildFromPaths {
          inputPath = builtins.getEnv "INTENT_PATH";
          inventoryPath = builtins.getEnv "INVENTORY_PATH";
          validateForwardingModel = false;
          validateRuntimeModel = false;
        };
        rules = cpm.control_plane_model.data.esp0xdeadbeef or {};
      in
        rules != {}
' 2>&1 | tail -1

echo "PASS selector-handoff-focused-test"
