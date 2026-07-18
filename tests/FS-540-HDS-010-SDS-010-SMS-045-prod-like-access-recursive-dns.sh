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
  allInventoryDns = inventory:
    map (node: node.services.dns or { })
      (builtins.attrValues inventory.realization.nodes);
  noLiteralForwarders = inventory:
    builtins.all (dns: (dns.forwarders or [ ]) == [ ]) (allInventoryDns inventory);
  selectedBinding = builtins.head site.recursiveDnsIntent.bindings;
  localIntent = site.localDnsSharingIntent;
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
  && require (inventoryNodeNames nixos == nodeNames && inventoryNodeNames clab == nodeNames)
    \"NixOS and CLAB inventories must realize the same logical roles\"
  && require (builtins.attrNames (hostUplinks nixos \"s-router-nixos\") == [
    \"isp-primary\"
    \"overlay-secondary\"
  ] && builtins.attrNames (hostUplinks clab \"s-router-clab\") == [
    \"isp-primary\"
    \"overlay-secondary\"
  ]) \"both substrates must realize the same two egress candidates\"
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
  inventory = import (currentLab + "/inventory-test-clients.nix");
  intent = import (currentLab + "/intent-s-router-test-clients.nix");
  host = intent.control_plane_model.deployment.hosts.s-router-test-clients;
  require = condition: message: if condition then true else throw message;
in
  require (host.uplinks.management.vlan == 2)
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
