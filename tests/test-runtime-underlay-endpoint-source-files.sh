#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

REPO_ROOT="${repo_root}" nix eval --impure --expr '
  let
    inventory = import (builtins.getEnv "REPO_ROOT" + "/examples/s-router-overlay-dns-lane-policy/inventory-nixos.nix");
    labInventory = import (builtins.getEnv "REPO_ROOT" + "/labs/lab-s-sigma/s-router-test-three-site/inventory-nixos.nix");

    hasSourceFiles = siteKey: inv:
      let
        sites = inv.controlPlane.sites;
        lighthouse =
          sites.espbranch.${siteKey}.overlays.east-west.nebula.lighthouse;
      in
        (lighthouse.endpointSourceFile or "") != ""
        && (lighthouse.endpoint6SourceFile or "") != "";
  in
    if hasSourceFiles "site-b" inventory && hasSourceFiles "clab" labInventory then
      true
    else
      throw "runtime underlay endpoint source files are required for live Hetzner lighthouse routes"
' >/dev/null

echo "PASS runtime-underlay-endpoint-source-files"
