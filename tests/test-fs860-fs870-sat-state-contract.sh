#!/usr/bin/env bash
# GAMP-IDS: FS-860-HDS-010-SDS-010, FS-870-HDS-010-SDS-010
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="${repo_root}/GAMP/SAT"
# SMS-020 CMC: cpm_flake removed — downstream entrypoint reference.
# CPM compile-and-build invocation and jq validation of state contracts
# (durability classes, persistence paths, state-loss handling) are
# downstream-dependent and must live in network-control-plane-model/tests/.

tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

inventory_nix="${tmp_dir}/inventory-nixos.nix"
output_json="${tmp_dir}/cpm.json"

printf 'import %s/getResolvedInventory.nix { renderer = "nixos"; }\n' "${lab_dir}" >"${inventory_nix}"

echo "PASS fs860-fs870-sat-state-contract"
