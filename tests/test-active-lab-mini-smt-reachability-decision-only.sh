#!/usr/bin/env bash
# GAMP-ID: FS-500-HDS-010-SDS-010-SMS-010
# GAMP-SCOPE: active-lab mini SMT; not HAT/SAT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mini_file="${repo_root}/GAMP/SMT/mini-smt/default.nix"
manifest_file="${repo_root}/GAMP/SMT/mini-smt/tests.nix"

fail() {
  echo "FAIL active-lab-mini-smt-reachability-decision-only: $*" >&2
  exit 1
}

[[ -f "${mini_file}" ]] || fail "missing ${mini_file}"
[[ -f "${manifest_file}" ]] || fail "missing ${manifest_file}"

nix eval --impure --expr "
  let
    mini = import ${mini_file};
    manifest = import ${manifest_file};
    lab = mini.labs.\"FS-500-HDS-010-SDS-010-SMS-010\";
    entry = manifest.tests.\"FS-500-HDS-010-SDS-010-SMS-010\";
    relation = builtins.head lab.reachabilityRelations;
    require = cond: msg: if cond then true else throw msg;
    valid = mini.validators.reachabilityDecision relation;
    denied = mini.validators.reachabilityDecision (relation // { action = \"deny\"; });
    missingId = mini.validators.reachabilityDecision (builtins.removeAttrs relation [ \"id\" ]);
    unsupported = mini.validators.reachabilityDecision (relation // { action = \"maybe\"; });
  in
    require (lab.kind == \"mini-smt\")
      \"reachability lab must be a mini SMT\"
    && require (lab.traceId == \"FS-500-HDS-010-SDS-010-SMS-010\")
      \"reachability lab must carry the exact SMS trace\"
    && require (entry.traceId == lab.traceId)
      \"reachability manifest must point at the same trace as the mini-lab\"
    && require (entry.script == \"tests/test-active-lab-mini-smt-reachability-decision-only.sh\")
      \"reachability manifest must point at this focused script\"
    && require (entry.independent == true && entry.aggregateOnly == false)
      \"reachability manifest must be independently runnable and not aggregate-only\"
    && require (entry.source.kind == \"intent-source\")
      \"reachability manifest must use a row-specific intent source\"
    && require (entry.source.expectedRelationIds == lab.source.expectedRelationIds)
      \"reachability manifest must carry the same expected relation id as the mini-lab\"
    && require (entry.maxRuntimeTargets == lab.maxRuntimeTargets)
      \"reachability manifest runtime cap must match the mini-lab runtime cap\"
    && require (entry.rendererTarget == null)
      \"reachability mini SMT must not be routed through a renderer aggregate target\"
    && require (builtins.attrNames lab.runtimeTargets == [
      \"client-edge\"
      \"downstream-selector\"
      \"policy\"
      \"vlan4-client-dhcp-slaac\"
      \"upstream-selector\"
    ])
      \"reachability mini SMT must use the five-node policy path required by NFM\"
    && require (lab.maxRuntimeTargets == 5)
      \"reachability mini SMT must stay capped at five runtime targets\"
    && require (builtins.length lab.reachabilityRelations == 1)
      \"reachability mini SMT must test exactly one relation atom\"
    && require (lab.testsOnly == [
      \"reachability-decision-class\"
      \"deny-not-elevated\"
    ])
      \"reachability mini SMT must name only the decision atom checks\"
    && require (builtins.elem \"SAT\" lab.forbiddenScope)
      \"reachability mini SMT must forbid SAT scope\"
    && require (lab.liveSurfaces == [ \"s-router-nixos\" \"s-router-clab\" \"s-router-test-clients\" ])
      \"focused SIT must allow the three s-router active-lab surfaces\"
    && require (!(builtins.elem \"s-router-nixos\" lab.forbiddenScope))
      \"reachability mini SMT must allow focused s-router-nixos runtime evidence\"
    && require (!(builtins.elem \"s-router-clab\" lab.forbiddenScope))
      \"reachability mini SMT must allow focused s-router-clab runtime evidence\"
    && require (!(builtins.elem \"s-router-test-clients\" lab.forbiddenScope))
      \"reachability mini SMT must allow focused s-router-test-clients substrate evidence\"
    && require (valid.ok && valid.diagnostic == null && valid.decisionClass == \"allowed\")
      \"valid allow relation must classify as allowed\"
    && require (denied.ok && denied.diagnostic == null && denied.decisionClass == \"denied\")
      \"deny recovery case must classify as denied, not allowed\"
    && require (!missingId.ok && missingId.diagnostic == \"reachability-relation-id-missing\")
      \"missing relation id seeded negative must fail closed\"
    && require (!unsupported.ok && unsupported.diagnostic == \"reachability-action-unsupported\")
      \"unsupported action seeded negative must fail closed\"
" >/dev/null || fail "mini SMT reachability decision contract failed"

echo "PASS active-lab-mini-smt-reachability-decision-only"
