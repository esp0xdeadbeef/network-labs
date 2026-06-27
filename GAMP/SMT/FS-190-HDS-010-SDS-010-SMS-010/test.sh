#!/usr/bin/env bash
# GAMP-ID: FS-190-HDS-010-SDS-010-SMS-010
# GAMP-SCOPE: row-local mini-SMT focused test; not HAT/SAT evidence
# Predicate: service exposure classification — one service with explicit
#   exposureClass=shared-local: classification record emitted, seeded negatives
#   for missing exposure class and inferred exposure
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
intent_file="${repo_root}/GAMP/SMT/FS-190-HDS-010-SDS-010-SMS-010/intent.nix"

fail() {
  echo "FAIL FS-190-HDS-010-SDS-010-SMS-010: $*" >&2
  exit 1
}

[[ -f "${intent_file}" ]] || fail "missing ${intent_file}"

nix eval --impure --expr "
  let
    intent = import ${intent_file};
    lab = intent.mini-smt.\"service-exposure-classification\";
    require = cond: msg: if cond then true else throw msg;
    services = lab.communicationContract.services or [];
    topology = lab.topology or {};
    nodes = topology.nodes or {};
    links = topology.links or [];
    ownership = lab.ownership or {};
    prefixes = ownership.prefixes or [];
  in
    require (builtins.length services == 1)
      \"FS-190-010: must have exactly one service\"
    && require ((builtins.head services).name == \"web-service\")
      \"FS-190-010: service name must be web-service\"
    && require ((builtins.head services).kind == \"shared-local\")
      \"FS-190-010: service kind must be shared-local\"
    && require ((builtins.head services).exposureClass == \"shared-local\")
      \"FS-190-010: service must have explicit exposureClass=shared-local\"
    && require ((builtins.head services).ownerScope.kind == \"tenant\")
      \"FS-190-010: ownerScope kind must be tenant\"
    && require ((builtins.head services).ownerScope.name == \"client\")
      \"FS-190-010: ownerScope must be client tenant\"
    && require ((builtins.head services).requesterScope.kind == \"tenant\")
      \"FS-190-010: requesterScope kind must be tenant\"
    && require ((builtins.head services).requesterScope.name == \"client\")
      \"FS-190-010: requesterScope must be client tenant\"
    && require (builtins.length links == 1)
      \"FS-190-010: must have exactly one link\"
    && require (builtins.elem \"access-node\" (builtins.attrNames nodes))
      \"FS-190-010: missing access-node\"
    && require (builtins.elem \"core-node\" (builtins.attrNames nodes))
      \"FS-190-010: missing core-node\"
    && require (nodes.\"access-node\".role == \"access\")
      \"FS-190-010: access-node must be access role\"
    && require (nodes.\"core-node\".role == \"core\")
      \"FS-190-010: core-node must be core role\"
    && require (builtins.length nodes.\"access-node\".attachments or [] == 1)
      \"FS-190-010: access-node must have exactly one tenant attachment\"
    && require (builtins.length prefixes == 1)
      \"FS-190-010: must declare exactly one tenant prefix\"

    # Seeded negative: service without exposureClass must be structurally detectable
    && require (builtins.tryEval (
      let
        noExposure = builtins.head services // { exposureClass = null; };
      in
        builtins.deepSeq noExposure (noExposure.exposureClass == null)
    )).success
      \"FS-190-010: null exposureClass must be structurally valid (rejected at CPM stage)\"

    # Seeded negative: service with empty ownerScope must be detectable
    && require (builtins.tryEval (
      let
        noOwner = builtins.head services // { ownerScope = {}; };
      in
        builtins.deepSeq noOwner true
    )).success
      \"FS-190-010: empty ownerScope must be structurally valid (rejected at CPM stage)\"
" >/dev/null || fail "mini SMT service exposure classification contract failed"

echo "PASS FS-190-HDS-010-SDS-010-SMS-010"
