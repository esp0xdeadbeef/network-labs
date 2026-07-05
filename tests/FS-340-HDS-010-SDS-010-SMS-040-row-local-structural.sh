#!/usr/bin/env bash
# GAMP-ID: FS-340-HDS-010-SDS-010-SMS-040
# GAMP-SCOPE: row-local focused SMT construction test; not HAT/SAT evidence
# Validates: row-local intent.nix topology structure, relation IDs, ownership, pools
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
intent_file="${repo_root}/GAMP/SMT/FS-340-HDS-010-SDS-010-SMS-040/intent.nix"
trace_id="FS-340-HDS-010-SDS-010-SMS-040"

fail() {
  echo "FAIL ${trace_id} row-local-structural: $*" >&2
  exit 1
}

[[ -f "${intent_file}" ]] || fail "missing ${intent_file}"

nix eval --impure --expr "
  let
    intent = import ${intent_file};
    lab = intent.\"mini-smt\".\"${trace_id}\";
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
      \"P2 FAIL: links must preserve access-selector-policy-core chain\"
    && require (builtins.length lab.topology.nodes.\"client-edge\".attachments == 1)
      \"P3 FAIL: client-edge must have 1 attachment\"
    && require (builtins.any (a: a.kind == \"tenant\" && a.name == \"client\") lab.topology.nodes.\"client-edge\".attachments)
      \"P3 FAIL: missing client tenant attachment\"
    && require (lab.topology.nodes.\"downstream-selector\".role == \"downstream-selector\")
      \"P4 FAIL: downstream-selector role mismatch\"
    && require (lab.topology.nodes.\"policy\".role == \"policy\")
      \"P4 FAIL: policy role mismatch\"
    && require (lab.topology.nodes.\"upstream-selector\".role == \"upstream-selector\")
      \"P4 FAIL: upstream-selector role mismatch\"
    && require (lab.topology.nodes.\"core-vlan4-client-dhcp-slaac\" ? uplinks)
      \"P5 FAIL: core-vlan4-client-dhcp-slaac missing uplinks\"
    && require (lab.topology.nodes.\"core-vlan4-client-dhcp-slaac\".uplinks ? testnet)
      \"P5 FAIL: core-vlan4-client-dhcp-slaac missing testnet uplink\"
    && require (builtins.length relations == 1)
      \"P6 FAIL: expected 1 relation, got \${toString (builtins.length relations)}\"
    && require (relations != [ ] && (builtins.head relations).id == \"${trace_id}__mini-verify\")
      \"P6 FAIL: relation ID mismatch or empty relations\"
    && require (builtins.any (r: r.action == \"allow\" && r.from.name == \"client\" && r.to.kind == \"external\" && builtins.elem \"testnet\" r.to.uplinks) relations)
      \"P7 FAIL: client-to-testnet allow relation missing\"
    && require (builtins.length lab.ownership.prefixes == 1)
      \"P8 FAIL: expected 1 ownership prefix\"
    && require (lab.pools ? loopback && lab.pools ? p2p)
      \"P9 FAIL: missing pool definitions\"
    && require (lab.communicationContract ? interfaceTags)
      \"P10 FAIL: missing interfaceTags\"
    && require (builtins.length lab.communicationContract.trafficTypes == 1)
      \"P11 FAIL: expected 1 trafficType\"
" >/dev/null || fail "intent.nix structural validation failed"

echo "PASS ${trace_id} row-local-structural (structural)"
echo ""
echo "Evidence tier: construction/local-build"
echo "11/11 structural predicates PASS"
echo ""
echo "NOTE: This is a structural validation of the row-local intent fixture only."
echo "SMS predicate verification for FS-340-HDS-010-SDS-010-SMS-040 is in the owning repo construction test."
echo "SMS Validation Evidence Boundary: construction-only."
