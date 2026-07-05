#!/usr/bin/env bash
# GAMP-ID: FS-500-HDS-010-SDS-010-SMS-030
# GAMP-SCOPE: active-lab mini SMT; not HAT/SAT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mini_file="${repo_root}/GAMP/SMT/mini-smt/default.nix"
manifest_file="${repo_root}/GAMP/SMT/mini-smt/tests.nix"

fail() {
  echo "FAIL active-lab-mini-smt-decision-reason-diagnostic-only: $*" >&2
  exit 1
}

[[ -f "${mini_file}" ]] || fail "missing ${mini_file}"
[[ -f "${manifest_file}" ]] || fail "missing ${manifest_file}"

nix eval --impure --expr "
  let
    mini = import ${mini_file};
    manifest = import ${manifest_file};
    lab = mini.labs.\"FS-500-HDS-010-SDS-010-SMS-030\";
    entry = manifest.tests.\"FS-500-HDS-010-SDS-010-SMS-030\";
    require = cond: msg: if cond then true else throw msg;
    validPath = mini.validators.decisionReasonDiagnostic {
      relationId = \"FS-500-HDS-010-SDS-010-SMS-030__mini-decision-reason-diagnostic\";
      action = \"allow\";
    };
    missingEvidencePath = mini.validators.decisionReasonDiagnostic {
      relationId = \"non-existent-allow\";
      action = \"allow\";
    };
    contradictionPath = mini.validators.decisionReasonDiagnostic {
      relationId = \"FS-500-HDS-010-SDS-010-SMS-030__mini-decision-reason-diagnostic\";
      action = \"reject\";
    };
    missingActionPath = mini.validators.decisionReasonDiagnostic {
      relationId = \"FS-500-HDS-010-SDS-010-SMS-030__mini-decision-reason-diagnostic\";
    };
  in
    require (lab.kind == \"mini-smt\")
      \"decision-reason-diagnostic lab must be a mini SMT\"
    && require (lab.traceId == \"FS-500-HDS-010-SDS-010-SMS-030\")
      \"decision-reason-diagnostic lab must carry the exact SMS trace\"
    && require (entry.traceId == lab.traceId)
      \"manifest must point at the same trace as the mini-lab\"
    && require (entry.independent == true && entry.aggregateOnly == false)
      \"manifest must be independently runnable and not aggregate-only\"
    && require (entry.source.kind == \"intent-source\")
      \"manifest must use a row-specific intent source\"
    && require (entry.source.expectedRelationIds == lab.source.expectedRelationIds)
      \"manifest must carry the same expected relation id as the mini-lab\"
    && require (entry.maxRuntimeTargets == lab.maxRuntimeTargets)
      \"manifest runtime cap must match the mini-lab runtime cap\"
    && require (entry.rendererTarget == null)
      \"mini SMT must not be routed through a renderer aggregate target\"
    && require (builtins.attrNames lab.runtimeTargets == [
      \"client-edge\"
      \"downstream-selector\"
      \"policy\"
      \"vlan4-client-dhcp-slaac\"
      \"upstream-selector\"
    ])
      \"mini SMT must use the five-node policy path required by active-lab current-lab\"
    && require (lab.maxRuntimeTargets == 5)
      \"mini SMT must stay capped at five runtime targets\"
    && require (lab.liveSurfaces == [ \"s-router-nixos\" \"s-router-clab\" \"s-router-test-clients\" ])
      \"focused SIT must allow the three s-router active-lab surfaces\"
    && require (builtins.length lab.decisionReasonRelations == 1)
      \"mini SMT must test exactly one decision reason relation atom\"
    && require (validPath.ok && validPath.diagnostic == null)
      \"valid allow path must have no diagnostic\"
    && require (!missingEvidencePath.ok && missingEvidencePath.diagnostic == \"missing-evidence\")
      \"non-existent relation must fail with missing-evidence diagnostic\"
    && require (!contradictionPath.ok && contradictionPath.diagnostic == \"contract-contradiction\")
      \"action mismatch must fail with contract-contradiction diagnostic\"
    && require (!missingActionPath.ok && missingActionPath.diagnostic == \"missing-action-field\")
      \"missing action field must fail with missing-action-field diagnostic\"
" >/dev/null || fail "mini SMT decision reason diagnostic contract failed"

echo "PASS active-lab-mini-smt-decision-reason-diagnostic-only"
