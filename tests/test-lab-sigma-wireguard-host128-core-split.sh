#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="${repo_root}/sat"
compiler_repo="${NETWORK_COMPILER_REPO:-/home/deadbeef/github/network-compiler}"

nix eval --extra-experimental-features 'nix-command flakes' --impure --expr "
let
  intent = import ${lab_dir}/intent.nix;
  inventory = import ${lab_dir}/inventory.nix;
  overlays = intent.esp.hetz.transport.overlays;
  matches = builtins.filter (overlay: (overlay.name or null) == \"wg-host128-egress\") overlays;
  overlay = if matches == [] then throw \"missing wg-host128-egress overlay\" else builtins.head matches;
  nodes = inventory.controlPlane.sites.esp.hetz.overlays.wg-host128-egress.nodes or {};
in
  if overlay.terminateOn == \"hetz-router-nebula-core\"
    && builtins.hasAttr \"hetz-router-nebula-core\" nodes
    && !(builtins.hasAttr \"hetz-router-core\" nodes)
  then true
  else throw \"wg-host128-egress must terminate on hetz-router-nebula-core and leave WAN egress on hetz-router-core\"
" >/dev/null

if [[ -d "${compiler_repo}" ]]; then
  (
    cd "${compiler_repo}"
    nix run .#compile -- "${lab_dir}/intent.nix" >/dev/null
  )
else
  echo "WARN lab-sigma-wireguard-host128-core-split: compiler repo not present, skipped compile proof" >&2
fi

echo "PASS lab-sigma-wireguard-host128-core-split"
