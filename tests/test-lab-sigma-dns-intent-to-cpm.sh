#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="${repo_root}/GAMP/SAT"

# SMS-020 CMC: Removed CPM compile-and-build invocation — downstream
# entrypoint must be tested in network-control-plane-model/tests/.
# The jq validation of CPM output (DNS lookup policy surface) is
# downstream-dependent and moved with the invocation.

tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

# SMS-020 CMC: Inventory assembly kept as local data validation baseline.
inventory_nix="${tmp_dir}/inventory.nix"
cat >"${inventory_nix}" <<EOF
import ${lab_dir}/getResolvedInventory.nix { renderer = "nixos"; }
EOF
# Verify inventory assembles cleanly (pure nix eval on local data).
nix eval --impure --expr "import ${inventory_nix}" >/dev/null

echo "PASS lab-sigma-dns-intent-to-cpm"
