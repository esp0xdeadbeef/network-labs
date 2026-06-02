#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="${repo_root}/sat"

nix eval --extra-experimental-features 'nix-command flakes' --impure --expr "
let
  inventory = import ${lab_dir}/getInventory.nix { renderer = \"nixos\"; };
  hosts = inventory.deployment.hosts or { };
  routerBridges = (hosts.s-router-test or { }).bridgeNetworks or { };
  clientBridges = (hosts.s-router-test-clients or { }).bridgeNetworks or { };
  allowedNonRouterBridges = [ ];
  invalidBridges =
    builtins.filter
      (bridgeName:
        !(builtins.hasAttr bridgeName routerBridges)
        && !(builtins.elem bridgeName allowedNonRouterBridges))
      (builtins.attrNames clientBridges);
  messages =
    map
      (bridgeName:
        \"s-router-test-clients bridge '\${bridgeName}' has no matching router-side access bridge in s-router-test. Remove stale local client fixtures or model the router/client placement explicitly before validating DNS; this error may only be removed after the lab owns endpoint placement through inventory, not local NixOS glue.\")
      invalidBridges;
in
  if messages != [ ] then
    throw (builtins.concatStringsSep \"\\n\" messages)
  else
    true
" >/dev/null

echo "PASS s-router-client-bridge-contract"
