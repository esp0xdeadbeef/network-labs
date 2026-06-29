#!/usr/bin/env bash
# GAMP-ID: FS-800-HDS-030-SDS-020-SMS-010
# GAMP-SCOPE: network-labs SMT/SIT source fixture proof; not HAT/SAT live evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
trace_id="FS-800-HDS-030-SDS-020-SMS-010"

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
    traceId = "FS-800-HDS-030-SDS-020-SMS-010";

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

    tableCustomerOk = name: row: expectedSite: expectedCoreNode: expectedCustomerAddress:
      require (row.customer.site == expectedSite)
        "${traceId}: ${name} customer site mismatch"
      && require (row.customer.coreNode == expectedCoreNode)
        "${traceId}: ${name} customer core node mismatch"
      && require (row.customer.coreInterface == "pppoe-wan")
        "${traceId}: ${name} customer core interface must be pppoe-wan"
      && require (row.publicFacing.ipv4.customerAddress == expectedCustomerAddress)
        "${traceId}: ${name} customer IPv4 address mismatch"
      && require (row.publicFacing.ipv6.childPrefixLength == 64)
        "${traceId}: ${name} customer delegated IPv6 child prefix length mismatch"
      && require (row.publicFacing.ipv6.nat66 == false)
        "${traceId}: ${name} customer side must not require NAT66"
      && require (row.dns.followSource == true)
        "${traceId}: ${name} customer DNS must follow source"
      && require (row.dns.resolver.upstreamSource == "follow-source")
        "${traceId}: ${name} customer resolver upstream source mismatch"
      && require (has "default-route-via-pppoe" row.probeIntent)
        "${traceId}: ${name} customer probe must require PPPoE default route"
      && require (has "dns-follow-source" row.probeIntent)
        "${traceId}: ${name} customer probe must require DNS follow-source behavior"
      && require (has [ "customer" "site" ] row.requiredFields)
        "${traceId}: ${name} must require customer.site before downstream inference"
      && require (has [ "customer" "coreNode" ] row.requiredFields)
        "${traceId}: ${name} must require customer.coreNode before downstream inference"
      && require (has [ "customer" "coreInterface" ] row.requiredFields)
        "${traceId}: ${name} must require customer.coreInterface before downstream inference";

    noIntentPppoeBypassLink = site: coreNode: providerNode:
      let
        links = hatIntent.esp0xdeadbeef.${site}.topology.links;
      in
        require (!(hasUndirectedLink links coreNode providerNode))
          "${traceId}: HAT intent must not bypass canonical topology with direct PPPoE handoff link ${coreNode}<->${providerNode}";

    customerNodeOk = inventory: node: expectedHost: expectedName: expectedInterface: expectedRuntimeInterface:
      let
        client = node.services.pppoe.client;
        lowerPort =
          if builtins.hasAttr expectedInterface node.ports
          then builtins.getAttr expectedInterface node.ports
          else { };
        lowerBridge = lowerPort.attach.bridge or null;
        hostBridgeNetworks = inventory.deployment.hosts.${expectedHost}.bridgeNetworks or { };
      in
        require (node.host == expectedHost)
          "${traceId}: customer node host mismatch"
        && require (node.logicalNode.name == expectedName)
          "${traceId}: customer node logical name mismatch"
        && require (pathPresent node [ "services" "pppoe" "client" ])
          "${traceId}: customer node must carry a PPPoE client service"
        && require (client.implementation == "rp-pppoe")
          "${traceId}: customer PPPoE client implementation mismatch"
        && require (client.interface == expectedInterface)
          "${traceId}: customer PPPoE client interface mismatch"
        && require (builtins.hasAttr expectedInterface node.ports)
          "${traceId}: customer PPPoE client lower interface must exist in node ports"
        && require ((lowerPort.serviceInterface or null) == expectedInterface)
          "${traceId}: customer PPPoE client lower interface serviceInterface mismatch"
        && require (!(lowerPort ? link))
          "${traceId}: customer PPPoE client lower interface must not masquerade as a forwarding-model link"
        && require (lowerPort.interface.name == "ens20")
          "${traceId}: customer PPPoE client lower interface must render on ens20"
        && require (builtins.isString lowerBridge && builtins.hasAttr lowerBridge hostBridgeNetworks)
          "${traceId}: customer PPPoE client lower interface bridge must exist in host bridgeNetworks"
        && require (client.runtimeInterface == expectedRuntimeInterface)
          "${traceId}: customer PPPoE runtime interface mismatch"
        && require (client.defaultRoute == true)
          "${traceId}: customer PPPoE client must request default route"
        && require (client.usePeerDns == true)
          "${traceId}: customer PPPoE client must use peer DNS"
        && require (client.mtu == 1492)
          "${traceId}: customer PPPoE client MTU must be 1492"
        && require (client.credentials.usernameFile == "/run/secrets/hat-pppoe-username")
          "${traceId}: customer PPPoE client username secret path mismatch"
        && require (client.credentials.passwordFile == "/run/secrets/hat-pppoe-password")
          "${traceId}: customer PPPoE client password secret path mismatch";
  in
    if tableCustomerOk "pppoeNixos" table.pppoeNixos "nixos" "nixos-router-core-isp-a" "203.0.113.10"
      && tableCustomerOk "pppoeClab" table.pppoeClab "clab" "clab-router-core-simulated-isp" "203.0.113.14"
      && noIntentPppoeBypassLink "site-a" "nixos-core-testnet-host-isp" "nixos-provider-handoff-access-a"
      && noIntentPppoeBypassLink "site-a" "nixos-core-testnet-routed-isp" "nixos-provider-handoff-access-b"
      && noIntentPppoeBypassLink "site-b" "clab-core-testnet-host-isp" "clab-provider-handoff-access-a"
      && noIntentPppoeBypassLink "site-b" "clab-core-testnet-routed-isp" "clab-provider-handoff-access-b"
      && customerNodeOk
        nixosInventory
        nixosInventory.realization.nodes.esp0xdeadbeef-site-a-nixos-core-testnet-host-isp
        "s-router-nixos"
        "nixos-core-testnet-host-isp"
        "p2p-nixos-core-testnet-host-isp-nixos-provider-handoff-access-a"
        "ppp0"
      && customerNodeOk
        nixosInventory
        nixosInventory.realization.nodes.esp0xdeadbeef-site-a-nixos-core-testnet-routed-isp
        "s-router-nixos"
        "nixos-core-testnet-routed-isp"
        "p2p-nixos-core-testnet-routed-isp-nixos-provider-handoff-access-b"
        "ppp1"
      && customerNodeOk
        clabInventory
        clabInventory.realization.nodes.esp0xdeadbeef-site-b-clab-core-testnet-host-isp
        "s-router-clab"
        "clab-core-testnet-host-isp"
        "p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a"
        "ppp0"
      && customerNodeOk
        clabInventory
        clabInventory.realization.nodes.esp0xdeadbeef-site-b-clab-core-testnet-routed-isp
        "s-router-clab"
        "clab-core-testnet-routed-isp"
        "p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b"
        "ppp1"
    then "true"
    else "unreachable"
' >/dev/null || fail "customer-side source fixture validation failed"

echo "PASS ${trace_id}"
