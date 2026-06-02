#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

REPO_ROOT="${repo_root}" nix eval --impure --expr '
  let
    inventory = import (builtins.getEnv "REPO_ROOT" + "/examples/s-router-overlay-dns-lane-policy/inventory-nixos.nix");
    labInventory = import (builtins.getEnv "REPO_ROOT" + "/sat/inventory-nixos.nix");

    hasSourceFiles = siteKey: inv:
      let
        sites = inv.controlPlane.sites;
        overlay = sites.espbranch.${siteKey}.overlays.east-west;
        lighthouse = overlay.nebula.lighthouse;
        endpointSourceFiles4 = overlay.underlayEndpointSourceFiles.ipv4 or [];
        endpointSourceFiles6 = overlay.underlayEndpointSourceFiles.ipv6 or [];
      in
        (lighthouse.endpointSourceFile or "") != ""
        && (lighthouse.endpoint6SourceFile or "") != ""
        && builtins.elem lighthouse.endpointSourceFile endpointSourceFiles4
        && builtins.elem lighthouse.endpoint6SourceFile endpointSourceFiles6
        && builtins.elem "/run/secrets/hetzner-public-ipv4" endpointSourceFiles4;
  in
    if hasSourceFiles "site-b" inventory && hasSourceFiles "clab" labInventory then
      true
    else
      throw "runtime underlay endpoint source files are required for live Hetzner lighthouse and relay public routes"
' >/dev/null

echo "PASS runtime-underlay-endpoint-source-files"
