#!/usr/bin/env bash
# GAMP-IDS: FS-770-HDS-010-SDS-010-SMS-030
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
hat_dir="${repo_root}/GAMP/HAT/emulated-isp-residential-testnet"

fail() {
  echo "FAIL fs770-realization-fact-classification: $*" >&2
  exit 1
}

if rg -in 'endpointClients|bridgeNetworks|providerAccess|wanGroupToUplink|usernameFile|runtimeInterface|stateContracts|persistenceExpectation|managementBoundary' "${hat_dir}/intent.nix" >&2; then
  fail "shared intent must not carry realization-fact classes"
fi

HAT_DIR="${hat_dir}" nix eval --impure --expr '
  let
    root = builtins.getEnv "HAT_DIR";
    nixos = import (root + "/inventory-nixos.nix");
    clab = import (root + "/inventory-clab.nix");
    nixosHost = nixos.deployment.hosts.s-router-nixos;
    clientHost = nixos.deployment.hosts.s-router-test-clients;
    clabHost = clab.deployment.hosts.s-router-clab;
    endpointClients = (clientHost.hat.endpointClients or { }) // (clabHost.hat.endpointClients or { });
    endpointNames = builtins.attrNames endpointClients;
    require = cond: msg: if cond then true else throw msg;
    endpointHasRuntimeClassification = name:
      let
        endpoint = endpointClients.${name};
      in
        (endpoint ? owningSubstrate)
        && (endpoint ? assignment)
        && (endpoint ? tenant)
        && (endpoint ? persistenceExpectation)
        && (endpoint ? managementBoundary);
    endpointHasBoundaryDetails = name:
      let
        endpoint = endpointClients.${name};
        persistence = endpoint.persistenceExpectation or { };
        management = endpoint.managementBoundary or { };
      in
        (persistence ? kind)
        && (persistence ? required)
        && (management ? mode)
        && (management.fixturePlacementCreatesManagementAccess or null) == false;
    nodeHostIs = inventory: nodeName: expectedHost:
      ((inventory.realization.nodes.${nodeName} or { }).host or null) == expectedHost;
  in
    require (builtins.all endpointHasRuntimeClassification endpointNames)
      "endpoint fixtures must remain classified as inventory/runtime facts"
    && require (builtins.all endpointHasBoundaryDetails endpointNames)
      "endpoint fixtures must retain persistence and management boundary detail in inventory/runtime data"
    && require ((nixosHost.bridgeNetworks.client.vlan or null) == 302)
      "NixOS bridge/VLAN realization must remain in inventory"
    && require ((nixosHost.wanGroupToUplink."esp0xdeadbeef::site-a::nixos-core-upstream-vlan4" or null) == "uplink-isp-a")
      "NixOS WAN uplink realization must remain in inventory"
    && require ((clabHost.hat.providerAccess.residentialPppoeHostTestnet.distribution.endpoint or null) == "clab-core-testnet-host-isp")
      "CLAB provider-access endpoint realization must remain in inventory"
    && require ((nixosHost.hat.providerAccess.residentialPppoeHostTestnet.distribution.endpoint or null) == "nixos-core-testnet-host-isp")
      "NixOS provider-access endpoint realization must remain in inventory"
    && require (nodeHostIs nixos "esp0xdeadbeef-site-a-nixos-core-testnet-host-isp" "s-router-nixos")
      "NixOS realization host bindings must remain in inventory"
    && require (nodeHostIs clab "esp0xdeadbeef-site-b-clab-core-testnet-host-isp" "s-router-clab")
      "CLAB realization host bindings must remain in inventory"
    && require (((endpointClients.nixos-printer01 or { }).serviceSurfaces.ipp.service or null) == "hat-printer-ipp")
      "NixOS service-surface realization must remain in inventory"
' >/dev/null || fail "realization-fact classification validation failed"

echo "PASS fs770-realization-fact-classification"
