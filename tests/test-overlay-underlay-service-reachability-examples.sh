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

    hasUnderlayAllow = overlayName: underlayName: contract:
      builtins.any
        (rel:
          (rel.action or null) == "allow"
          && (rel.trafficType or null) == "nebula"
          && (rel.from.kind or null) == "external"
          && (rel.from.name or null) == overlayName
          && (rel.to.kind or null) == "external"
          && builtins.elem underlayName (rel.to.uplinks or [ ]))
        (contract.relations or [ ]);

    checkSite = example: enterprise: site: overlayName: underlayName:
      let
        intent = import (root + "/examples/" + example + "/intent.nix");
        contract = intent.${enterprise}.${site}.communicationContract;
      in
        if !(hasNebulaTrafficType contract) then
          throw "${example} ${enterprise}.${site} missing concrete nebula traffic type for overlay underlay reachability"
        else if !(hasUnderlayAllow overlayName underlayName contract) then
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
