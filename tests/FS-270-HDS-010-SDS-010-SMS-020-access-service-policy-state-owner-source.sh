#!/usr/bin/env bash
# GAMP-ID: FS-270-HDS-010-SDS-010-SMS-020
# GAMP-SCOPE: row-local isolated source contract
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
trace_id="FS-270-HDS-010-SDS-010-SMS-020"
row="${repo_root}/GAMP/SMT/${trace_id}"

fail() {
  echo "FAIL ${trace_id}: $*" >&2
  exit 1
}

for required in \
  "${row}/default.nix" \
  "${row}/intent.nix" \
  "${row}/inventory-router.nix" \
  "${row}/inventory-nixos.nix" \
  "${row}/inventory-clab.nix" \
  "${row}/inventory-test-clients.nix" \
  "${row}/intent-test-clients.nix"; do
  [[ -f "${required}" ]] || fail "missing row source ${required}"
done

FS270_ROW="${row}" nix eval --impure --expr '
  let
    row = builtins.getEnv "FS270_ROW";
    intent = (import (row + "/intent.nix")).mini-smt.FS-270-HDS-010-SDS-010-SMS-020;
    nixos = import (row + "/inventory-nixos.nix");
    clab = import (row + "/inventory-clab.nix");
    clients = import (row + "/intent-test-clients.nix");
    rowRecord = import (row + "/default.nix");
    require = condition: message: if condition then true else throw message;
    relationById = builtins.listToAttrs (map
      (relation: { name = relation.id; value = relation; })
      intent.communicationContract.relations);
    allow = relationById.FS-270-HDS-010-SDS-010-SMS-020__source-to-destination-icmp;
    reverseDeny = relationById.FS-270-HDS-010-SDS-010-SMS-020__deny-reverse-new-flow;
    service = builtins.head intent.communicationContract.services;
    endpoint = builtins.head intent.ownership.endpoints;
    nodeNames = builtins.attrNames intent.topology.nodes;
    routerVlans = inventory:
      builtins.filter (vlan: vlan != null) (builtins.concatLists (
        map
          (host: map (bridge: bridge.vlan or null)
            (builtins.attrValues (host.bridgeNetworks or { })))
          (builtins.attrValues inventory.deployment.hosts)
      ));
    realizedNodeNames = inventory:
      map (node: node.logicalNode.name) (builtins.attrValues inventory.realization.nodes);
    clientAssignments = builtins.attrValues clients.endpointAssignment;
    destinationClients = builtins.filter (client: client.tenant == "destination") clientAssignments;
  in
    require (rowRecord.status == "NOT OK")
      "row must remain NOT OK before construction and cold-stage evidence"
    && require (builtins.length intent.communicationContract.relations == 2)
      "fixture must contain exactly one forward allow and one reverse new-flow deny"
    && require (
      allow.from == { kind = "tenant"; name = "source"; }
      && allow.to == { kind = "service"; name = "destination-icmp"; }
      && allow.trafficType == "icmp"
      && allow.action == "allow"
      && allow.returnBehavior == "symmetric")
      "forward relation must be the bounded symmetric tenant-to-service contract"
    && require (
      reverseDeny.from == { kind = "tenant"; name = "destination"; }
      && reverseDeny.to == { kind = "tenant"; name = "source"; }
      && reverseDeny.action == "deny")
      "independently initiated reverse traffic must remain denied"
    && require (
      service.providers == [ "destination-endpoint" ]
      && endpoint.name == "destination-endpoint"
      && endpoint.tenant == "destination"
      && endpoint.ipv4 == [ "10.27.71.10" ]
      && endpoint.ipv6 == [ "fd42:270:71::10" ])
      "service provider must be the isolated destination endpoint"
    && require (nodeNames == [ "access-destination" "access-source" "downstream-selector" "policy" ])
      "logical fixture must contain only two access nodes, one selector, and one policy owner"
    && require (routerVlans nixos == [ 408 407 ])
      "NixOS router inventory must use only isolated VLANs 407 and 408"
    && require (routerVlans clab == [ 410 409 ])
      "CLAB router inventory must use only isolated VLANs 409 and 410"
    && require (builtins.length (realizedNodeNames nixos) == 4)
      "NixOS inventory must explicitly realize four runtime nodes"
    && require (builtins.length (realizedNodeNames clab) == 4)
      "CLAB inventory must explicitly realize four runtime nodes"
    && require (builtins.length clientAssignments == 4)
      "test-client intent must define four substrate-specific endpoints"
    && require (builtins.all
      (client:
        client.family == "dual"
        && client.mode == "static"
        && client.owningSubstrate == "s-router-test-clients"
        && client.static ? address
        && client.static ? address6
        && client.static ? gateway4
        && client.static ? gateway6)
      clientAssignments)
      "every test endpoint must carry explicit dual-stack static addressing"
    && require (builtins.all
      (client:
        client.static.address == "10.27.71.10"
        && client.static.address6 == "fd42:270:71::10")
      destinationClients)
      "both renderer destinations must own the service endpoint addresses"
' >/dev/null || fail "row-local isolated source contract failed"

echo "PASS ${trace_id}: isolated NixOS and CLAB tenant-to-service policy-state source is complete"
