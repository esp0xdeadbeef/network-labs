#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

check_intent() {
  local intent_path="$1"
  local label="$2"

  LABEL="${label}" INTENT_PATH="${intent_path}" nix eval --impure --expr '
    let
      label = builtins.getEnv "LABEL";
      intent = import (builtins.getEnv "INTENT_PATH");
      sites = builtins.concatLists (
        builtins.map
          (enterprise: builtins.attrValues enterprise)
          (builtins.attrValues intent)
      );
      sitesWithNode = node:
        builtins.filter
          (site: builtins.hasAttr node (site.topology.nodes or { }))
          sites;
      siteWithAnyNode = nodes:
        let matches = builtins.concatLists (map sitesWithNode nodes);
        in builtins.head matches;
      siteB = siteWithAnyNode [ "b-router-core-nebula" "clab-router-core-nebula" ];
      siteC = siteWithAnyNode [ "c-router-nebula-core" "hetz-router-nebula-core" ];
      relations = siteB.communicationContract.relations or [ ];
      hasRelation = id:
        builtins.any (relation: (relation.id or null) == id) relations;
      siteBNebula =
        if siteB.topology.nodes ? b-router-core-nebula then
          siteB.topology.nodes.b-router-core-nebula.uplinks.east-west
        else
          siteB.topology.nodes.clab-router-core-nebula.uplinks.east-west;
      siteCNebula =
        if siteC.topology.nodes ? c-router-nebula-core then
          siteC.topology.nodes.c-router-nebula-core.uplinks.east-west
        else
          siteC.topology.nodes.hetz-router-nebula-core.uplinks.east-west;
      hasHostileEastWest =
        hasRelation "allow-hostile-to-east-west"
        || hasRelation "allow-hostile-egress-to-hetz-overlay";
    in
      if hasRelation "allow-hostile-to-wan" then
        throw "${label}: hostile tenant must not be allowed to local WAN"
      else if hasRelation "deny-hostile-dns-to-wan" then
        throw "${label}: hostile must not need a stale local-WAN DNS deny; no hostile WAN lane should exist"
      else if !hasHostileEastWest then
        throw "${label}: hostile tenant must retain east-west egress"
      else if (builtins.elem "0.0.0.0/0" (siteCNebula.ipv4 or [ ])) || (builtins.elem "::/0" (siteCNebula.ipv6 or [ ])) then
        throw "${label}: site-c Nebula core must not model east-west as a public default; site-c public egress belongs on wan"
      else if !(builtins.elem "0.0.0.0/0" (siteBNebula.ipv4 or [ ])) || !(builtins.elem "::/0" (siteBNebula.ipv6 or [ ])) then
        throw "${label}: hostile branch must retain east-west as its public-exit lane"
      else
        true
  ' >/dev/null || {
    echo "${label}: intent contract check failed" >&2
    exit 1
  }
}

check_inventory() {
  local inventory_path="$1"
  local label="$2"

  if grep -q 'router-access-hostile--uplink-wan' "${inventory_path}"; then
    echo "${label}: hostile tenant must not materialize a local WAN lane" >&2
    exit 1
  fi

  grep -q 'router-access-hostile--uplink-east-west' "${inventory_path}" || {
    echo "${label}: hostile tenant must retain east-west realization" >&2
    exit 1
  }
}

check_intent \
  "${repo_root}/examples/s-router-overlay-dns-lane-policy/intent.nix" \
  "examples/s-router-overlay-dns-lane-policy"

check_intent \
  "${repo_root}/labs/lab-s-sigma/s-router-test-three-site/intent.nix" \
  "labs/lab-s-sigma/s-router-test-three-site"

check_inventory \
  "${repo_root}/examples/s-router-overlay-dns-lane-policy/inventory-nixos.nix" \
  "examples/s-router-overlay-dns-lane-policy/inventory-nixos"

check_inventory \
  "${repo_root}/examples/s-router-overlay-dns-lane-policy/inventory-clab.nix" \
  "examples/s-router-overlay-dns-lane-policy/inventory-clab"

check_inventory \
  "${repo_root}/labs/lab-s-sigma/s-router-test-three-site/inventory.nix" \
  "labs/lab-s-sigma/s-router-test-three-site/inventory"

echo "PASS hostile-exits-east-west-only"
