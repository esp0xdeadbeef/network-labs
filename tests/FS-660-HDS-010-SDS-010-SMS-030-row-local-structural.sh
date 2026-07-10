#!/usr/bin/env bash
# GAMP-ID: FS-660-HDS-010-SDS-010-SMS-030
# GAMP-SCOPE: row-local focused SMT construction test; not HAT/SAT evidence
# Validates: row-local intent.nix topology structure, relation IDs, ownership, pools
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
intent_file="${repo_root}/GAMP/SMT/FS-660-HDS-010-SDS-010-SMS-030/intent.nix"
trace_id="FS-660-HDS-010-SDS-010-SMS-030"

fail() {
  echo "FAIL ${trace_id} row-local-structural: $*" >&2
  exit 1
}

[[ -f "${intent_file}" ]] || fail "missing ${intent_file}"

nix eval --impure --expr "
  let
    intent = import ${intent_file};
    lab = intent.mini-smt.\"${trace_id}\";
    require = cond: msg: if cond then true else throw msg;
    nodes = builtins.attrNames lab.topology.nodes;
    links = lab.topology.links;
    relations = lab.communicationContract.relations;
  in
    require (builtins.length nodes == 5)
      \"P1 FAIL: expected 5 nodes, got \${toString (builtins.length nodes)}\"
    && require (builtins.elem \"client-edge\" nodes)
      \"P1 FAIL: missing client-edge node\"
    && require (builtins.elem \"downstream-selector\" nodes)
      \"P1 FAIL: missing downstream-selector node\"
    && require (builtins.elem \"policy\" nodes)
      \"P1 FAIL: missing policy node\"
    && require (builtins.elem \"upstream-selector\" nodes)
      \"P1 FAIL: missing upstream-selector node\"
    && require (builtins.elem \"core-vlan4-client-dhcp-slaac\" nodes)
      \"P1 FAIL: missing core-vlan4-client-dhcp-slaac node\"
    && require (builtins.length links == 4)
      \"P2 FAIL: expected 4 links, got \${toString (builtins.length links)}\"
    && require (links == [
      [ \"client-edge\" \"downstream-selector\" ]
      [ \"downstream-selector\" \"policy\" ]
      [ \"policy\" \"upstream-selector\" ]
      [ \"upstream-selector\" \"core-vlan4-client-dhcp-slaac\" ]
    ])
      \"P2 FAIL: fabric link chain mismatch\"
    && require (lab.topology.nodes.\"client-edge\".role == \"access\")
      \"P3 FAIL: client-edge must be access role\"
    && require (builtins.length lab.topology.nodes.\"client-edge\".attachments == 1)
      \"P3 FAIL: client-edge must have 1 attachment\"
    && require (builtins.any (a: a.kind == \"tenant\" && a.name == \"client\") lab.topology.nodes.\"client-edge\".attachments)
      \"P3 FAIL: missing client tenant attachment\"
    && require (lab.topology.nodes.\"core-vlan4-client-dhcp-slaac\".role == \"core\")
      \"P4 FAIL: core-vlan4-client-dhcp-slaac must be core role\"
    && require (lab.topology.nodes.\"core-vlan4-client-dhcp-slaac\" ? uplinks)
      \"P4 FAIL: core missing uplinks\"
    && require (lab.topology.nodes.\"core-vlan4-client-dhcp-slaac\".uplinks ? \"internet-vlan4\")
      \"P4 FAIL: core missing internet-vlan4 uplink\"
    && require (builtins.length relations == 1)
      \"P5 FAIL: expected 1 relation, got \${toString (builtins.length relations)}\"
    && require ((builtins.head relations).id == \"${trace_id}__mini-verify\")
      \"P5 FAIL: relation ID mismatch\"
    && require ((builtins.head relations).action == \"allow\")
      \"P6 FAIL: relation must be allow\"
    && require ((builtins.head relations).from.kind == \"tenant\" && (builtins.head relations).from.name == \"client\")
      \"P6 FAIL: relation from must be tenant client\"
    && require ((builtins.head relations).to.kind == \"external\")
      \"P6 FAIL: relation to must be external\"
    && require (builtins.length lab.ownership.prefixes == 1)
      \"P7 FAIL: expected 1 ownership prefix\"
    && require ((builtins.head lab.ownership.prefixes).kind == \"tenant\")
      \"P7 FAIL: prefix kind must be tenant\"
    && require (lab.pools ? loopback && lab.pools ? p2p)
      \"P8 FAIL: missing pool definitions\"
    && require (lab.communicationContract ? interfaceTags)
      \"P9 FAIL: missing interfaceTags\"
    && require (builtins.length lab.communicationContract.trafficTypes == 1)
      \"P10 FAIL: expected 1 trafficType\"
" >/dev/null || fail "intent.nix structural validation failed"

echo "PASS ${trace_id} row-local-structural (10/10 structural predicates)"
echo ""
echo "Evidence tier: construction/local-build"
echo ""
echo "NOTE: This is a structural validation of the row-local intent fixture only."
echo "SMS predicate verification for FS-660-HDS-010-SDS-010-SMS-030 is in the owning repo construction test."
echo "SMS Validation Evidence Boundary: construction-only."
