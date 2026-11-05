#!/usr/bin/env bash
set -euo pipefail
# LAB-SMT-ID: LAB-SMT-002
# LAB-SMT-SCOPE: examples-only; see tests/SMT.md

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

REPO_ROOT="${repo_root}" nix eval --impure --expr '
  let
    root = builtins.getEnv "REPO_ROOT";

    hasNebulaTrafficType = contract:
      builtins.any
        (trafficType:
          (trafficType.name or null) == "nebula"
          && builtins.any
            (match:
              (match.family or null) == "any"
              && builtins.elem (match.proto or null) [ "tcp" "udp" ]
              && builtins.elem 4242 (match.dports or [ ]))
            (trafficType.match or [ ]))
        (contract.trafficTypes or [ ]);

    # The underlay bootstrap path must be explicitly allowed (deny-by-default).
    # The current relation contract names the destination as a scope that owns
    # the uplink, so accept to.scope resolving to a node that declares the
    # underlay uplink as well as the older direct to.uplinks list.
    nodeDeclaresUplink = underlayName: site: scope:
      let
        nodes = (site.topology or { }).nodes or { };
        node = nodes.${scope} or null;
        uplinks = if builtins.isAttrs node then node.uplinks or null else null;
      in
      builtins.isAttrs uplinks && builtins.hasAttr underlayName uplinks;

    hasUnderlayAllow = overlayName: underlayName: site:
      let contract = site.communicationContract; in
      builtins.any
        (rel:
          (rel.action or null) == "allow"
          && (rel.trafficType or null) == "nebula"
          && (rel.from.kind or null) == "external"
          && (rel.from.name or null) == overlayName
          && (rel.to.kind or null) == "external"
          && (
            builtins.elem underlayName (rel.to.uplinks or [ ])
            || (
              builtins.isString (rel.to.scope or null)
              && nodeDeclaresUplink underlayName site rel.to.scope
            )
          ))
        (contract.relations or [ ]);

    checkSite = example: enterprise: site: overlayName: underlayName:
      let
        intent = import (root + "/examples/" + example + "/intent.nix");
        siteAttrs = intent.${enterprise}.${site};
        contract = siteAttrs.communicationContract;
      in
        if !(hasNebulaTrafficType contract) then
          throw "${example} ${enterprise}.${site} missing concrete nebula traffic type for overlay underlay reachability"
        else if !(hasUnderlayAllow overlayName underlayName siteAttrs) then
          throw "${example} ${enterprise}.${site} missing explicit ${overlayName} -> ${underlayName} nebula underlay allow relation"
        else
          true;
  in
    if
      checkSite "overlay-east-west" "enterprise-a" "site-a" "east-west" "isp"
      && checkSite "overlay-east-west" "enterprise-b" "site-b" "east-west" "isp"
    then
      true
    else
      false
' >/dev/null

echo "PASS overlay-underlay-service-reachability-examples"
