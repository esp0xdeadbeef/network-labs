#!/usr/bin/env bash
# GAMP-ID: FS-800-HDS-030-SDS-030-SMS-010
# GAMP-SCOPE: active-lab mini SMT; not HAT/SAT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mini_file="${repo_root}/active-lab/mini-smt/default.nix"

fail() {
  echo "FAIL active-lab-mini-smt-pppoe-pairing-only: $*" >&2
  exit 1
}

[[ -f "${mini_file}" ]] || fail "missing ${mini_file}"

nix eval --impure --expr "
  let
    mini = import ${mini_file};
    lab = mini.labs.\"FS-800-HDS-030-SDS-030-SMS-010\";
    pair = lab.pppoePairs.primary;
    require = cond: msg: if cond then true else throw msg;
    valid = mini.validators.pppoePair pair;
    providerOnly = mini.validators.pppoePair (removeAttrs pair [ \"customer\" ]);
    customerOnly = mini.validators.pppoePair (removeAttrs pair [ \"provider\" ]);
    fallbackEnabled = mini.validators.pppoePair (pair // { fallback = true; });
    opaqueTransport = mini.validators.pppoePair (pair // { transportClassification = \"opaque\"; });
  in
    require (lab.kind == \"mini-smt\")
      \"PPPoE lab must be a mini SMT\"
    && require (lab.traceId == \"FS-800-HDS-030-SDS-030-SMS-010\")
      \"PPPoE lab must carry the exact SMS trace\"
    && require (builtins.attrNames lab.runtimeTargets == [ \"pppoe-client\" \"pppoe-server\" ])
      \"PPPoE mini SMT may start only pppoe-client and pppoe-server\"
    && require (lab.maxRuntimeTargets == 2)
      \"PPPoE mini SMT must stay capped at two runtime targets\"
    && require (lab.testsOnly == [
      \"provider-customer-pairing\"
      \"fallback-rejection\"
      \"transport-classification\"
    ])
      \"PPPoE mini SMT must name only the pairing/fallback atom checks\"
    && require (builtins.elem \"s-router-nixos\" lab.forbiddenScope)
      \"PPPoE mini SMT must forbid full s-router-nixos scope\"
    && require (valid.ok && valid.diagnostic == null)
      \"valid PPPoE pair must pass\"
    && require (!providerOnly.ok && providerOnly.diagnostic == \"missing-customer-surface\")
      \"provider-only seeded negative must fail with missing-customer-surface\"
    && require (!customerOnly.ok && customerOnly.diagnostic == \"missing-provider-surface\")
      \"customer-only seeded negative must fail with missing-provider-surface\"
    && require (!fallbackEnabled.ok && fallbackEnabled.diagnostic == \"fallback-enabled\")
      \"fallback seeded negative must fail with fallback-enabled\"
    && require (!opaqueTransport.ok && opaqueTransport.diagnostic == \"opaque-transport-classification\")
      \"opaque transport seeded negative must fail with opaque-transport-classification\"
" >/dev/null || fail "mini SMT PPPoE contract failed"

echo "PASS active-lab-mini-smt-pppoe-pairing-only"
