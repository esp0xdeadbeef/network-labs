#!/usr/bin/env bash
# GAMP-ID: FS-500-HDS-010-SDS-010-SMS-040
# GAMP-SCOPE: active-lab mini SMT; not HAT/SAT evidence
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
mini_file="${repo_root}/GAMP/SMT/mini-smt/default.nix"
manifest_file="${repo_root}/GAMP/SMT/mini-smt/tests.nix"

fail() {
  echo "FAIL active-lab-mini-smt-p2p-next-hop-only: $*" >&2
  exit 1
}

[[ -f "${mini_file}" ]] || fail "missing ${mini_file}"
[[ -f "${manifest_file}" ]] || fail "missing ${manifest_file}"

nix eval --impure --expr "
  let
    mini = import ${mini_file};
    manifest = import ${manifest_file};
    lab = mini.labs.\"FS-500-HDS-010-SDS-010-SMS-040\";
    entry = manifest.tests.\"FS-500-HDS-010-SDS-010-SMS-040\";
    route = builtins.head lab.expectedRoutes;
    require = cond: msg: if cond then true else throw msg;
    valid = mini.validators.p2pRoute lab route;
    wrongLink = mini.validators.p2pRoute lab (route // { link = \"p2p-missing\"; });
    wrongNextHop = mini.validators.p2pRoute lab (route // { via4 = \"10.0.0.99\"; });
    selfNextHop = mini.validators.p2pRoute lab (route // { via4 = \"10.0.0.0\"; });
  in
    require (lab.kind == \"mini-smt\")
      \"p2p lab must be a mini SMT\"
    && require (lab.traceId == \"FS-500-HDS-010-SDS-010-SMS-040\")
      \"p2p lab must carry the exact SMS trace\"
    && require (entry.traceId == lab.traceId)
      \"p2p manifest must point at the same trace as the mini-lab\"
    && require (entry.independent == true && entry.aggregateOnly == false)
      \"p2p manifest must be independently runnable and not aggregate-only\"
    && require (entry.source.kind == \"intent-source\")
      \"p2p manifest must use a row-specific intent source\"
    && require (entry.source.expectedRelationIds == lab.source.expectedRelationIds)
      \"p2p manifest must carry the same expected relation id as the mini-lab\"
    && require (entry.maxRuntimeTargets == lab.maxRuntimeTargets)
      \"p2p manifest runtime cap must match the mini-lab runtime cap\"
    && require (entry.rendererTarget == null)
      \"p2p mini SMT must not be routed through a renderer aggregate target\"
    && require (builtins.attrNames lab.runtimeTargets == [
      \"downstream-selector\"
      \"policy\"
      \"router-a\"
      \"router-b\"
      \"upstream-selector\"
    ])
      \"p2p mini SMT must use the five-node active-lab p2p policy path\"
    && require (builtins.attrNames lab.links == [ \"p2p-ab\" ])
      \"p2p mini SMT must carry exactly one p2p link\"
    && require (lab.maxRuntimeTargets == 5)
      \"p2p mini SMT must stay capped at five runtime targets\"
    && require (builtins.length lab.expectedRoutes == 1)
      \"p2p mini SMT must test exactly one route atom\"
    && require (lab.testsOnly == [
      \"p2p-peer-next-hop\"
      \"route-renderability-shape\"
      \"five-node-runtime-shape\"
    ])
      \"p2p mini SMT must name only the p2p route atom checks\"
    && require (lab.liveSurfaces == [ \"s-router-nixos\" \"s-router-clab\" \"s-router-test-clients\" ])
      \"focused SIT must allow the three s-router active-lab surfaces\"
    && require (valid.ok && valid.diagnostic == null)
      \"valid p2p route must pass\"
    && require (!wrongLink.ok && wrongLink.diagnostic == \"p2p-link-missing\")
      \"missing-link seeded negative must fail with p2p-link-missing\"
    && require (!wrongNextHop.ok && wrongNextHop.diagnostic == \"p2p-next-hop-not-on-link\")
      \"wrong-next-hop seeded negative must fail with p2p-next-hop-not-on-link\"
    && require (!selfNextHop.ok && selfNextHop.diagnostic == \"p2p-next-hop-is-self\")
      \"self-next-hop seeded negative must fail with p2p-next-hop-is-self\"
" >/dev/null || fail "mini SMT p2p contract failed"

echo "PASS active-lab-mini-smt-p2p-next-hop-only"
