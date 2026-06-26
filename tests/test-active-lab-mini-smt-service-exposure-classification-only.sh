#!/usr/bin/env bash
# GAMP-ID: FS-190-HDS-010-SDS-010-SMS-010
# GAMP-SCOPE: active-lab mini SMT; not HAT/SAT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mini_file="${repo_root}/GAMP/SMT/mini-smt/default.nix"
manifest_file="${repo_root}/GAMP/SMT/mini-smt/tests.nix"

fail() {
  echo "FAIL active-lab-mini-smt-service-exposure-classification-only: $*" >&2
  exit 1
}

[[ -f "${mini_file}" ]] || fail "missing ${mini_file}"
[[ -f "${manifest_file}" ]] || fail "missing ${manifest_file}"

nix eval --impure --expr "
  let
    mini = import ${mini_file};
    manifest = import ${manifest_file};
    lab = mini.labs.\"FS-190-HDS-010-SDS-010-SMS-010\";
    entry = manifest.tests.\"service-exposure-classification\";
    service = builtins.head lab.serviceExposureServices;
    require = cond: msg: if cond then true else throw msg;
    valid = mini.validators.serviceExposureClassification service;
    noExposureClass = mini.validators.serviceExposureClassification (builtins.removeAttrs service [ \"exposureClass\" ]);
    noName = mini.validators.serviceExposureClassification (builtins.removeAttrs service [ \"name\" ]);
    noOwnerScope = mini.validators.serviceExposureClassification (builtins.removeAttrs service [ \"ownerScope\" ]);
  in
    require (lab.kind == \"mini-smt\")
      \"service-exposure lab must be a mini SMT\"
    && require (lab.traceId == \"FS-190-HDS-010-SDS-010-SMS-010\")
      \"service-exposure lab must carry the exact SMS trace\"
    && require (entry.traceId == lab.traceId)
      \"service-exposure manifest must point at the same trace as the mini-lab\"
    && require (entry.script == \"tests/test-active-lab-mini-smt-service-exposure-classification-only.sh\")
      \"service-exposure manifest must point at this focused script\"
    && require (entry.independent == true && entry.aggregateOnly == false)
      \"service-exposure manifest must be independently runnable and not aggregate-only\"
    && require (entry.source.kind == \"intent-source\")
      \"service-exposure manifest must use a row-specific intent source\"
    && require (entry.maxRuntimeTargets == lab.maxRuntimeTargets)
      \"service-exposure manifest runtime cap must match the mini-lab runtime cap\"
    && require (entry.rendererTarget == null)
      \"service-exposure mini SMT must not be routed through a renderer aggregate target\"
    && require (builtins.attrNames lab.runtimeTargets == [ \"access-node\" \"core-node\" ])
      \"service-exposure mini SMT may start only access-node and core-node\"
    && require (lab.maxRuntimeTargets == 2)
      \"service-exposure mini SMT must stay capped at two runtime targets\"
    && require (builtins.length lab.serviceExposureServices == 1)
      \"service-exposure mini SMT must test exactly one service\"
    && require (lab.testsOnly == [
      \"service-exposure-classification-present\"
      \"missing-exposure-class-diagnostic\"
      \"no-inference-from-host-placement\"
    ])
      \"service-exposure mini SMT must name only the classification atom checks\"
    && require (builtins.elem \"s-router-nixos\" lab.forbiddenScope)
      \"service-exposure mini SMT must forbid s-router-nixos scope\"
    && require (builtins.elem \"SAT\" lab.forbiddenScope)
      \"service-exposure mini SMT must forbid SAT scope\"
    && require (service.exposureClass == \"shared-local\")
      \"service must carry explicit exposureClass=shared-local\"
    && require (service.ownerScope.kind == \"tenant\" && service.ownerScope.name == \"client\")
      \"service must carry ownerScope tenant=client\"
    && require (valid.ok && valid.diagnostic == null)
      \"valid service with exposure class must pass\"
    && require (!noExposureClass.ok && noExposureClass.diagnostic == \"missing-exposure-class\")
      \"missing exposureClass seeded negative must fail with missing-exposure-class\"
    && require (!noName.ok && noName.diagnostic == \"service-exposure-missing-name\")
      \"missing name seeded negative must fail closed\"
    && require (!noOwnerScope.ok && noOwnerScope.diagnostic == \"service-exposure-missing-owner-scope\")
      \"missing ownerScope seeded negative must fail closed\"
" >/dev/null || fail "mini SMT service exposure classification contract failed"

echo "PASS active-lab-mini-smt-service-exposure-classification-only"
