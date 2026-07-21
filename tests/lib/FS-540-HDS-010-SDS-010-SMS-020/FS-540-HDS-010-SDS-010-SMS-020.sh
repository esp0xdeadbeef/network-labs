#!/usr/bin/env bash
# GAMP-ID: FS-540-HDS-010-SDS-010-SMS-020
# GAMP-SCOPE: software-module construction source; not live evidence
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
mini_file="${repo_root}/GAMP/SMT/mini-smt/default.nix"
manifest_file="${repo_root}/GAMP/SMT/mini-smt/tests.nix"

fail() {
	echo "FAIL FS-540-HDS-010-SDS-010-SMS-020: $*" >&2
	exit 1
}

[[ -f "${mini_file}" ]] || fail "missing ${mini_file}"
[[ -f "${manifest_file}" ]] || fail "missing ${manifest_file}"

nix eval --impure --expr "
  let
    traceId = \"FS-540-HDS-010-SDS-010-SMS-020\";
    mini = import ${mini_file};
    manifest = import ${manifest_file};
    lab = mini.labs.\"\${traceId}\";
    rowIntent = import ${repo_root}/GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-020/intent.nix;
    nixosInventory = import ${repo_root}/GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-020/inventory-nixos.nix;
    clabInventory = import ${repo_root}/GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-020/inventory-clab.nix;
    testClientsInventory = import ${repo_root}/GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-020/inventory-test-clients.nix;
    testClientsIntent = import ${repo_root}/GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-020/intent-test-clients.nix;
    site = rowIntent.\"mini-smt\".\"\${traceId}\";
    recursive = site.recursiveDnsIntent;
    expectedRelationIds = [
      \"\${traceId}__mini-client-to-access-dns\"
      \"\${traceId}__mini-client-web-to-testnet\"
      \"\${traceId}__mini-access-dns-to-core-dns\"
      \"\${traceId}__mini-core-dns-to-testnet\"
    ];
    allRelations = site.communicationContract.relations ++ recursive.relations;
    rowRelationIds = builtins.map (relation: relation.id) allRelations;
    rowRelationsById = builtins.listToAttrs (builtins.map (relation: { name = relation.id; value = relation; }) allRelations);
    clientServiceRelation = rowRelationsById.\"\${traceId}__mini-client-to-access-dns\";
    accessCoreRelation = rowRelationsById.\"\${traceId}__mini-access-dns-to-core-dns\";
    coreEgressRelation = rowRelationsById.\"\${traceId}__mini-core-dns-to-testnet\";
    binding = builtins.head recursive.bindings;
    coreService = builtins.head recursive.services;
    dnsTrafficType = builtins.head (builtins.filter (trafficType: trafficType.name == \"dns\") site.communicationContract.trafficTypes);
    dnsMatches = dnsTrafficType.match or [ ];
    hasDnsUdp = builtins.any (match: (match.proto or null) == \"udp\" && builtins.elem 53 (match.dports or [ ])) dnsMatches;
    hasDnsTcp = builtins.any (match: (match.proto or null) == \"tcp\" && builtins.elem 53 (match.dports or [ ])) dnsMatches;
    accessService = builtins.head site.communicationContract.services;
    ownershipEndpoint = builtins.head site.ownership.endpoints;
    nixosNodes = nixosInventory.realization.nodes;
    clabNodes = clabInventory.realization.nodes;
    expectedNodeNames = builtins.map (name: \"mini-smt-\${traceId}-\${name}\") [
      \"access-dns\"
      \"downstream-selector\"
      \"policy\"
      \"resolver-node\"
      \"upstream-selector\"
    ];
    testClientSite = testClientsIntent.control_plane_model.data.\"mini-smt\".\"\${traceId}\";
    testEndpoints = testClientSite.endpointAssignment;
    nixosClient = testEndpoints.dns-resolver-nixos-client;
    clabClient = testEndpoints.dns-resolver-clab-client;
    entry = manifest.tests.\"\${traceId}\";
    clabProvider = builtins.head clabInventory.containerlab.labEmulation.requests;
    require = cond: msg: if cond then true else throw msg;
    validResults = builtins.map mini.validators.dnsResolverConfig lab.dnsResolverRelations;
  in
    require (lab.kind == \"mini-smt\" && lab.traceId == traceId)
      \"row must be an independently identified mini SMT\"
    && require (entry.traceId == traceId && entry.independent == true && entry.aggregateOnly == false)
      \"manifest must expose the exact row as an independent construction test\"
    && require (entry.source.kind == \"intent-source\" && entry.source.expectedRelationIds == expectedRelationIds)
      \"manifest must bind the row-local source and exact relation set\"
    && require (entry.maxRuntimeTargets == 5 && lab.maxRuntimeTargets == 5)
      \"row must remain capped at the five-node requester-policy-core path\"
    && require (builtins.attrNames lab.runtimeTargets == [
      \"access-dns\"
      \"downstream-selector\"
      \"policy\"
      \"resolver-node\"
      \"upstream-selector\"
    ])
      \"row may declare only the five named runtime targets\"
    && require (rowRelationIds == expectedRelationIds)
      \"row must declare client DNS, client web egress, access-to-core DNS, and core-to-provider DNS relations in order\"
    && require (clientServiceRelation.from == { kind = \"tenant\"; name = \"client\"; })
      \"client DNS relation must originate from the modeled tenant\"
    && require (clientServiceRelation.to == { kind = \"service\"; name = \"access-dns\"; } && clientServiceRelation.trafficType == \"dns\")
      \"client DNS relation must terminate at the named access resolver\"
    && require (accessCoreRelation.from == { kind = \"service\"; name = \"access-dns\"; })
      \"recursive forwarding must originate from the named access resolver\"
    && require (accessCoreRelation.to == { kind = \"service\"; name = \"core-dns\"; } && accessCoreRelation.trafficType == \"dns\")
      \"recursive forwarding must terminate at the named core resolver\"
    && require (coreEgressRelation.from == { kind = \"service\"; name = \"core-dns\"; })
      \"provider DNS egress must originate from the named core resolver\"
    && require (coreEgressRelation.to == { kind = \"external\"; uplinks = [ \"testnet-vlan4\" ]; })
      \"core DNS egress must select exactly the controlled VLAN4 provider\"
    && require (coreEgressRelation.trafficType == \"dns\")
      \"core provider relation must not grant non-DNS egress\"
    && require (builtins.length site.communicationContract.trafficTypes == 2 && hasDnsUdp && hasDnsTcp)
      \"DNS traffic must cover UDP and TCP port 53\"
    && require (accessService == { name = \"access-dns\"; providers = [ \"access-dns\" ]; trafficType = \"dns\"; })
      \"access resolver must be a named service with one provider\"
    && require (coreService.name == \"core-dns\" && coreService.providerNode == \"resolver-node\")
      \"core resolver must have one named provider node\"
    && require (coreService.recursionMode == \"iterative\")
      \"core resolver must use iterative recursion rather than public forwarders\"
    && require (binding.requesterScope == { kind = \"service\"; name = \"access-dns\"; })
      \"binding requester scope must be the named access resolver\"
    && require (binding.advertisedResolver == { kind = \"service\"; name = \"access-dns\"; })
      \"clients must receive the access resolver, not the core endpoint\"
    && require (binding.upstreamResolver == { kind = \"service\"; name = \"core-dns\"; node = \"resolver-node\"; })
      \"access resolver upstream must be the named core service and node\"
    && require (binding.resolverPath == [ \"access-dns\" \"downstream-selector\" \"policy\" \"upstream-selector\" \"resolver-node\" ])
      \"binding must name the complete access-to-core path\"
    && require (binding.egressSurface == { kind = \"external\"; uplinks = [ \"testnet-vlan4\" ]; })
      \"binding must select the same provider identity as the core egress relation\"
    && require (binding.allowedAddressFamilies == [ \"ipv4\" \"ipv6\" ] && binding.directPublicFallback == false)
      \"binding must be dual-stack and forbid direct public fallback\"
    && require (ownershipEndpoint.name == \"access-dns\" && ownershipEndpoint.tenant == \"client\")
      \"access resolver endpoint must be owned by the client tenant\"
    && require (builtins.attrNames nixosNodes == expectedNodeNames && builtins.attrNames clabNodes == expectedNodeNames)
      \"NixOS and CLAB inventories must explicitly realize the same five logical nodes\"
    && require (nixosInventory.endpoints.access-dns == clabInventory.endpoints.access-dns)
      \"NixOS and CLAB inventories must bind the same access service endpoint\"
    && require (nixosNodes.\"mini-smt-\${traceId}-resolver-node\".ports.testnet-vlan4.uplink == \"testnet-vlan4\")
      \"NixOS core realization must bind the selected provider port\"
    && require (clabNodes.\"mini-smt-\${traceId}-resolver-node\".ports.testnet-vlan4.uplink == \"testnet-vlan4\")
      \"CLAB core realization must bind the selected provider port\"
    && require (testClientsInventory.meta.scope == \"isolated-dual-stack-dns-client-attachments\")
      \"test clients must use the row-local isolated attachment inventory\"
    && require (testClientSite.runtimeTargets == { } && testClientsIntent.control_plane_model.realization.nodes == { })
      \"test-client source must not synthesize router runtime targets\"
    && require (nixosClient.bridge == \"dns540n\" && clabClient.bridge == \"dns540c\")
      \"test-client endpoints must use distinct isolated NixOS and CLAB VLANs\"
    && require (nixosClient.static.dnsServers == [ \"10.54.10.1\" \"fd42:540::1\" ] && clabClient.static.dnsServers == nixosClient.static.dnsServers)
      \"both client substrates must consume the same dual-stack access resolver endpoints\"
    && require (testClientsInventory.deploymentHosts.s-router-test-clients.bridgeNetworks.dns540n.vlan == 411)
      \"NixOS client attachment must use isolated lab VLAN411\"
    && require (testClientsInventory.deploymentHosts.s-router-test-clients.bridgeNetworks.dns540c.vlan == 412)
      \"CLAB client attachment must use isolated lab VLAN412\"
    && require (clabInventory.containerlab.capabilities.labEmulation == true && clabInventory.containerlab.labEmulation.scope == \"harness\")
      \"CLAB provider emulation must be explicit and harness-scoped\"
    && require (clabProvider.providerEmulationMode == \"fake-provider\" && clabProvider.handoffVlan == 11 && clabProvider.liveUpstreamVlan == 4)
      \"CLAB provider must use the controlled VLAN11 handoff backed by lab VLAN4\"
    && require (clabProvider.nat44.enabled == true && clabProvider.nat44.sourcePrefix == \"10.20.0.0/24\")
      \"CLAB provider emulation must declare its exact NAT44 source\"
    && require (!(clabProvider ? defaultRoute) && !(clabProvider ? defaultFirewall))
      \"provider emulation must not invent route or firewall authority\"
    && require (lab.testsOnly == [
      \"dns-resolver-relation-id\"
      \"dns-resolver-action-class\"
      \"dns-recursive-service-relation\"
      \"dns-named-core-binding\"
      \"dns-core-egress-relation\"
      \"dns-resolver-minimal-policy-path\"
    ])
      \"mini SMT must enumerate only the DNS authority construction predicates\"
    && require (builtins.all (result: result.ok && result.diagnostic == null) validResults)
      \"all named DNS relation records must pass their row-local validator\"
" >/dev/null || fail "construction source contract failed"

echo "PASS FS-540-HDS-010-SDS-010-SMS-020 row-local named-core DNS source"
