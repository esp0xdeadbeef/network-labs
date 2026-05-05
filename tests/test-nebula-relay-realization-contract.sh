#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

check_inventory() {
  local inventory_path="$1"
  local label="$2"

  nix eval --extra-experimental-features 'nix-command flakes' --impure --expr "
  let
    inventory = import ${inventory_path};
    siteA = inventory.controlPlane.sites.esp0xdeadbeef.site-a.overlays.east-west.runtimeNodes;
    siteB = inventory.controlPlane.sites.espbranch.site-b.overlays.east-west.runtimeNodes;
    siteC = inventory.controlPlane.sites.esp0xdeadbeef.site-c.overlays.east-west.runtimeNodes;
    siteARelays = siteA.s-router-core-nebula.relay.relays or [ ];
    siteBRelays = siteB.b-router-core-nebula.relay.relays or [ ];
    siteCAmRelay = siteC.c-router-nebula-core.relay.amRelay or false;
  in
    if siteCAmRelay != true then
      throw \"${label}: c-router-nebula-core must be modeled as the dedicated Nebula relay in inventory runtimeNodes\"
    else if siteARelays != [ \"c-router-nebula-core\" ] then
      throw \"${label}: s-router-core-nebula must advertise c-router-nebula-core as its explicit Nebula relay\"
    else if siteBRelays != [ \"c-router-nebula-core\" ] then
      throw \"${label}: b-router-core-nebula must advertise c-router-nebula-core as its explicit Nebula relay\"
    else
      true
  " >/dev/null
}

check_inventory \
  "${repo_root}/examples/s-router-overlay-dns-lane-policy/inventory-nixos.nix" \
  "examples/s-router-overlay-dns-lane-policy"

check_inventory \
  "${repo_root}/labs/lab-s-sigma/s-router-test-three-site/inventory-nixos.nix" \
  "labs/lab-s-sigma/s-router-test-three-site"

echo "PASS nebula-relay-realization-contract"
