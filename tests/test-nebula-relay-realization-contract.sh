#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

check_inventory() {
  local inventory_expr="$1"
  local label="$2"

  nix eval --extra-experimental-features 'nix-command flakes' --impure --expr "
  let
    inventory = ${inventory_expr};
    enterpriseSites =
      if inventory.controlPlane.sites ? esp0xdeadbeef then inventory.controlPlane.sites.esp0xdeadbeef else inventory.controlPlane.sites.esp;
    branchSites =
      if inventory.controlPlane.sites ? espbranch then inventory.controlPlane.sites.espbranch else inventory.controlPlane.sites.esp;
    siteA =
      if enterpriseSites ? site-a then
        enterpriseSites.site-a.overlays.east-west.runtimeNodes
      else
        enterpriseSites.nixos.overlays.east-west.runtimeNodes;
    siteB =
      if branchSites ? site-b then
        branchSites.site-b.overlays.east-west.runtimeNodes
      else
        branchSites.clab.overlays.east-west.runtimeNodes;
    siteC =
      if enterpriseSites ? site-c then
        enterpriseSites.site-c.overlays.east-west.runtimeNodes
      else
        enterpriseSites.hetz.overlays.east-west.runtimeNodes;
    siteARelays =
      if siteA ? s-router-core-nebula then siteA.s-router-core-nebula.relay.relays or [ ] else siteA.nixos-router-core-nebula.relay.relays or [ ];
    siteBRelays =
      if siteB ? b-router-core-nebula then siteB.b-router-core-nebula.relay.relays or [ ] else siteB.clab-router-core-nebula.relay.relays or [ ];
    siteCAmRelay =
      if siteC ? c-router-nebula-core then siteC.c-router-nebula-core.relay.amRelay or false else siteC.hetz-router-nebula-core.relay.amRelay or false;
    siteCRelayName =
      if siteC ? c-router-nebula-core then \"c-router-nebula-core\" else \"hetz-router-nebula-core\";
  in
    if siteCAmRelay != true then
      throw \"${label}: c-router-nebula-core must be modeled as the dedicated Nebula relay in inventory runtimeNodes\"
    else if siteARelays != [ siteCRelayName ] then
      throw \"${label}: s-router-core-nebula must advertise c-router-nebula-core as its explicit Nebula relay\"
    else if siteBRelays != [ siteCRelayName ] then
      throw \"${label}: b-router-core-nebula must advertise c-router-nebula-core as its explicit Nebula relay\"
    else
      true
  " >/dev/null
}

check_inventory \
  "import ${repo_root}/examples/s-router-overlay-dns-lane-policy/inventory-nixos.nix" \
  "examples/s-router-overlay-dns-lane-policy"

check_inventory \
  "import ${repo_root}/labs/lab-s-sigma/s-router-test-three-site/getInventory.nix { renderer = \"nixos\"; }" \
  "labs/lab-s-sigma/s-router-test-three-site"

echo "PASS nebula-relay-realization-contract"
