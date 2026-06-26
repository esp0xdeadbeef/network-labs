#!/usr/bin/env bash
# GAMP-ID: FS-370-HDS-010-SDS-010-SMS-050
# GAMP-SCOPE: active-lab mini SMT; not HAT/SAT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mini_file="${repo_root}/GAMP/SMT/mini-smt/default.nix"
manifest_file="${repo_root}/GAMP/SMT/mini-smt/tests.nix"

fail() {
  echo "FAIL active-lab-mini-smt-lane-egress-binding-only: $*" >&2
  exit 1
}

[[ -f "${mini_file}" ]] || fail "missing ${mini_file}"
[[ -f "${manifest_file}" ]] || fail "missing ${manifest_file}"

nix eval --impure --expr "
  let
    mini = import ${mini_file};
    manifest = import ${manifest_file};
    lab = mini.labs.\"FS-370-HDS-010-SDS-010-SMS-050\";
    entry = manifest.tests.\"lane-egress-binding\";
    relation = builtins.head lab.laneEgressRelations;
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
    && require (builtins.attrNames lab.runtimeTargets == [ \"client-edge\" \"testnet-edge\" ])
      \"lane-egress mini SMT may start only client-edge and testnet-edge\"
    && require (lab.maxRuntimeTargets == 2)
      \"lane-egress mini SMT must stay capped at two runtime targets\"
    && require (builtins.length lab.laneEgressRelations == 1)
      \"lane-egress mini SMT must test exactly one lane egress relation\"
    && require (lab.testsOnly == [
      \"lane-egress-binding\"
      \"lane-uplink-annotation\"
    ])
      \"lane-egress mini SMT must name only the lane egress atom checks\"
    && require (builtins.elem \"s-router-clab\" lab.forbiddenScope)
      \"lane-egress mini SMT must forbid full s-router-clab scope\"
    && require (valid.ok && valid.diagnostic == null)
      \"valid lane egress relation must pass\"
    && require (valid.expectedLaneKind == \"access-uplink\")
      \"valid lane egress relation must expect access-uplink lane kind\"
" >/dev/null || fail "mini SMT lane egress binding contract failed"

echo "PASS active-lab-mini-smt-lane-egress-binding-only"
