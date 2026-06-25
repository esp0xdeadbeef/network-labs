#!/usr/bin/env bash
# GAMP-ID: FS-500-HDS-010-SDS-010-SMS-040
# GAMP-SCOPE: active-lab mini SMT; not HAT/SAT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mini_file="${repo_root}/active-lab/mini-smt/default.nix"

fail() {
  echo "FAIL active-lab-mini-smt-p2p-next-hop-only: $*" >&2
  exit 1
}

[[ -f "${mini_file}" ]] || fail "missing ${mini_file}"

nix eval --impure --expr "
  let
    mini = import ${mini_file};
    lab = mini.labs.\"FS-500-HDS-010-SDS-010-SMS-040\";
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
    && require (builtins.attrNames lab.runtimeTargets == [ \"router-a\" \"router-b\" ])
      \"p2p mini SMT may start only router-a and router-b\"
    && require (builtins.attrNames lab.links == [ \"p2p-ab\" ])
      \"p2p mini SMT must carry exactly one p2p link\"
    && require (lab.maxRuntimeTargets == 2)
      \"p2p mini SMT must stay capped at two runtime targets\"
    && require (builtins.length lab.expectedRoutes == 1)
      \"p2p mini SMT must test exactly one route atom\"
    && require (lab.testsOnly == [
      \"p2p-peer-next-hop\"
      \"route-renderability-shape\"
    ])
      \"p2p mini SMT must name only the p2p route atom checks\"
    && require (builtins.elem \"s-router-clab\" lab.forbiddenScope)
      \"p2p mini SMT must forbid full s-router-clab scope\"
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
