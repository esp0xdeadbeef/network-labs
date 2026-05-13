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
      siteWithNode = node:
        builtins.head (
          builtins.filter
            (site: builtins.hasAttr node (site.topology.nodes or { }))
            sites
        );
      siteB = siteWithNode "b-router-core-nebula";
      siteC = siteWithNode "c-router-nebula-core";
      relations = siteB.communicationContract.relations or [ ];
      hasRelation = id:
        builtins.any (relation: (relation.id or null) == id) relations;
      siteBNebula = siteB.topology.nodes.b-router-core-nebula.uplinks.east-west;
      siteCNebula = siteC.topology.nodes.c-router-nebula-core.uplinks.east-west;
    in
      if hasRelation "allow-hostile-to-wan" then
        throw "${label}: hostile tenant must not be allowed to local WAN"
      else if hasRelation "deny-hostile-dns-to-wan" then
        throw "${label}: hostile must not need a stale local-WAN DNS deny; no hostile WAN lane should exist"
      else if !(hasRelation "allow-hostile-to-east-west") then
        throw "${label}: hostile tenant must retain east-west egress"
      else if (siteCNebula.ipv4 or [ ]) != [ ] || (siteCNebula.ipv6 or [ ]) != [ ] then
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

  if grep -q 'b-router-access-hostile--uplink-wan' "${inventory_path}"; then
    echo "${label}: hostile tenant must not materialize a local WAN lane" >&2
    exit 1
  fi

  grep -q 'b-router-access-hostile--uplink-east-west' "${inventory_path}" || {
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
  "${repo_root}/labs/lab-s-sigma/s-router-test-three-site/inventory-nixos.nix" \
  "labs/lab-s-sigma/s-router-test-three-site/inventory-nixos"

check_inventory \
  "${repo_root}/labs/lab-s-sigma/s-router-test-three-site/inventory-clab.nix" \
  "labs/lab-s-sigma/s-router-test-three-site/inventory-clab"

echo "PASS hostile-exits-east-west-only"
