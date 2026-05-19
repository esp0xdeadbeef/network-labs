#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

check_inventory() {
  local inventory_expr="$1"
  local label="$2"

  nix eval --extra-experimental-features 'nix-command flakes' --impure --expr "
  let
    inventory = ${inventory_expr};
    sites = inventory.controlPlane.sites;
    requireNode = site: overlay: node:
      let
        entry = sites.\${site.enterprise}.\${site.name}.overlays.\${overlay}.nodes.\${node} or null;
      in
        if entry == null then
          throw \"${label}: missing overlay realization for \${site.enterprise}.\${site.name} \${overlay} \${node}\"
        else if !(entry ? addr4) || !(entry ? addr6) then
          throw \"${label}: overlay node \${node} must carry addr4 and addr6\"
        else if !(builtins.match \"100[.]96[.]10[.][0-9]+/32\" entry.addr4 != null) then
          throw \"${label}: overlay node \${node} addr4 must stay inside the modeled 100.96.10.0/24 pool\"
        else if !(builtins.match \".*/32\" entry.addr4 != null) then
          throw \"${label}: overlay node \${node} addr4 must be a concrete /32\"
        else if !(builtins.match \"fd42:dead:beef:ee::[0-9]+/128\" entry.addr6 != null) then
          throw \"${label}: overlay node \${node} addr6 must stay inside the modeled fd42:dead:beef:ee:: pool\"
        else if !(builtins.match \".*/128\" entry.addr6 != null) then
          throw \"${label}: overlay node \${node} addr6 must be a concrete /128\"
        else
          true;
  in
    if !(requireNode { enterprise = \"esp0xdeadbeef\"; name = \"site-a\"; } \"east-west\" \"s-router-core-nebula\") then false
    else if !(requireNode { enterprise = \"esp0xdeadbeef\"; name = \"site-a\"; } \"site-c-storage\" \"s-router-core-nebula\") then false
    else if !(requireNode { enterprise = \"espbranch\"; name = \"site-b\"; } \"east-west\" \"b-router-core-nebula\") then false
    else if !(requireNode { enterprise = \"esp0xdeadbeef\"; name = \"site-c\"; } \"site-c-storage\" \"c-router-nebula-core\") then false
    else true
  " >/dev/null
}

check_inventory \
  "import ${repo_root}/examples/tri-site-dual-wan-overlay-integration-bgp/inventory-clab.nix" \
  "tri-site-dual-wan-overlay-integration-bgp clab"

check_inventory \
  "import ${repo_root}/examples/tri-site-dual-wan-overlay-integration-bgp/inventory-nixos.nix" \
  "tri-site-dual-wan-overlay-integration-bgp nixos"

check_inventory \
  "import ${repo_root}/examples/tri-site-dual-wan-overlay-integration-static/inventory-clab.nix" \
  "tri-site-dual-wan-overlay-integration-static clab"

check_inventory \
  "import ${repo_root}/examples/tri-site-dual-wan-overlay-integration-static/inventory-nixos.nix" \
  "tri-site-dual-wan-overlay-integration-static nixos"

echo "PASS tri-site-overlay-realization"
