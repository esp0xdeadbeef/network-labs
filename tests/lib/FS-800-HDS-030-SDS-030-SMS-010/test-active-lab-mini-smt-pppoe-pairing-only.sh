#!/usr/bin/env bash
# GAMP-ID: FS-800-HDS-030-SDS-030-SMS-010
# GAMP-SCOPE: active-lab mini SMT; not HAT/SAT evidence
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
mini_file="${repo_root}/GAMP/SMT/mini-smt/default.nix"
manifest_file="${repo_root}/GAMP/SMT/mini-smt/tests.nix"

fail() {
  echo "FAIL active-lab-mini-smt-pppoe-pairing-only: $*" >&2
  exit 1
}

[[ -f "${mini_file}" ]] || fail "missing ${mini_file}"
[[ -f "${manifest_file}" ]] || fail "missing ${manifest_file}"

nix eval --impure --expr "
  let
    mini = import ${mini_file};
    manifest = import ${manifest_file};
    lab = mini.labs.\"FS-800-HDS-030-SDS-030-SMS-010\";
    entry = manifest.tests.\"FS-800-HDS-030-SDS-030-SMS-010\";
    rowIntent = import ${repo_root}/GAMP/SMT/FS-800-HDS-030-SDS-030-SMS-010/intent.nix;
    rowSource = rowIntent.\"mini-smt\".\"FS-800-HDS-030-SDS-030-SMS-010\";
    pair = lab.pppoePairs.primary;
    require = cond: msg: if cond then true else throw msg;
    rowNodes = builtins.attrNames rowSource.topology.nodes;
    rowLinks = rowSource.topology.links;
    valid = mini.validators.pppoePair pair;
    providerOnly = mini.validators.pppoePair (removeAttrs pair [ \"customer\" ]);
    customerOnly = mini.validators.pppoePair (removeAttrs pair [ \"provider\" ]);
    unpaired = mini.validators.pppoePair { };
    fallbackEnabled = mini.validators.pppoePair (pair // { fallback = true; });
    opaqueTransport = mini.validators.pppoePair (pair // { transportClassification = \"opaque\"; });
  in
    require (lab.kind == \"mini-smt\")
      \"PPPoE lab must be a mini SMT\"
    && require (lab.traceId == \"FS-800-HDS-030-SDS-030-SMS-010\")
      \"PPPoE lab must carry the exact SMS trace\"
    && require (entry.traceId == lab.traceId)
      \"PPPoE manifest must point at the same trace as the mini-lab\"
    && require (entry.independent == true && entry.aggregateOnly == false)
      \"PPPoE manifest must be independently runnable and not aggregate-only\"
    && require (entry.source.kind == \"intent-source\")
      \"PPPoE manifest must use a row-specific intent source\"
    && require (entry.source.expectedRelationIds == lab.source.expectedRelationIds)
      \"PPPoE manifest must carry the same expected relation id as the mini-lab\"
    && require (entry.maxRuntimeTargets == lab.maxRuntimeTargets)
      \"PPPoE manifest runtime cap must match the mini-lab runtime cap\"
    && require (entry.rendererTarget == null)
      \"PPPoE mini SMT must not be routed through a renderer aggregate target\"
    && require (builtins.attrNames lab.runtimeTargets == [
      \"downstream-selector\"
      \"policy\"
      \"pppoe-client\"
      \"pppoe-provider\"
      \"upstream-selector\"
    ])
      \"PPPoE mini SMT runtime target declaration must match the five-node current-lab path\"
    && require (lab.maxRuntimeTargets == 5)
      \"PPPoE mini SMT must stay capped at five runtime targets\"
    && require (builtins.length rowNodes == 5)
      \"PPPoE row source must contain exactly five topology nodes\"
    && require (rowNodes == [
      \"downstream-selector\"
      \"policy\"
      \"pppoe-client\"
      \"pppoe-provider\"
      \"upstream-selector\"
    ])
      \"PPPoE row source nodes must match the current-lab five-node path\"
    && require (builtins.elem [ \"pppoe-client\" \"downstream-selector\" ] rowLinks)
      \"PPPoE row source missing pppoe-client -> downstream-selector link\"
    && require (builtins.elem [ \"downstream-selector\" \"policy\" ] rowLinks)
      \"PPPoE row source missing downstream-selector -> policy link\"
    && require (builtins.elem [ \"policy\" \"upstream-selector\" ] rowLinks)
      \"PPPoE row source missing policy -> upstream-selector link\"
    && require (builtins.elem [ \"upstream-selector\" \"pppoe-provider\" ] rowLinks)
      \"PPPoE row source missing upstream-selector -> pppoe-provider link\"
    && require (rowSource.topology.nodes.\"pppoe-provider\".uplinks ? pppoe-provider)
      \"PPPoE row source provider node must expose the pppoe-provider uplink\"
    && require (lab.testsOnly == [
      \"provider-customer-pairing\"
      \"fallback-rejection\"
      \"transport-classification\"
    ])
      \"PPPoE mini SMT must name only the pairing/fallback atom checks\"
    && require (!(builtins.elem \"s-router-nixos\" lab.forbiddenScope))
      \"PPPoE mini SMT must allow focused s-router-nixos runtime evidence\"
    && require (!(builtins.elem \"s-router-clab\" lab.forbiddenScope))
      \"PPPoE mini SMT must allow focused s-router-clab runtime evidence\"
    && require (!(builtins.elem \"s-router-test-clients\" lab.forbiddenScope))
      \"PPPoE mini SMT must allow focused s-router-test-clients reachability evidence\"
    && require (valid.ok && valid.diagnostic == null)
      \"valid PPPoE pair must pass\"
    && require (!providerOnly.ok && providerOnly.diagnostic == \"missing-customer-surface\")
      \"provider-only seeded negative must fail with missing-customer-surface\"
    && require (!customerOnly.ok && customerOnly.diagnostic == \"missing-provider-surface\")
      \"customer-only seeded negative must fail with missing-provider-surface\"
    && require (!unpaired.ok && unpaired.diagnostic == \"unpaired-pppoe-row\")
      \"unpaired seeded negative must fail with unpaired-pppoe-row\"
    && require (!fallbackEnabled.ok && fallbackEnabled.diagnostic == \"fallback-enabled\")
      \"fallback seeded negative must fail with fallback-enabled\"
    && require (!opaqueTransport.ok && opaqueTransport.diagnostic == \"opaque-transport-classification\")
      \"opaque transport seeded negative must fail with opaque-transport-classification\"
" >/dev/null || fail "mini SMT PPPoE contract failed"

echo "PASS active-lab-mini-smt-pppoe-pairing-only"
