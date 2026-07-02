#!/usr/bin/env bash
# GAMP-ID: FS-370-HDS-010-SDS-010-SMS-050
# GAMP-SCOPE: active-lab mini SMT; not HAT/SAT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
trace_id="FS-370-HDS-010-SDS-010-SMS-050"
mini_file="${repo_root}/GAMP/SMT/mini-smt/default.nix"
manifest_file="${repo_root}/GAMP/SMT/mini-smt/tests.nix"

fail() {
  echo "FAIL ${trace_id} active-lab-mini-smt-lane-egress-binding-only: $*" >&2
  exit 1
}

[[ -f "${mini_file}" ]] || fail "missing ${mini_file}"
[[ -f "${manifest_file}" ]] || fail "missing ${manifest_file}"

nix eval --impure --expr "
  let
    mini = import ${mini_file};
    manifest = import ${manifest_file};
    rowIntent = import ${repo_root}/GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-050/intent.nix;
    rowInventories = [
      (import ${repo_root}/GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-050/inventory-nixos.nix)
      (import ${repo_root}/GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-050/inventory-clab.nix)
      (import ${repo_root}/GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-050/inventory-test-clients.nix)
    ];
    lab = mini.labs.\"FS-370-HDS-010-SDS-010-SMS-050\";
    entry = manifest.tests.\"FS-370-HDS-010-SDS-010-SMS-050\";
    relation = builtins.head lab.laneEgressRelations;
    rowSite = rowIntent.\"mini-smt\".\"FS-370-HDS-010-SDS-010-SMS-050\";
    rowUplinkNames = builtins.concatMap
      (node: builtins.attrNames (node.uplinks or { }))
      (builtins.attrValues (rowSite.topology.nodes or { }));
    rowInventoryUplinkBridgeConflicts = builtins.concatMap
      (inventory:
        let
          hosts = (inventory.deploymentHosts or { }) // ((inventory.deployment or { }).hosts or { });
        in
        builtins.concatMap
          (host:
            builtins.filter
              (bridgeName: builtins.elem bridgeName rowUplinkNames)
              (builtins.attrNames (host.bridgeNetworks or { })))
          (builtins.attrValues hosts))
      rowInventories;
    expectedTargets = [
      \"client-edge\"
      \"downstream-selector\"
      \"policy\"
      \"testnet-edge\"
      \"upstream-selector\"
    ];
    require = cond: msg: if cond then true else throw msg;
    valid = mini.validators.laneEgressBinding relation;
  in
    require (lab.kind == \"mini-smt\")
      \"lane-egress lab must be a mini SMT\"
    && require (lab.traceId == \"FS-370-HDS-010-SDS-010-SMS-050\")
      \"lane-egress lab must carry the exact SMS trace\"
    && require (entry.traceId == lab.traceId)
      \"lane-egress manifest must point at the same trace as the mini-lab\"
    && require (entry.script == \"tests/test-active-lab-mini-smt-lane-egress-binding-only.sh\")
      \"lane-egress manifest must point at this focused script\"
    && require (entry.independent == true && entry.aggregateOnly == false)
      \"lane-egress manifest must be independently runnable and not aggregate-only\"
    && require (entry.source.kind == \"intent-source\")
      \"lane-egress manifest must use a row-specific intent source\"
    && require (entry.source.expectedRelationIds == lab.source.expectedRelationIds)
      \"lane-egress manifest must carry the same expected relation id as the mini-lab\"
    && require (entry.maxRuntimeTargets == lab.maxRuntimeTargets)
      \"lane-egress manifest runtime cap must match the mini-lab runtime cap\"
    && require (entry.rendererTarget == null)
      \"lane-egress mini SMT must not be routed through a renderer aggregate target\"
    && require (builtins.attrNames lab.runtimeTargets == expectedTargets)
      \"lane-egress mini SMT must declare the five-node lane runtime path\"
    && require (lab.maxRuntimeTargets == 5)
      \"lane-egress mini SMT must stay capped at five runtime targets\"
    && require (lab.runtimeTargets.client-edge.role == \"access\")
      \"lane-egress client-edge must be the access target\"
    && require (lab.runtimeTargets.downstream-selector.role == \"downstream-selector\")
      \"lane-egress downstream-selector target missing\"
    && require (lab.runtimeTargets.policy.role == \"policy\")
      \"lane-egress policy target missing\"
    && require (lab.runtimeTargets.upstream-selector.role == \"upstream-selector\" && lab.runtimeTargets.upstream-selector.external == \"testnet\")
      \"lane-egress upstream-selector must bind the testnet uplink surface\"
    && require (lab.runtimeTargets.testnet-edge.role == \"core\" && lab.runtimeTargets.testnet-edge.external == \"testnet\")
      \"lane-egress testnet-edge must be the modeled external core\"
    && require (rowInventoryUplinkBridgeConflicts == [ ])
      \"lane-egress source inventories must not declare uplink bridge names as generic bridgeNetworks\"
    && require (builtins.length lab.laneEgressRelations == 1)
      \"lane-egress mini SMT must test exactly one lane egress relation\"
    && require (lab.testsOnly == [
      \"lane-egress-binding\"
      \"lane-uplink-annotation\"
      \"five-node-lane-runtime-shape\"
    ])
      \"lane-egress mini SMT must name only the lane egress atom checks\"
    && require (lab.liveSurfaces == [
      \"s-router-nixos\"
      \"s-router-clab\"
      \"s-router-test-clients\"
    ])
      \"lane-egress mini SMT must name its live active-lab surfaces\"
    && require (!(builtins.elem \"s-router-clab\" lab.forbiddenScope))
      \"lane-egress mini SMT must not forbid its own live active-lab surface\"
    && require (builtins.elem \"HAT\" lab.forbiddenScope && builtins.elem \"SAT\" lab.forbiddenScope)
      \"lane-egress mini SMT must still forbid HAT/SAT scope\"
    && require (valid.ok && valid.diagnostic == null)
      \"valid lane egress relation must pass\"
    && require (valid.expectedLaneKind == \"access-uplink\")
      \"valid lane egress relation must expect access-uplink lane kind\"
" >/dev/null || fail "mini SMT lane egress binding contract failed"

echo "PASS ${trace_id} active-lab-mini-smt-lane-egress-binding-only"
