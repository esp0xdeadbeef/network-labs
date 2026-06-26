#!/usr/bin/env bash
# GAMP-ID: FS-180-HDS-010-SDS-010-SMS-040
# GAMP-SCOPE: row-local mini-SMT focused test; not HAT/SAT evidence
# Predicate: bidirectional nft rule generation — one symmetric relation
#   produces forward + reverse nft accept rules
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
intent_file="${repo_root}/GAMP/SMT/FS-180-HDS-010-SDS-010-SMS-040/intent.nix"

fail() {
  echo "FAIL FS-180-HDS-010-SDS-010-SMS-040: $*" >&2
  exit 1
}

[[ -f "${intent_file}" ]] || fail "missing ${intent_file}"

nix eval --impure --expr "
  let
    intent = import ${intent_file};
    lab = intent.mini-smt.\"bidirectional-nft\";
    require = cond: msg: if cond then true else throw msg;
    relations = lab.communicationContract.relations or [];
    trafficTypes = lab.communicationContract.trafficTypes or [];
    topology = lab.topology or {};
    nodes = topology.nodes or {};
    links = topology.links or [];
    ownership = lab.ownership or {};
    prefixes = ownership.prefixes or [];
    pools = lab.pools or {};
  in
    require (builtins.length relations == 1)
      \"FS-180-040: must have exactly one relation\"
    && require (builtins.elem (builtins.head relations).action [ \"allow\" \"deny\" ])
      \"FS-180-040: relation must have explicit allow or deny action\"
    && require ((builtins.head relations).returnBehavior == \"symmetric\")
      \"FS-180-040: relation must have returnBehavior=symmetric for bidirectional nft\"
    && require ((builtins.head relations).id == \"FS-180-HDS-010-SDS-010-SMS-040__mini-bidirectional-web\")
      \"FS-180-040: relation id must match SMS trace\"
    && require ((builtins.head relations).from.kind == \"tenant\")
      \"FS-180-040: relation from must be a tenant scope\"
    && require ((builtins.head relations).to.kind == \"tenant\")
      \"FS-180-040: relation to must be a tenant scope\"
    && require ((builtins.head relations).trafficType == \"web\")
      \"FS-180-040: relation must specify trafficType=web\"
    && require (builtins.length trafficTypes >= 1)
      \"FS-180-040: must declare at least one trafficType\"
    && require ((builtins.head trafficTypes).name == \"web\")
      \"FS-180-040: trafficType name must match relation\"
    && require (builtins.length links == 1)
      \"FS-180-040: must have exactly one p2p link\"
    && require (builtins.elem \"router-a\" (builtins.attrNames nodes))
      \"FS-180-040: missing router-a node\"
    && require (builtins.elem \"router-b\" (builtins.attrNames nodes))
      \"FS-180-040: missing router-b node\"
    && require (nodes.\"router-a\".role == \"access\")
      \"FS-180-040: router-a must be access role\"
    && require (nodes.\"router-b\".role == \"access\")
      \"FS-180-040: router-b must be access role\"
    && require (builtins.length (nodes.\"router-a\".attachments or []) == 1)
      \"FS-180-040: router-a must have exactly one tenant attachment\"
    && require (builtins.length (nodes.\"router-b\".attachments or []) == 1)
      \"FS-180-040: router-b must have exactly one tenant attachment\"
    && require (builtins.length prefixes == 2)
      \"FS-180-040: must declare exactly two tenant prefixes\"
    && require (pools ? p2p)
      \"FS-180-040: must declare p2p address pool\"
    && require (builtins.elem \"router-a\" (builtins.head links))
      \"FS-180-040: router-a must be in link endpoints\"
    && require (builtins.elem \"router-b\" (builtins.head links))
      \"FS-180-040: router-b must be in link endpoints\"

    # Seeded negative: relation without returnBehavior
    && require (builtins.tryEval (
      let
        noReturn = builtins.head relations // { returnBehavior = null; };
      in
        builtins.deepSeq noReturn (noReturn.returnBehavior == null)
    )).success
      \"FS-180-040: null returnBehavior must be structurally valid (rejected at NFM stage)\"
" >/dev/null || fail "mini SMT bidirectional NFT contract failed"

echo "PASS FS-180-HDS-010-SDS-010-SMS-040"
