#!/usr/bin/env bash
# GAMP-ID: FS-180-HDS-010-SDS-010-SMS-040
# GAMP-SCOPE: active-lab mini SMT; not HAT/SAT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mini_file="${repo_root}/GAMP/SMT/mini-smt/default.nix"
manifest_file="${repo_root}/GAMP/SMT/mini-smt/tests.nix"

fail() {
  echo "FAIL active-lab-mini-smt-bidirectional-nft-only: $*" >&2
  exit 1
}

[[ -f "${mini_file}" ]] || fail "missing ${mini_file}"
[[ -f "${manifest_file}" ]] || fail "missing ${manifest_file}"

nix eval --impure --expr "
  let
    mini = import ${mini_file};
    manifest = import ${manifest_file};
    lab = mini.labs.\"FS-180-HDS-010-SDS-010-SMS-040\";
    entry = manifest.tests.\"bidirectional-nft\";
    relation = builtins.head lab.bidirectionalNftRelations;
    require = cond: msg: if cond then true else throw msg;
    forwardRule = builtins.head relation.expectedForwardRules;
    reverseRule = builtins.head relation.expectedReverseRules;
    validForward = mini.validators.bidirectionalNft forwardRule;
    validReverse = mini.validators.bidirectionalNft reverseRule;
    noRelationId = mini.validators.bidirectionalNft (builtins.removeAttrs forwardRule [ \"relationId\" ]);
    noDirection = mini.validators.bidirectionalNft (builtins.removeAttrs forwardRule [ \"direction\" ]);
    wrongDirection = mini.validators.bidirectionalNft (forwardRule // { direction = \"relation-sideways\"; });
    relationWithoutReturn = relation // { returnBehavior = null; };
    relationUnrecognized = relation // { returnBehavior = \"asymmetric\"; };
  in
    require (lab.kind == \"mini-smt\")
      \"bidirectional-nft lab must be a mini SMT\"
    && require (lab.traceId == \"FS-180-HDS-010-SDS-010-SMS-040\")
      \"bidirectional-nft lab must carry the exact SMS trace\"
    && require (entry.traceId == lab.traceId)
      \"bidirectional-nft manifest must point at the same trace as the mini-lab\"
    && require (entry.script == \"tests/test-active-lab-mini-smt-bidirectional-nft-only.sh\")
      \"bidirectional-nft manifest must point at this focused script\"
    && require (entry.independent == true && entry.aggregateOnly == false)
      \"bidirectional-nft manifest must be independently runnable and not aggregate-only\"
    && require (entry.source.kind == \"intent-source\")
      \"bidirectional-nft manifest must use a row-specific intent source\"
    && require (entry.source.expectedRelationIds == lab.source.expectedRelationIds)
      \"bidirectional-nft manifest must carry the same expected relation id as the mini-lab\"
    && require (entry.maxRuntimeTargets == lab.maxRuntimeTargets)
      \"bidirectional-nft manifest runtime cap must match the mini-lab runtime cap\"
    && require (entry.rendererTarget == null)
      \"bidirectional-nft mini SMT must not be routed through a renderer aggregate target\"
    && require (builtins.attrNames lab.runtimeTargets == [ \"router-a\" \"router-b\" ])
      \"bidirectional-nft mini SMT may start only router-a and router-b\"
    && require (lab.maxRuntimeTargets == 2)
      \"bidirectional-nft mini SMT must stay capped at two runtime targets\"
    && require (builtins.length lab.bidirectionalNftRelations == 1)
      \"bidirectional-nft mini SMT must test exactly one bidirectional relation\"
    && require (lab.testsOnly == [
      \"symmetric-return-forward-plus-reverse\"
      \"absent-return-forward-only\"
      \"unrecognized-return-rejected\"
    ])
      \"bidirectional-nft mini SMT must name only the bidirectional rule checks\"
    && require (builtins.elem \"s-router-nixos\" lab.forbiddenScope)
      \"bidirectional-nft mini SMT must forbid s-router-nixos scope\"
    && require (builtins.elem \"SAT\" lab.forbiddenScope)
      \"bidirectional-nft mini SMT must forbid SAT scope\"
    && require (relation.returnBehavior == \"symmetric\")
      \"relation must carry returnBehavior=symmetric\"
    && require (builtins.length relation.expectedForwardRules == 1)
      \"symmetric relation must have exactly one expected forward rule\"
    && require (builtins.length relation.expectedReverseRules == 1)
      \"symmetric relation must have exactly one expected reverse rule\"
    && require (validForward.ok && validForward.direction == \"forward\" && validForward.diagnostic == null)
      \"valid forward rule must pass with direction=forward\"
    && require (validReverse.ok && validReverse.direction == \"reverse\" && validReverse.diagnostic == null)
      \"valid reverse rule must pass with direction=reverse\"
    && require (!noRelationId.ok && noRelationId.diagnostic == \"bidirectional-nft-rule-missing-relation-id\")
      \"missing relationId seeded negative must fail closed\"
    && require (!noDirection.ok && noDirection.diagnostic == \"bidirectional-nft-rule-missing-direction\")
      \"missing direction seeded negative must fail closed\"
    && require (!wrongDirection.ok && wrongDirection.diagnostic == \"bidirectional-nft-rule-invalid-direction\")
      \"wrong direction seeded negative must fail closed\"
    && require (reverseRule.direction == \"relation-reverse\")
      \"reverse rule must carry direction=relation-reverse\"
    && require (reverseRule.source == forwardRule.destination)
      \"reverse rule source must equal forward rule destination (endpoints swapped)\"
    && require (reverseRule.destination == forwardRule.source)
      \"reverse rule destination must equal forward rule source (endpoints swapped)\"
    && require (reverseRule.trafficType == forwardRule.trafficType)
      \"reverse rule trafficType must match forward rule trafficType\"
    && require (reverseRule.protocol == forwardRule.protocol)
      \"reverse rule protocol must match forward rule protocol\"
    && require (reverseRule.port == forwardRule.port)
      \"reverse rule port must match forward rule port\"
" >/dev/null || fail "mini SMT bidirectional nft contract failed"

echo "PASS active-lab-mini-smt-bidirectional-nft-only"
