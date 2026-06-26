#!/usr/bin/env bash
# GAMP-ID: FS-380-HDS-020-SDS-010-SMS-050
# GAMP-SCOPE: active-lab mini SMT; not HAT/SAT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mini_file="${repo_root}/GAMP/SMT/mini-smt/default.nix"
manifest_file="${repo_root}/GAMP/SMT/mini-smt/tests.nix"

fail() {
  echo "FAIL active-lab-mini-smt-internet-mode-verification-only: $*" >&2
  exit 1
}

[[ -f "${mini_file}" ]] || fail "missing ${mini_file}"
[[ -f "${manifest_file}" ]] || fail "missing ${manifest_file}"

nix eval --impure --expr "
  let
    mini = import ${mini_file};
    manifest = import ${manifest_file};
    lab = mini.labs.\"FS-380-HDS-020-SDS-010-SMS-050\";
    entry = manifest.tests.\"internet-mode-verification\";
    record = builtins.head lab.internetModeRecords;
    require = cond: msg: if cond then true else throw msg;
    valid = mini.validators.internetModeVerification record;
  in
    require (lab.kind == \"mini-smt\")
      \"internet-mode lab must be a mini SMT\"
    && require (lab.traceId == \"FS-380-HDS-020-SDS-010-SMS-050\")
      \"internet-mode lab must carry the exact SMS trace\"
    && require (entry.traceId == lab.traceId)
      \"internet-mode manifest must point at the same trace as the mini-lab\"
    && require (entry.script == \"tests/test-active-lab-mini-smt-internet-mode-verification-only.sh\")
      \"internet-mode manifest must point at this focused script\"
    && require (entry.independent == true && entry.aggregateOnly == false)
      \"internet-mode manifest must be independently runnable and not aggregate-only\"
    && require (entry.source.kind == \"intent-source\")
      \"internet-mode manifest must use a row-specific intent source\"
    && require (entry.source.expectedRelationIds == lab.source.expectedRelationIds)
      \"internet-mode manifest must carry the same expected relation id as the mini-lab\"
    && require (entry.maxRuntimeTargets == lab.maxRuntimeTargets)
      \"internet-mode manifest runtime cap must match the mini-lab runtime cap\"
    && require (entry.rendererTarget == null)
      \"internet-mode mini SMT must not be routed through a renderer aggregate target\"
    && require (builtins.attrNames lab.runtimeTargets == [ \"client-edge\" \"wan-core\" ])
      \"internet-mode mini SMT may start only client-edge and wan-core\"
    && require (lab.maxRuntimeTargets == 2)
      \"internet-mode mini SMT must stay capped at two runtime targets\"
    && require (builtins.length lab.internetModeRecords == 1)
      \"internet-mode mini SMT must test exactly one internet mode record\"
    && require (lab.testsOnly == [
      \"internet-mode-nat44-record\"
      \"internet-mode-source-prefixes\"
    ])
      \"internet-mode mini SMT must name only the internet mode atom checks\"
    && require (builtins.elem \"s-router-clab\" lab.forbiddenScope)
      \"internet-mode mini SMT must forbid full s-router-clab scope\"
    && require (valid.ok && valid.diagnostic == null)
      \"valid internet mode record must pass\"
" >/dev/null || fail "mini SMT internet mode verification contract failed"

echo "PASS active-lab-mini-smt-internet-mode-verification-only"
