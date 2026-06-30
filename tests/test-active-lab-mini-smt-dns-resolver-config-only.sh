#!/usr/bin/env bash
# GAMP-ID: FS-540-HDS-010-SDS-010-SMS-020
# GAMP-SCOPE: active-lab mini SMT; not HAT/SAT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mini_file="${repo_root}/GAMP/SMT/mini-smt/default.nix"
manifest_file="${repo_root}/GAMP/SMT/mini-smt/tests.nix"

fail() {
  echo "FAIL active-lab-mini-smt-dns-resolver-config-only: $*" >&2
  exit 1
}

[[ -f "${mini_file}" ]] || fail "missing ${mini_file}"
[[ -f "${manifest_file}" ]] || fail "missing ${manifest_file}"

nix eval --impure --expr "
  let
    mini = import ${mini_file};
    manifest = import ${manifest_file};
    lab = mini.labs.\"FS-540-HDS-010-SDS-010-SMS-020\";
    rowIntent = import ${repo_root}/GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-020/intent.nix;
    nixosInventory = import ${repo_root}/GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-020/inventory-nixos.nix;
    clabInventory = import ${repo_root}/GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-020/inventory-clab.nix;
    testClientsInventory = import ${repo_root}/GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-020/inventory-test-clients.nix;
    testClientsIntent = import ${repo_root}/GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-020/intent-test-clients.nix;
    site = rowIntent.\"mini-smt\".\"dns-resolver-config\";
    expectedRelationIds = [
      \"FS-540-HDS-010-SDS-010-SMS-020__mini-client-to-access-dns\"
      \"FS-540-HDS-010-SDS-010-SMS-020__mini-access-dns-service-to-testnet\"
      \"FS-540-HDS-010-SDS-010-SMS-020__mini-dns-client-to-testnet\"
    ];
    rowRelationIds = builtins.map (relation: relation.id) site.communicationContract.relations;
    rowRelationsById = builtins.listToAttrs (builtins.map (relation: { name = relation.id; value = relation; }) site.communicationContract.relations);
    clientServiceRelation = rowRelationsById.\"FS-540-HDS-010-SDS-010-SMS-020__mini-client-to-access-dns\";
    serviceEgressRelation = rowRelationsById.\"FS-540-HDS-010-SDS-010-SMS-020__mini-access-dns-service-to-testnet\";
    clientEgressRelation = rowRelationsById.\"FS-540-HDS-010-SDS-010-SMS-020__mini-dns-client-to-testnet\";
    dnsTrafficTypes = builtins.filter (trafficType: trafficType.name == \"dns\") site.communicationContract.trafficTypes;
    dnsTrafficType = builtins.head dnsTrafficTypes;
    dnsMatches = dnsTrafficType.match or [ ];
    hasDnsUdp = builtins.any (match: (match.proto or null) == \"udp\" && builtins.elem 53 (match.dports or [ ])) dnsMatches;
    hasDnsTcp = builtins.any (match: (match.proto or null) == \"tcp\" && builtins.elem 53 (match.dports or [ ])) dnsMatches;
    dnsServices = builtins.filter (service: service.name == \"access-dns\") site.communicationContract.services;
    dnsService = builtins.head dnsServices;
    ownershipEndpoints = builtins.filter (endpoint: (endpoint.name or null) == \"access-dns\") (site.ownership.endpoints or [ ]);
    nixosAccessEndpoint = (nixosInventory.endpoints or {}).\"access-dns\" or {};
    clabAccessEndpoint = (clabInventory.endpoints or {}).\"access-dns\" or {};
    testClientSite = testClientsIntent.control_plane_model.data.\"mini-smt\".\"dns-resolver-config\";
    testClientEndpoint = testClientSite.endpointAssignment.\"dns-resolver-config-access-dns\" or {};
    entry = manifest.tests.\"dns-resolver-config\";
    clabProvider = builtins.head clabInventory.containerlab.labEmulation.requests;
    require = cond: msg: if cond then true else throw msg;
    validResults = builtins.map mini.validators.dnsResolverConfig lab.dnsResolverRelations;
    allRelationsValid = builtins.all (result: result.ok && result.diagnostic == null) validResults;
  in
    require (lab.kind == \"mini-smt\")
      \"dns-resolver lab must be a mini SMT\"
    && require (lab.traceId == \"FS-540-HDS-010-SDS-010-SMS-020\")
      \"dns-resolver lab must carry the exact SMS trace\"
    && require (entry.traceId == lab.traceId)
      \"dns-resolver manifest must point at the same trace as the mini-lab\"
    && require (entry.script == \"tests/test-active-lab-mini-smt-dns-resolver-config-only.sh\")
      \"dns-resolver manifest must point at this focused script\"
    && require (entry.liveSitScript == \"tests/FS-540-HDS-010-SDS-010-SIT-live-recursive-dns.sh\")
      \"dns-resolver manifest must point at the focused live recursive DNS SIT probe\"
    && require (entry.independent == true && entry.aggregateOnly == false)
      \"dns-resolver manifest must be independently runnable and not aggregate-only\"
    && require (entry.source.kind == \"intent-source\")
      \"dns-resolver manifest must use a row-specific intent source\"
    && require (entry.source.expectedRelationIds == lab.source.expectedRelationIds)
      \"dns-resolver manifest must carry the same expected relation id as the mini-lab\"
    && require (entry.maxRuntimeTargets == lab.maxRuntimeTargets)
      \"dns-resolver manifest runtime cap must match the mini-lab runtime cap\"
    && require (entry.rendererTarget == null)
      \"dns-resolver mini SMT must not be routed through a renderer aggregate target\"
    && require (builtins.attrNames lab.runtimeTargets == [
      \"access-dns\"
      \"downstream-selector\"
      \"policy\"
      \"resolver-node\"
      \"upstream-selector\"
    ])
      \"dns-resolver mini SMT may start only the five-node requester-policy-resolver path\"
    && require (lab.maxRuntimeTargets == 5)
      \"dns-resolver mini SMT must stay capped at five runtime targets\"
    && require (builtins.length lab.dnsResolverRelations == 3)
      \"dns-resolver mini SMT must test client-service, service-egress, and client-egress relations\"
    && require (rowRelationIds == expectedRelationIds)
      \"dns-resolver row source must carry the exact relation set, not a single broad stub relation\"
    && require (clientServiceRelation.from == { kind = \"tenant\"; name = \"client\"; })
      \"dns-resolver client-to-service relation must originate from tenant client\"
    && require (clientServiceRelation.to == { kind = \"service\"; name = \"access-dns\"; } && clientServiceRelation.trafficType == \"dns\")
      \"dns-resolver client-to-service relation must target access-dns DNS service\"
    && require (serviceEgressRelation.from == { kind = \"service\"; name = \"access-dns\"; })
      \"dns-resolver service-egress relation must originate from access-dns service\"
    && require (serviceEgressRelation.to.uplinks == [ \"testnet-vlan4\" ] && serviceEgressRelation.trafficType == \"dns\")
      \"dns-resolver service-egress relation must use DNS over explicit VLAN4 testnet uplink\"
    && require (clientEgressRelation.to.uplinks == [ \"testnet-vlan4\" ])
      \"dns-resolver mini SIT must use an explicit VLAN4 testnet uplink, not an untagged testnet bridge\"
    && require (builtins.length dnsTrafficTypes == 1 && hasDnsUdp && hasDnsTcp)
      \"dns-resolver row source must declare DNS traffic as UDP/TCP port 53\"
    && require (builtins.length dnsServices == 1 && dnsService.providers == [ \"access-dns\" ] && dnsService.trafficType == \"dns\")
      \"dns-resolver row source must declare access-dns as an explicit DNS service provider\"
    && require (builtins.length ownershipEndpoints == 1 && (builtins.head ownershipEndpoints).tenant == \"client\")
      \"dns-resolver row source must bind access-dns provider identity to tenant client ownership\"
    && require ((nixosAccessEndpoint.ipv4 or [ ]) == [ \"10.54.10.1\" ] && (nixosAccessEndpoint.ipv6 or [ ]) == [ \"fd42:540::1\" ])
      \"dns-resolver NixOS inventory must expose the access-dns listener endpoint addresses\"
    && require ((clabAccessEndpoint.ipv4 or [ ]) == [ \"10.54.10.1\" ] && (clabAccessEndpoint.ipv6 or [ ]) == [ \"fd42:540::1\" ])
      \"dns-resolver CLAB inventory must expose the access-dns listener endpoint addresses\"
    && require (testClientsInventory.meta.scope == \"row-local-test-client-endpoint-source\")
      \"dns-resolver test-clients inventory must be row-local endpoint source, not a source stub\"
    && require (testClientsIntent.control_plane_model.realization.nodes == { })
      \"dns-resolver test-clients intent must not synthesize router realization nodes\"
    && require (testClientSite.runtimeTargets == { })
      \"dns-resolver test-clients intent must not synthesize router runtime targets\"
    && require (builtins.hasAttr \"dns-resolver-config-access-dns\" testClientSite.endpointAssignment)
      \"dns-resolver test-clients intent must expose the access-dns endpoint assignment\"
    && require (testClientEndpoint.owningSubstrate == \"s-router-test-clients\" && testClientEndpoint.mode == \"static\")
      \"dns-resolver test-clients endpoint assignment must target s-router-test-clients as a static endpoint\"
    && require (testClientEndpoint.bridge == \"br-mini-smt-dns-resolver-config-tenant-client\")
      \"dns-resolver test-clients endpoint assignment must use the modeled tenant bridge\"
    && require (testClientEndpoint.static.address == \"10.54.10.1\" && testClientEndpoint.static.address6 == \"fd42:540::1\")
      \"dns-resolver test-clients endpoint assignment must carry the access-dns listener addresses\"
    && require (testClientsIntent.deploymentHosts.s-router-test-clients.uplinks.management.vlan == 2)
      \"dns-resolver test-clients intent must preserve VLAN2 management substrate\"
    && require (site.topology.nodes.resolver-node.uplinks ? \"testnet-vlan4\")
      \"dns-resolver resolver-node must declare the VLAN4-backed testnet uplink\"
    && require (clabInventory.containerlab.capabilities.labEmulation == true)
      \"dns-resolver CLAB inventory must declare explicit lab-emulation capability\"
    && require (clabInventory.containerlab.labEmulation.scope == \"harness\")
      \"dns-resolver CLAB provider emulation must stay harness-scoped\"
    && require (builtins.length clabInventory.containerlab.labEmulation.requests == 1)
      \"dns-resolver CLAB inventory must declare exactly one provider-emulation request\"
    && require (clabProvider.providerEmulationMode == \"fake-provider\")
      \"dns-resolver CLAB provider emulation must be fake-provider, not an implicit DHCP client\"
    && require (clabProvider.handoffVlan == 11)
      \"dns-resolver CLAB provider-to-core handoff must use the controlled fake-provider VLAN11\"
    && require (clabProvider.liveUpstreamVlan == 4)
      \"dns-resolver CLAB fake provider must source upstream reachability from VLAN4 DHCP\"
    && require (clabProvider.dhcp4.address == \"10.20.0.1/24\")
      \"dns-resolver CLAB fake provider must declare explicit DHCPv4 gateway address\"
    && require (clabProvider.dhcp4.router == \"10.20.0.1\")
      \"dns-resolver CLAB fake provider must declare explicit DHCPv4 router option\"
    && require (clabProvider.dhcp4.clientAddress == \"10.20.0.20\")
      \"dns-resolver CLAB fake provider must declare explicit DHCPv4 client address for the live VLAN4 WAN binding\"
    && require (clabProvider.dhcp4.rangeStart == \"10.20.0.20\" && clabProvider.dhcp4.rangeEnd == \"10.20.0.99\")
      \"dns-resolver CLAB fake provider must declare explicit DHCPv4 lease range\"
    && require (clabProvider.dhcp4.leaseTime == \"5m\" && clabProvider.dhcp4.sourcePrefix == \"10.20.0.0/24\")
      \"dns-resolver CLAB fake provider must declare explicit DHCPv4 lease time and source prefix\"
    && require (clabProvider.nat44.enabled == true && clabProvider.nat44.sourcePrefix == \"10.20.0.0/24\")
      \"dns-resolver CLAB fake provider must declare explicit NAT44 source prefix\"
    && require (!(clabProvider ? defaultRoute) && !(clabProvider ? defaultFirewall))
      \"dns-resolver CLAB provider-emulation source must not create route/firewall policy authority\"
    && require (clabProvider.liveUpstreamVlan != 2 && clabProvider.handoffVlan != 2)
      \"dns-resolver CLAB provider-emulation source must not use VLAN2 test infrastructure\"
    && require (lab.testsOnly == [
      \"dns-resolver-relation-id\"
      \"dns-resolver-action-class\"
      \"dns-recursive-service-relation\"
      \"dns-service-egress-relation\"
      \"dns-resolver-minimal-policy-path\"
    ])
      \"dns-resolver mini SMT must name only the DNS resolver config atom checks\"
    && require (builtins.elem \"SAT\" lab.forbiddenScope)
      \"dns-resolver mini SMT must forbid SAT scope\"
    && require allRelationsValid
      \"valid DNS resolver relation set must pass\"
" >/dev/null || fail "mini SMT DNS resolver config contract failed"

echo "PASS active-lab-mini-smt-dns-resolver-config-only"
