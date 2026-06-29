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
    clabInventory = import ${repo_root}/GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-020/inventory-clab.nix;
    site = rowIntent.\"mini-smt\".\"dns-resolver-config\";
    rowRelation = builtins.head site.communicationContract.relations;
    entry = manifest.tests.\"dns-resolver-config\";
    relation = builtins.head lab.dnsResolverRelations;
    clabProvider = builtins.head clabInventory.containerlab.labEmulation.requests;
    require = cond: msg: if cond then true else throw msg;
    valid = mini.validators.dnsResolverConfig relation;
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
    && require (builtins.length lab.dnsResolverRelations == 1)
      \"dns-resolver mini SMT must test exactly one DNS resolver relation\"
    && require (rowRelation.to.uplinks == [ \"testnet-vlan4\" ])
      \"dns-resolver mini SIT must use an explicit VLAN4 testnet uplink, not an untagged testnet bridge\"
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
    && require (!(clabProvider ? defaultRoute) && !(clabProvider ? defaultFirewall))
      \"dns-resolver CLAB provider-emulation source must not create route/firewall policy authority\"
    && require (clabProvider.liveUpstreamVlan != 2 && clabProvider.handoffVlan != 2)
      \"dns-resolver CLAB provider-emulation source must not use VLAN2 test infrastructure\"
    && require (lab.testsOnly == [
      \"dns-resolver-relation-id\"
      \"dns-resolver-action-class\"
      \"dns-resolver-minimal-policy-path\"
    ])
      \"dns-resolver mini SMT must name only the DNS resolver config atom checks\"
    && require (builtins.elem \"SAT\" lab.forbiddenScope)
      \"dns-resolver mini SMT must forbid SAT scope\"
    && require (valid.ok && valid.diagnostic == null)
      \"valid DNS resolver relation must pass\"
" >/dev/null || fail "mini SMT DNS resolver config contract failed"

echo "PASS active-lab-mini-smt-dns-resolver-config-only"
