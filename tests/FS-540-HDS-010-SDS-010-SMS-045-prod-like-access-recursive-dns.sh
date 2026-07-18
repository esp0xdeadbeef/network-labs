#!/usr/bin/env bash
# GAMP-ID: FS-540-HDS-010-SDS-010-SMS-045
# GAMP-SCOPE: construction contract for isolated live acceptance source
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
trace="FS-540-HDS-010-SDS-010-SMS-045"
row="${repo_root}/GAMP/SMT/${trace}"
selection_root="$(mktemp -d)"

cleanup() {
  rm -rf "${selection_root}"
}
trap cleanup EXIT

fail() {
  printf 'NOT OK %s: check=%s\n' "${trace}" "$1" >&2
  exit 1
}

for file in \
  default.nix \
  intent.nix \
  intent-test-clients.nix \
  inventory-common.nix \
  inventory-nixos.nix \
  inventory-clab.nix \
  inventory-test-clients.nix
do
  test -s "${row}/${file}" || fail "source-${file}"
done

nix eval --impure --expr "
let
  trace = \"${trace}\";
  row = import ${row}/default.nix;
  source = import ${row}/intent.nix;
  site = source.mini-smt.\${trace};
  nixos = import ${row}/inventory-nixos.nix;
  clab = import ${row}/inventory-clab.nix;
  clients = import ${row}/intent-test-clients.nix;
  clientInventory = import ${row}/inventory-test-clients.nix;
  require = condition: message: if condition then true else throw message;
  relationIds =
    map (relation: relation.id)
      (site.communicationContract.relations ++ site.recursiveDnsIntent.relations);
  nodeNames = builtins.attrNames site.topology.nodes;
  serviceByName = name:
    builtins.head (builtins.filter (service: service.name == name)
      site.recursiveDnsIntent.services);
  endpointNames = builtins.attrNames
    clients.control_plane_model.data.mini-smt.\${trace}.endpointAssignment;
  inventoryNodeNames = inventory:
    map (node: node.logicalNode.name)
      (builtins.attrValues inventory.realization.nodes);
  hostUplinks = inventory: host:
    inventory.deploymentHosts.\${host}.uplinks;
  corePortsFor = inventory:
    (builtins.head (builtins.filter
      (node: node.logicalNode.name == \"core-primary\")
      (builtins.attrValues inventory.realization.nodes))).ports;
  providerPortMatches = port: uplink: interfaceName:
    port == {
      attach = {
        bridge = uplink;
        kind = \"bridge\";
      };
      external = true;
      interface.name = interfaceName;
      inherit uplink;
    };
  dualStackSlaacUplink = uplink:
    uplink.mode == \"isolated\"
    && uplink.ipv4.enable == true
    && uplink.ipv4.method == \"dhcp\"
    && uplink.ipv4.dhcp == true
    && uplink.ipv6.enable == true
    && uplink.ipv6.method == \"slaac\"
    && uplink.ipv6.acceptRA == true
    && uplink.ipv6.dhcp == false
    && uplink.ipv6.dhcpv6PD == false;
  allInventoryDns = inventory:
    map (node: node.services.dns or { })
      (builtins.attrValues inventory.realization.nodes);
  noLiteralForwarders = inventory:
    builtins.all (dns: (dns.forwarders or [ ]) == [ ]) (allInventoryDns inventory);
  authorityFor = inventory:
    (builtins.head (builtins.filter
      (dns: (dns.validationAuthority.kind or null) == \"controlled-iterative-hierarchy\")
      (allInventoryDns inventory))).validationAuthority;
  authorityIsControlled = authority:
    authority.scope == \"harness\"
    && authority.traceId == trace
    && authority.selectedUplink == \"isp-primary\"
    && authority.alternateUplinks == [ \"overlay-secondary\" ]
    && authority.provider.bridge == \"isp-primary\"
    && authority.provider.ipv4.clientAddress != authority.provider.ipv4.router
    && authority.provider.ipv6.prefix != \"\"
    && authority.root.zone == \".\"
    && authority.root.nameServer != \"\"
    && authority.root.ipv4 != [ ]
    && authority.root.ipv6 != [ ]
    && authority.delegation.zone == \"dns-validation.gamp.\"
    && authority.delegation.nameServer != authority.root.nameServer
    && authority.delegation.ipv4 != [ ]
    && authority.delegation.ipv6 != [ ]
    && authority.terminal.name == \"answer.dns-validation.gamp.\"
    && authority.terminal.ipv4 != [ ]
    && authority.terminal.ipv6 != [ ]
    && authority.trust.mode == \"insecure-controlled-root\";
  selectedBinding = builtins.head site.recursiveDnsIntent.bindings;
  localIntent = site.localDnsSharingIntent;
  nixosAuthority = authorityFor nixos;
  clabAuthority = authorityFor clab;
in
  require (row.traceId == trace && row.miniSmtId == trace)
    \"trace identity mismatch\"
  && require (row.source.expectedRelationIds == relationIds)
    \"row relation manifest must equal all declared communication and recursive DNS relations\"
  && require (nodeNames == [
    \"access-local\"
    \"access-recursive\"
    \"core-primary\"
    \"downstream-selector\"
    \"policy\"
    \"upstream-selector\"
  ]) \"acceptance topology must contain both access roles and the four-stage core path\"
  && require (site.topology.links == [
    [ \"access-recursive\" \"downstream-selector\" ]
    [ \"access-local\" \"downstream-selector\" ]
    [ \"downstream-selector\" \"policy\" ]
    [ \"policy\" \"upstream-selector\" ]
    [ \"upstream-selector\" \"core-primary\" ]
  ]) \"acceptance topology path mismatch\"
  && require ((serviceByName \"core-dns\") == {
    name = \"core-dns\";
    providerNode = \"core-primary\";
    addressAuthority = \"model-allocated-service-prefix\";
    trafficType = \"dns\";
    recursionMode = \"iterative\";
  }) \"core resolver must be named, topology-derived, and iterative\"
  && require (!(serviceByName \"core-dns\" ? ipv4) && !(serviceByName \"core-dns\" ? ipv6))
    \"core resolver binding must not carry address literals\"
  && require (selectedBinding.upstreamResolver == {
    kind = \"service\";
    name = \"core-dns\";
    node = \"core-primary\";
  }) \"access resolver must bind core by service and node identity\"
  && require (selectedBinding.allowedAddressFamilies == [ \"ipv4\" \"ipv6\" ])
    \"access-to-core binding must be dual stack\"
  && require (selectedBinding.egressSurface == {
    kind = \"external\";
    uplinks = [ \"isp-primary\" ];
  }) \"multi-egress DNS selection must identify isp-primary exactly\"
  && require (builtins.attrNames site.topology.nodes.core-primary.uplinks == [
    \"isp-primary\"
    \"overlay-secondary\"
  ]) \"acceptance source must expose two eligible-looking egresses\"
  && require (site.topology.nodes.core-primary.role == \"core\")
    \"the SLAAC consumer must remain a routed core; live acceptance requires a first-boot provider address and selected-table default while forwarding stays enabled\"
  && require (selectedBinding.directPublicFallback == false)
    \"access resolver must not use a public fallback\"
  && require (localIntent.requester.recursion == false
    && localIntent.requester.publicFallback == false
    && localIntent.providerPolicy.action == \"refuse_non_local\"
    && localIntent.lateralPolicy.recursion == false
    && localIntent.lateralPolicy.transitiveEgress == false
    && localIntent.lateralPolicy.action == \"refuse_non_local\")
    \"local-only authority must be bilateral and non-transitive\"
  && require (noLiteralForwarders nixos && noLiteralForwarders clab)
    \"inventories must not hardcode public or core forwarders\"
  && require (authorityIsControlled nixosAuthority && nixosAuthority == clabAuthority)
    \"both substrates must carry the same controlled dual-stack iterative authority realization\"
  && require (inventoryNodeNames nixos == nodeNames && inventoryNodeNames clab == nodeNames)
    \"NixOS and CLAB inventories must realize the same logical roles\"
  && require (builtins.attrNames (hostUplinks nixos \"s-router-nixos\") == [
    \"isp-primary\"
    \"overlay-secondary\"
  ] && builtins.attrNames (hostUplinks clab \"s-router-clab\") == [
    \"isp-primary\"
    \"overlay-secondary\"
  ]) \"both substrates must realize the same two egress candidates\"
  && require (
    builtins.all dualStackSlaacUplink [
      (hostUplinks nixos \"s-router-nixos\").isp-primary
      (hostUplinks nixos \"s-router-nixos\").overlay-secondary
      (hostUplinks clab \"s-router-clab\").isp-primary
      (hostUplinks clab \"s-router-clab\").overlay-secondary
    ]
  ) \"each isolated provider must preserve DHCPv4 plus autonomous IPv6 SLAAC intent; RA-only is not sufficient\"
  && require (builtins.all (ports:
    providerPortMatches ports.isp-primary \"isp-primary\" \"wan0\"
    && providerPortMatches ports.overlay-secondary \"overlay-secondary\" \"wan1\") [
      (corePortsFor nixos)
      (corePortsFor clab)
    ])
    \"both substrates must attach core wan0/wan1 explicitly to the selected/alternate provider bridges; labels without real bridge membership are insufficient\"
  && require (endpointNames == [
    \"local-dns-clab-client\"
    \"local-dns-nixos-client\"
    \"recursive-dns-clab-client\"
    \"recursive-dns-nixos-client\"
  ]) \"four real recursive/local NixOS/CLAB client fixtures are required\"
  && require (builtins.all
    (endpoint:
      endpoint.owningSubstrate == \"s-router-test-clients\"
      && endpoint.family == \"dual\"
      && endpoint.static.dnsServers != [ ])
    (builtins.attrValues
      clients.control_plane_model.data.mini-smt.\${trace}.endpointAssignment))
    \"each acceptance probe must originate from a dual-stack test-client fixture\"
  && require (builtins.sort builtins.lessThan (map
    (bridge: bridge.vlan)
    (builtins.attrValues
      clientInventory.deploymentHosts.s-router-test-clients.bridgeNetworks))
    == [ 413 414 415 416 ])
    \"acceptance clients must use only the isolated row VLANs\"
" >/dev/null || fail source-contract

ln -s "${repo_root}/GAMP" "${selection_root}/GAMP"
NETWORK_LABS_CURRENT_LAB_DIR="${selection_root}/current-lab" \
  "${repo_root}/scripts/select-current-lab.sh" SMT "${trace}" >/dev/null

CURRENT_LAB="${selection_root}/current-lab" nix eval --impure --expr '
let
  currentLab = builtins.getEnv "CURRENT_LAB";
  nixosInventory = import (currentLab + "/inventory-s-router-nixos.nix");
  clabInventory = import (currentLab + "/inventory-s-router-clab.nix");
  inventory = import (currentLab + "/inventory-test-clients.nix");
  intent = import (currentLab + "/intent-s-router-test-clients.nix");
  host = intent.control_plane_model.deployment.hosts.s-router-test-clients;
  require = condition: message: if condition then true else throw message;
  providerUplinksFor = selectedInventory: hostName:
    let uplinks = selectedInventory.deploymentHosts.${hostName}.uplinks;
    in [ uplinks.isp-primary uplinks.overlay-secondary ];
  providerUplinks =
    providerUplinksFor nixosInventory "s-router-nixos"
    ++ providerUplinksFor clabInventory "s-router-clab";
  corePortsFor = selectedInventory:
    (builtins.head (builtins.filter
      (node: node.logicalNode.name == "core-primary")
      (builtins.attrValues selectedInventory.realization.nodes))).ports;
  providerPortMatches = port: uplink: interfaceName:
    port == {
      attach = {
        bridge = uplink;
        kind = "bridge";
      };
      external = true;
      interface.name = interfaceName;
      inherit uplink;
    };
in
  require (builtins.all
    (uplink:
      uplink.mode == "isolated"
      && !(uplink ? parent)
      && uplink.ipv6.enable == true
      && uplink.ipv6.method == "slaac"
      && uplink.ipv6.acceptRA == true
      && uplink.ipv6.dhcp == false)
    providerUplinks)
    "active-lab selection must preserve isolated autonomous-SLAAC provider uplinks without inventing a physical parent"
  && require (builtins.all (ports:
    providerPortMatches ports.isp-primary "isp-primary" "wan0"
    && providerPortMatches ports.overlay-secondary "overlay-secondary" "wan1") [
      (corePortsFor nixosInventory)
      (corePortsFor clabInventory)
    ])
    "active-lab selection must preserve explicit core membership of both isolated provider bridges"
  && require (host.uplinks.management.vlan == 2)
    "selected test-client CPM must inherit the shared management VLAN"
  && require (host.uplinks.management.bridge == "vlan2")
    "selected test-client CPM must inherit the shared management bridge"
  && require (builtins.attrNames host.bridgeNetworks == [
    "dns545cl"
    "dns545cr"
    "dns545nl"
    "dns545nr"
  ]) "management injection must preserve the four isolated test bridges"
  && require (intent.deploymentHosts.s-router-test-clients == host)
    "selected test-client deployment alias must match the managed CPM host"
  && require (inventory.deploymentHosts.s-router-test-clients == host)
    "selected inventory and endpoint CPM must expose the same managed host"
' >/dev/null || fail selected-test-client-management

if rg -n --glob '*.nix' \
  'forwarders[[:space:]]*=[[:space:]]*\[[[:space:]]*"(1\.1\.1\.1|9\.9\.9\.9)' \
  "${row}" >/dev/null; then
  fail public-forwarder-literal
fi

printf 'OK %s\n' "${trace}"
