#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

check_inventory() {
  local lab_dir="$1"
  local inventory_name="$2"
  local label="$3"

  nix eval --extra-experimental-features 'nix-command flakes' --impure --expr "
  let
    intent = import ${lab_dir}/intent.nix;
    inventory = import ${lab_dir}/${inventory_name};
    concatMap = f: xs: builtins.concatLists (map f xs);
    siteChecks =
      concatMap
        (enterpriseName:
          concatMap
            (siteName:
              let
                intentSite = intent.\${enterpriseName}.\${siteName};
                inventorySite = inventory.controlPlane.sites.\${enterpriseName}.\${siteName};
                topologyNodes = builtins.attrNames (intentSite.topology.nodes or { });
                overlayNames = builtins.attrNames (inventorySite.overlays or { });
              in
              concatMap
                (overlayName:
                  let
                    overlay = inventorySite.overlays.\${overlayName};
                    lighthouseNode = overlay.nebula.lighthouse.node or null;
                    allowedNodes =
                      topologyNodes
                      ++ (if lighthouseNode == null then [ ] else [ lighthouseNode ]);
                    runtimeNodeNames = builtins.attrNames (overlay.runtimeNodes or { });
                    invalidRuntimeNodes = builtins.filter
                      (nodeName: !(builtins.elem nodeName allowedNodes))
                      runtimeNodeNames;
                  in
                  map
                    (nodeName:
                      \"${label}: overlay runtime node '\${nodeName}' is not a topology node or lighthouse in \${enterpriseName}.\${siteName}.\${overlayName}; remove the runtime node or model it explicitly in intent before a renderer materializes it\")
                    invalidRuntimeNodes)
                overlayNames)
            (builtins.attrNames intent.\${enterpriseName}))
        (builtins.attrNames intent);
  in
    if siteChecks != [ ] then
      throw (builtins.concatStringsSep \"\\n\" siteChecks)
    else
      true
  " >/dev/null
}

check_inventory \
  "${repo_root}/examples/s-router-overlay-dns-lane-policy" \
  "inventory-nixos.nix" \
  "examples/s-router-overlay-dns-lane-policy/inventory-nixos.nix"

check_inventory \
  "${repo_root}/examples/s-router-overlay-dns-lane-policy" \
  "inventory-clab.nix" \
  "examples/s-router-overlay-dns-lane-policy/inventory-clab.nix"

check_inventory \
  "${repo_root}/labs/lab-s-sigma/s-router-test-three-site" \
  "inventory-nixos.nix" \
  "labs/lab-s-sigma/s-router-test-three-site/inventory-nixos.nix"

check_inventory \
  "${repo_root}/labs/lab-s-sigma/s-router-test-three-site" \
  "inventory-clab.nix" \
  "labs/lab-s-sigma/s-router-test-three-site/inventory-clab.nix"

echo "PASS nebula-runtime-node-intent-contract"
