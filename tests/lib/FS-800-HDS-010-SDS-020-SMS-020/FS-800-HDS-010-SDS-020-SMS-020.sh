#!/usr/bin/env bash
# GAMP-ID: FS-800-HDS-010-SDS-020-SMS-020
# GAMP-SCOPE: row-local focused SMT construction test; not HAT/SAT evidence
# Validates: 9-node combined PPPoE fabric — provider + customer chains sharing policy
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
intent_file="${repo_root}/GAMP/SMT/FS-800-HDS-010-SDS-020-SMS-020/intent.nix"
trace_id="FS-800-HDS-010-SDS-020-SMS-020"

fail() { echo "FAIL ${trace_id} row-local-structural: $*" >&2; exit 1; }
[[ -f "${intent_file}" ]] || fail "missing ${intent_file}"

nix eval --impure --expr "
  let
    intent = import ${intent_file};
    lab = intent.\"mini-smt\".\"${trace_id}\";
    require = cond: msg: if cond then true else throw msg;
    nodes = builtins.attrNames lab.topology.nodes;
    links = lab.topology.links;
    relations = lab.communicationContract.relations;
    expected = [
      \"access-PPPoE-Server\" \"client-edge\"
      \"core-fake-isp\" \"core-vlan4-client-dhcp-slaac\"
      \"downstream-selector-customer\" \"downstream-selector-provider\"
      \"policy\"
      \"upstream-selector-customer\" \"upstream-selector-provider\"
    ];
  in
    require (builtins.length nodes == 9)
      \"P1 FAIL: expected 9 nodes, got \${toString (builtins.length nodes)}\"
    && require (builtins.sort builtins.lessThan nodes == builtins.sort builtins.lessThan expected)
      \"P1 FAIL: node set mismatch\"
    && require (builtins.length links == 9)
      \"P2 FAIL: expected 9 links, got \${toString (builtins.length links)}\"
    && require (builtins.elem [ \"access-PPPoE-Server\" \"core-fake-isp\" ] links)
      \"P2 FAIL: missing PPPoE handoff link access-PPPoE-Server <-> core-fake-isp\"
    && require (lab.topology.nodes.\"access-PPPoE-Server\".role == \"access\")
      \"P3 FAIL: access-PPPoE-Server role\"
    && require (lab.topology.nodes.\"client-edge\".role == \"access\")
      \"P3 FAIL: client-edge role\"
    && require (lab.topology.nodes.\"policy\".role == \"policy\")
      \"P4 FAIL: policy role\"
    && require (lab.topology.nodes.\"core-fake-isp\".role == \"core\")
      \"P5 FAIL: core-fake-isp role\"
    && require (lab.topology.nodes.\"core-fake-isp\".uplinks.\"fake-isp\".ipv4 == [ \"203.0.113.1/32\" ])
      \"P6 FAIL: core-fake-isp TEST-NET-3 ipv4\"
    && require (lab.topology.nodes.\"core-fake-isp\".uplinks.\"fake-isp\".ipv6 == [ \"2001:db8:113::1/128\" ])
      \"P6 FAIL: core-fake-isp doc ipv6\"
    && require (lab.topology.nodes.\"core-vlan4-client-dhcp-slaac\".uplinks ? \"internet-vlan4\")
      \"P7 FAIL: core-vlan4 missing internet-vlan4 uplink\"
    && require (builtins.length relations == 2)
      \"P8 FAIL: expected 2 relations, got \${toString (builtins.length relations)}\"
    && require (builtins.any (r: builtins.elem \"fake-isp\" r.to.uplinks) relations)
      \"P8 FAIL: missing fake-isp relation\"
    && require (builtins.any (r: builtins.elem \"internet-vlan4\" r.to.uplinks) relations)
      \"P8 FAIL: missing internet-vlan4 relation\"
    && require (builtins.length lab.ownership.prefixes == 1)
      \"P9 FAIL: expected 1 ownership prefix\"
    && require (lab.pools ? loopback && lab.pools ? p2p)
      \"P10 FAIL: missing pools\"
" >/dev/null || fail "intent.nix structural validation failed"

echo "PASS ${trace_id} row-local-structural (structural)"
echo ""
echo "Evidence tier: construction/local-build"
echo "10/10 structural predicates PASS"
echo "Topology: 9 nodes, 9 links — 9-node combined PPPoE fabric with shared policy"
echo "PPPoE handoff: access-PPPoE-Server <-> core-fake-isp"
