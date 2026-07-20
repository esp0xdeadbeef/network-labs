#!/usr/bin/env bash
# GAMP-ID: FS-750-HDS-010-SDS-010-SMS-020
# GAMP-ID: FS-750-HDS-010-SDS-010-SMS-030
# GAMP-SCOPE: software-module-test
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
hat_dir="${repo_root}/GAMP/HAT/emulated-isp-residential-testnet"

fail() {
  echo "FAIL fs750-receiver-source: $*" >&2
  exit 1
}

HAT_DIR="${hat_dir}" nix eval --impure --expr '
  let
    root = builtins.getEnv "HAT_DIR";
    intent = import (root + "/intent.nix");
    nixos = import (root + "/inventory-nixos.nix");
    site = intent.esp0xdeadbeef.site-a;
    clients = nixos.deployment.hosts.s-router-test-clients.hat.endpointClients or { };
    receiver = clients.nixos-receiver01 or { };
    services = builtins.listToAttrs (
      map (service: { name = service.name; value = service; })
        (site.communicationContract.services or [ ])
    );
    trafficTypes = builtins.listToAttrs (
      map (trafficType: { name = trafficType.name; value = trafficType; })
        (site.communicationContract.trafficTypes or [ ])
    );
    require = cond: msg: if cond then true else throw msg;
    trafficTypeHasPort = name: proto: port:
      builtins.any
        (match: (match.proto or null) == proto && builtins.elem port (match.dports or [ ]))
        (trafficTypes.${name}.match or [ ]);
    surface = name: (receiver.serviceSurfaces or { }).${name} or { };
    authority = receiver.fixtureAuthority or { };
  in
    require (builtins.hasAttr "nixos-receiver01" clients)
      "FS-750 receiver source must declare the NixOS receiver endpoint"
    && require (receiver.gampId == "FS-750-HDS-010-SDS-010-SMS-010")
      "FS-750 SMS-010 must keep receiver identity ownership on the endpoint record"
    && require ((services.hat-receiver-control.providers or [ ]) == [ "nixos-receiver01" ])
      "FS-750 source must keep control service provider authority in intent"
    && require ((services.hat-receiver-discovery.providers or [ ]) == [ "nixos-receiver01" ])
      "FS-750 source must keep discovery service provider authority in intent"
    && require (trafficTypeHasPort "cast-control" "tcp" 8008 && trafficTypeHasPort "cast-control" "tcp" 8009)
      "FS-750 source must model Cast control tcp/8008 and tcp/8009"
    && require ((surface "control").gampId == "FS-750-HDS-010-SDS-010-SMS-020")
      "FS-750 SMS-020 must own receiver payload-port source records"
    && require ((surface "control").service == "hat-receiver-control")
      "FS-750 SMS-020 must bind the payload-port record to hat-receiver-control"
    && require ((surface "control").protocol == "tcp" && (surface "control").ports == [ 8008 8009 ])
      "FS-750 SMS-020 must preserve the modeled receiver payload ports one-to-one"
    && require ((surface "discovery").service == "hat-receiver-discovery")
      "FS-760 discovery authority must stay separate from FS-750 payload-port records"
    && require ((surface "discovery").protocol == "udp" && (surface "discovery").ports == [ 5353 1900 ])
      "FS-760 discovery surface must stay on modeled discovery UDP ports"
    && require (authority.gampId == "FS-750-HDS-010-SDS-010-SMS-030")
      "FS-750 SMS-030 must own the receiver fixture non-authority contract"
    && require (authority.mayInferPolicy == false)
      "FS-750 source must not infer policy from receiver fixture placement"
    && require (authority.mayGrantDiscovery == false)
      "FS-750 source must not grant discovery authority from receiver fixture presence"
    && require (authority.mayGrantPayloadAccess == false)
      "FS-750 source must not grant payload authority from receiver fixture presence"
    && require (authority.mayGrantReverseInitiation == false)
      "FS-750 source must not grant reverse-initiation authority from receiver fixture presence"
    && require (authority.mayGrantMulticastForwarding == false)
      "FS-750 source must not grant multicast authority from receiver fixture presence"
    && require (authority.mayGrantTenantReachability == false)
      "FS-750 source must not grant tenant reachability from receiver fixture presence"
    && require (authority.mayGrantManagementAccess == false)
      "FS-750 source must not grant management access from receiver fixture presence"
    && require (authority.policyAuthority == "intent-communication-contract")
      "FS-750 source must leave receiver discovery and payload authority in intent"
' >/dev/null || fail "receiver payload-port or non-authority atoms are incomplete"

echo "PASS fs750-receiver-source"
