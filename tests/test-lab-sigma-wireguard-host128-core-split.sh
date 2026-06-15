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
  pools = intent.esp.hetz.overlayAddressPools or {};
in
  if overlay128.terminateOn == \"hetz-router-nebula-core\"
    && overlay64.terminateOn == \"hetz-router-nebula-core\"
    && builtins.hasAttr \"wg-host128-egress\" uplinks
    && builtins.hasAttr \"wg-routed64\" uplinks
    && pools.east-west.ipv4.prefix == \"100.96.10.0/24\"
    && pools.wg-host128-egress.ipv4.prefix == \"10.66.128.0/24\"
    && pools.wg-routed64.ipv4.prefix == \"10.66.64.0/24\"
    && builtins.hasAttr \"hetz-router-nebula-core\" nodes128
    && builtins.hasAttr \"hetz-router-nebula-core\" nodes64
    && !(builtins.hasAttr \"hetz-router-core\" nodes128)
    && !(builtins.hasAttr \"hetz-router-core\" nodes64)
  then true
  else throw \"WireGuard provider overlays must terminate on hetz-router-nebula-core with segmented overlay IPAM and leave WAN egress on hetz-router-core\"
" >/dev/null

# SMS-020 CMC: Removed downstream compiler invocation (nix run .#compile
# inside network-compiler repo). Compiler compile-proof validation must
# live in network-compiler/tests/.
# The nix eval above preserves pure local data validation of intent/inventory.

echo "PASS lab-sigma-wireguard-host128-core-split"
