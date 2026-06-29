#!/usr/bin/env bash
# GAMP-ID: FS-800-HDS-030-SDS-010-SMS-010
# GAMP-SCOPE: network-labs SMT/SIT source fixture proof; not HAT/SAT live evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
trace_id="FS-800-HDS-030-SDS-010-SMS-010"

fail() {
  echo "FAIL ${trace_id}: $*" >&2
  exit 1
}

REPO_ROOT="${repo_root}" nix eval --impure --raw --expr '
  let
    root = builtins.getEnv "REPO_ROOT";
    table = import (root + "/GAMP/SAT/provider-access-fixture-table.nix");
    hatIntent = import (root + "/GAMP/HAT/emulated-isp-residential-testnet/intent.nix");
    nixosInventory = import (root + "/GAMP/HAT/emulated-isp-residential-testnet/inventory-nixos.nix");
    clabInventory = import (root + "/GAMP/HAT/emulated-isp-residential-testnet/inventory-clab.nix");
    traceId = "FS-800-HDS-030-SDS-010-SMS-010";

    require = cond: msg: if cond then true else throw msg;
    has = value: list: builtins.elem value list;
    hasUndirectedLink = links: a: b:
      builtins.any (link: link == [ a b ] || link == [ b a ]) links;
    pathPresent = value: path:
      if path == [ ] then true
      else
        let
          key = builtins.head path;
          rest = builtins.tail path;
        in
          builtins.isAttrs value && builtins.hasAttr key value && pathPresent value.${key} rest;

    tableProviderOk = name: row:
      require (row.provider.role == "emulated-isp")
        "${traceId}: ${name} must declare emulated-isp provider role"
      && require (row.provider.handoff == "pppoe")
        "${traceId}: ${name} must declare PPPoE provider handoff"
      && require (row.provider.addressDelivery.ipv4 == "pppoe-session-address")
        "${traceId}: ${name} must declare PPPoE IPv4 session address delivery"
      && require (row.provider.addressDelivery.ipv6 == "pppoe-delegated-prefix")
        "${traceId}: ${name} must declare PPPoE IPv6 delegated-prefix delivery"
      && require (has "wan-dhcp" row.provider.addressDelivery.excluded)
        "${traceId}: ${name} must exclude WAN DHCP fallback"
      && require (has "wan-slaac" row.provider.addressDelivery.excluded)
        "${traceId}: ${name} must exclude WAN SLAAC fallback"
      && require (has [ "provider" "role" ] row.requiredFields)
        "${traceId}: ${name} must require provider.role before downstream inference"
      && require (has [ "provider" "handoff" ] row.requiredFields)
        "${traceId}: ${name} must require provider.handoff before downstream inference"
      && require (has [ "provider" "addressDelivery" "ipv4" ] row.requiredFields)
        "${traceId}: ${name} must require provider IPv4 delivery before downstream inference"
      && require (has [ "provider" "addressDelivery" "ipv6" ] row.requiredFields)
        "${traceId}: ${name} must require provider IPv6 delivery before downstream inference";

    fixtureProviderOk = inventory: host: expectedBridge: expectedEndpoint:
      let
        row = inventory.deployment.hosts.${host}.hat.providerAccess.residentialPppoeHostTestnet;
      in
        require (row.handoff == "pppoe")
          "${traceId}: ${host} HAT fixture must declare PPPoE handoff"
        && require (row.harness == host)
          "${traceId}: ${host} HAT fixture harness must match host"
        && require (row.distribution.technology == "pppoe")
          "${traceId}: ${host} HAT fixture must use PPPoE distribution technology"
        && require (row.distribution.mode == "endpoint-specific")
          "${traceId}: ${host} HAT fixture must keep PPPoE endpoint-specific"
        && require (row.distribution.endpoint == expectedEndpoint)
          "${traceId}: ${host} HAT fixture endpoint mismatch"
        && require (row.l2Surface.kind == "isolated-bridge")
          "${traceId}: ${host} HAT fixture must use isolated bridge handoff"
        && require (row.l2Surface.name == expectedBridge)
          "${traceId}: ${host} HAT fixture bridge mismatch"
        && require (row.l2Surface.physical == false)
          "${traceId}: ${host} HAT fixture must not require physical handoff"
        && require (row.credentials.labOnly == true)
          "${traceId}: ${host} HAT fixture credentials must be lab-only"
        && require (row.credentials.usernameFile == "hat-pppoe-username")
          "${traceId}: ${host} HAT fixture username secret mismatch"
        && require (row.credentials.passwordFile == "hat-pppoe-password")
          "${traceId}: ${host} HAT fixture password secret mismatch"
        && require (has "pppoe-session-up" row.probeIntent)
          "${traceId}: ${host} HAT fixture must require PPPoE session probe";

    noIntentPppoeBypassLink = site: coreNode: providerNode:
      let
        links = hatIntent.esp0xdeadbeef.${site}.topology.links;
      in
        require (!(hasUndirectedLink links coreNode providerNode))
          "${traceId}: HAT intent must not bypass canonical topology with direct PPPoE handoff link ${coreNode}<->${providerNode}";

    providerNodeOk = inventory: node: expectedHost: expectedName: expectedInterface: expectedTenantInterface: expectedTenantRuntimeInterface: providerAddress: customerAddress:
      let
        server = node.services.pppoe.server;
        lowerPort =
          if builtins.hasAttr expectedInterface node.ports
          then builtins.getAttr expectedInterface node.ports
          else { };
        lowerBridge = lowerPort.attach.bridge or null;
        tenantPort =
          if builtins.hasAttr expectedTenantInterface node.ports
          then builtins.getAttr expectedTenantInterface node.ports
          else { };
        tenantBridge = tenantPort.attach.bridge or null;
        hostBridgeNetworks = inventory.deployment.hosts.${expectedHost}.bridgeNetworks or { };
      in
        require (node.host == expectedHost)
          "${traceId}: provider node host mismatch"
        && require (node.logicalNode.name == expectedName)
          "${traceId}: provider node logical name mismatch"
        && require (pathPresent node [ "services" "pppoe" "server" ])
          "${traceId}: provider node must carry a PPPoE server service"
        && require (server.implementation == "rp-pppoe")
          "${traceId}: provider PPPoE server implementation mismatch"
        && require (server.interface == expectedInterface)
          "${traceId}: provider PPPoE server interface mismatch"
        && require (builtins.hasAttr expectedInterface node.ports)
          "${traceId}: provider PPPoE server lower interface must exist in node ports"
        && require ((lowerPort.serviceInterface or null) == expectedInterface)
          "${traceId}: provider PPPoE server lower interface serviceInterface mismatch"
        && require (!(lowerPort ? link))
          "${traceId}: provider PPPoE server lower interface must not masquerade as a forwarding-model link"
        && require (lowerPort.interface.name == "ens20")
          "${traceId}: provider PPPoE server lower interface must render on ens20"
        && require (builtins.isString lowerBridge && builtins.hasAttr lowerBridge hostBridgeNetworks)
          "${traceId}: provider PPPoE server lower interface bridge must exist in host bridgeNetworks"
        && require (builtins.hasAttr expectedTenantInterface node.ports)
          "${traceId}: provider handoff tenant interface must exist in node ports"
        && require ((tenantPort.logicalInterface or null) == expectedTenantInterface)
          "${traceId}: provider handoff tenant logicalInterface mismatch"
        && require (tenantPort.interface.name == expectedTenantRuntimeInterface)
          "${traceId}: provider handoff tenant interface name mismatch"
        && require (builtins.isString tenantBridge && builtins.hasAttr tenantBridge hostBridgeNetworks)
          "${traceId}: provider handoff tenant bridge must exist in host bridgeNetworks"
        && require (server.providerAddress == providerAddress)
          "${traceId}: provider PPPoE server provider address mismatch"
        && require (server.customerAddress == customerAddress)
          "${traceId}: provider PPPoE server customer address mismatch"
        && require (server.mtu == 1492)
          "${traceId}: provider PPPoE server MTU must be 1492"
        && require (server.maxSessions == 32)
          "${traceId}: provider PPPoE server max session limit mismatch"
        && require (server.credentials.usernameFile == "/run/secrets/hat-pppoe-username")
          "${traceId}: provider PPPoE server username secret path mismatch"
        && require (server.credentials.passwordFile == "/run/secrets/hat-pppoe-password")
          "${traceId}: provider PPPoE server password secret path mismatch";
  in
    if tableProviderOk "pppoeNixos" table.pppoeNixos
      && tableProviderOk "pppoeClab" table.pppoeClab
      && fixtureProviderOk nixosInventory "s-router-nixos" "br-n-pppoe" "nixos-core-testnet-host-isp"
      && fixtureProviderOk clabInventory "s-router-clab" "br-c-pppoe" "clab-core-testnet-host-isp"
      && noIntentPppoeBypassLink "site-a" "nixos-core-testnet-host-isp" "nixos-provider-handoff-access-a"
      && noIntentPppoeBypassLink "site-a" "nixos-core-testnet-routed-isp" "nixos-provider-handoff-access-b"
      && noIntentPppoeBypassLink "site-b" "clab-core-testnet-host-isp" "clab-provider-handoff-access-a"
      && noIntentPppoeBypassLink "site-b" "clab-core-testnet-routed-isp" "clab-provider-handoff-access-b"
      && providerNodeOk
        nixosInventory
        nixosInventory.realization.nodes.esp0xdeadbeef-site-a-nixos-provider-handoff-access-a
        "s-router-nixos"
        "nixos-provider-handoff-access-a"
        "p2p-nixos-core-testnet-host-isp-nixos-provider-handoff-access-a"
        "tenant-provider-handoff-a"
        "prov-handoff-a"
        "203.0.113.5"
        "203.0.113.4"
      && providerNodeOk
        nixosInventory
        nixosInventory.realization.nodes.esp0xdeadbeef-site-a-nixos-provider-handoff-access-b
        "s-router-nixos"
        "nixos-provider-handoff-access-b"
        "p2p-nixos-core-testnet-routed-isp-nixos-provider-handoff-access-b"
        "tenant-provider-handoff-b"
        "prov-handoff-b"
        "203.0.113.1"
        "203.0.113.2"
      && providerNodeOk
        clabInventory
        clabInventory.realization.nodes.esp0xdeadbeef-site-b-clab-provider-handoff-access-a
        "s-router-clab"
        "clab-provider-handoff-access-a"
        "p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a"
        "tenant-provider-handoff-a"
        "prov-handoff-a"
        "203.0.113.5"
        "203.0.113.4"
      && providerNodeOk
        clabInventory
        clabInventory.realization.nodes.esp0xdeadbeef-site-b-clab-provider-handoff-access-b
        "s-router-clab"
        "clab-provider-handoff-access-b"
        "p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b"
        "tenant-provider-handoff-b"
        "prov-handoff-b"
        "203.0.113.1"
        "203.0.113.2"
    then "true"
    else "unreachable"
' >/dev/null || fail "provider-side source fixture validation failed"

echo "PASS ${trace_id}"
