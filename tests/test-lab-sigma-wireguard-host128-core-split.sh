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
  overlayByName = name:
    let matches = builtins.filter (overlay: (overlay.name or null) == name) overlays;
    in if matches == [] then throw \"missing \${name} overlay\" else builtins.head matches;
  overlay128 = overlayByName \"wg-host128-egress\";
  overlay64 = overlayByName \"wg-routed64\";
  nodes128 = inventory.controlPlane.sites.esp.hetz.overlays.wg-host128-egress.nodes or {};
  nodes64 = inventory.controlPlane.sites.esp.hetz.overlays.wg-routed64.nodes or {};
  uplinks = intent.esp.hetz.topology.nodes.hetz-router-nebula-core.uplinks or {};
in
  if overlay128.terminateOn == \"hetz-router-nebula-core\"
    && overlay64.terminateOn == \"hetz-router-nebula-core\"
    && builtins.hasAttr \"wg-host128-egress\" uplinks
    && builtins.hasAttr \"wg-routed64\" uplinks
    && builtins.hasAttr \"hetz-router-nebula-core\" nodes128
    && builtins.hasAttr \"hetz-router-nebula-core\" nodes64
    && !(builtins.hasAttr \"hetz-router-core\" nodes128)
    && !(builtins.hasAttr \"hetz-router-core\" nodes64)
  then true
  else throw \"WireGuard provider overlays must terminate on hetz-router-nebula-core and leave WAN egress on hetz-router-core\"
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
