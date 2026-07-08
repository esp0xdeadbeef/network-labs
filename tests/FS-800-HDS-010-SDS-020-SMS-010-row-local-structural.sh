#!/usr/bin/env bash
# GAMP-ID: FS-800-HDS-010-SDS-020-SMS-010
# GAMP-SCOPE: row-local focused SMT construction test; not HAT/SAT evidence
# Validates: row-local intent.nix topology — access-PPPoE-Server provider-side fabric
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
intent_file="${repo_root}/GAMP/SMT/FS-800-HDS-010-SDS-020-SMS-010/intent.nix"
trace_id="FS-800-HDS-010-SDS-020-SMS-010"

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
    && require (builtins.elem \"access-PPPoE-Server\" nodes)
      \"P1 FAIL: missing access-PPPoE-Server node\"
    && require (lab.topology.nodes.\"access-PPPoE-Server\".role == \"access\")
      \"P2 FAIL: access-PPPoE-Server role must be access\"
    && require (builtins.elem \"downstream-selector\" nodes)
      \"P1 FAIL: missing downstream-selector\"
    && require (builtins.elem \"policy\" nodes)
      \"P1 FAIL: missing policy\"
    && require (builtins.elem \"upstream-selector\" nodes)
      \"P1 FAIL: missing upstream-selector\"
    && require (builtins.elem \"core-vlan4-client-dhcp-slaac\" nodes)
      \"P1 FAIL: missing core-vlan4-client-dhcp-slaac\"
    && require (lab.topology.nodes.\"core-vlan4-client-dhcp-slaac\".role == \"core\")
      \"P3 FAIL: core role mismatch\"
    && require (lab.topology.nodes.\"core-vlan4-client-dhcp-slaac\" ? uplinks)
      \"P4 FAIL: core missing uplinks\"
    && require (lab.topology.nodes.\"core-vlan4-client-dhcp-slaac\".uplinks ? \"internet-vlan4\")
      \"P4 FAIL: core missing internet-vlan4 uplink\"
    && require (builtins.length links == 4)
      \"P5 FAIL: expected 4 links, got \${toString (builtins.length links)}\"
    && require (builtins.elem [ \"access-PPPoE-Server\" \"downstream-selector\" ] links)
      \"P5 FAIL: missing access-PPPoE-Server <-> downstream-selector link\"
    && require (builtins.elem [ \"upstream-selector\" \"core-vlan4-client-dhcp-slaac\" ] links)
      \"P5 FAIL: missing upstream-selector <-> core link\"
    && require (builtins.length relations == 1)
      \"P6 FAIL: expected 1 relation\"
    && require ((builtins.head relations).id == \"${trace_id}__mini-verify\")
      \"P6 FAIL: relation ID mismatch\"
    && require (builtins.length lab.ownership.prefixes == 1)
      \"P7 FAIL: expected 1 ownership prefix\"
    && require (lab.pools ? loopback && lab.pools ? p2p)
      \"P8 FAIL: missing pool definitions\"
    && require (lab.communicationContract ? interfaceTags)
      \"P9 FAIL: missing interfaceTags\"
    && require (builtins.length lab.communicationContract.trafficTypes == 1)
      \"P10 FAIL: expected 1 trafficType\"
" >/dev/null || fail "intent.nix structural validation failed"

echo "PASS ${trace_id} row-local-structural (structural)"
echo ""
echo "Evidence tier: construction/local-build"
echo "10/10 structural predicates PASS"
echo "Topology: access-PPPoE-Server -> downstream-selector -> policy -> upstream-selector -> core-vlan4-client-dhcp-slaac"
echo ""
echo "NOTE: This is a structural validation of the row-local intent fixture only."
