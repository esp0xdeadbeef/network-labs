#!/usr/bin/env bash
# GAMP-ID: FS-800-HDS-010-SDS-020-SMS-020
# GAMP-SCOPE: row-local focused SMT construction test; not HAT/SAT evidence
# Validates: row-local intent.nix topology — core-fake-isp customer-side fabric
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
intent_file="${repo_root}/GAMP/SMT/FS-800-HDS-010-SDS-020-SMS-020/intent.nix"
trace_id="FS-800-HDS-010-SDS-020-SMS-020"

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
    core = lab.topology.nodes.\"core-fake-isp\";
  in
    require (builtins.length nodes == 5)
      \"P1 FAIL: expected 5 nodes, got \${toString (builtins.length nodes)}\"
    && require (builtins.elem \"client-edge\" nodes)
      \"P1 FAIL: missing client-edge\"
    && require (builtins.elem \"downstream-selector\" nodes)
      \"P1 FAIL: missing downstream-selector\"
    && require (builtins.elem \"policy\" nodes)
      \"P1 FAIL: missing policy\"
    && require (builtins.elem \"upstream-selector\" nodes)
      \"P1 FAIL: missing upstream-selector\"
    && require (builtins.elem \"core-fake-isp\" nodes)
      \"P1 FAIL: missing core-fake-isp\"
    && require (lab.topology.nodes.\"client-edge\".role == \"access\")
      \"P2 FAIL: client-edge role must be access\"
    && require (core.role == \"core\")
      \"P3 FAIL: core-fake-isp role must be core\"
    && require (core ? uplinks && core.uplinks ? \"fake-isp\")
      \"P4 FAIL: core-fake-isp missing fake-isp uplink\"
    && require (core.uplinks.\"fake-isp\".ipv4 == [ \"203.0.113.1/32\" ])
      \"P4 FAIL: fake-isp ipv4 must be 203.0.113.1/32 (TEST-NET-3)\"
    && require (core.uplinks.\"fake-isp\".ipv6 == [ \"2001:db8:113::1/128\" ])
      \"P4 FAIL: fake-isp ipv6 must be 2001:db8:113::1/128\"
    && require (core.external == \"fake-isp\")
      \"P4 FAIL: core-fake-isp external must be fake-isp\"
    && require (builtins.length links == 4)
      \"P5 FAIL: expected 4 links, got \${toString (builtins.length links)}\"
    && require (builtins.elem [ \"client-edge\" \"downstream-selector\" ] links)
      \"P5 FAIL: missing client-edge <-> downstream-selector link\"
    && require (builtins.elem [ \"upstream-selector\" \"core-fake-isp\" ] links)
      \"P5 FAIL: missing upstream-selector <-> core-fake-isp link\"
    && require (builtins.length relations == 1)
      \"P6 FAIL: expected 1 relation\"
    && require ((builtins.head relations).id == \"${trace_id}__mini-verify\")
      \"P6 FAIL: relation ID mismatch\"
    && require (builtins.any (r: r.action == \"allow\" && r.from.name == \"client\" && builtins.elem \"fake-isp\" r.to.uplinks) relations)
      \"P6 FAIL: client-to-fake-isp allow relation missing\"
    && require (builtins.length lab.ownership.prefixes == 1)
      \"P7 FAIL: expected 1 ownership prefix\"
    && require (lab.pools ? loopback && lab.pools ? p2p)
      \"P8 FAIL: missing pool definitions\"
    && require (lab.communicationContract ? interfaceTags)
      \"P10 FAIL: missing interfaceTags\"
    && require (builtins.length lab.communicationContract.trafficTypes == 1)
      \"P11 FAIL: expected 1 trafficType\"
" >/dev/null || fail "intent.nix structural validation failed"

echo "PASS ${trace_id} row-local-structural (structural)"
echo ""
echo "Evidence tier: construction/local-build"
echo "11/11 structural predicates PASS"
echo "Topology: client-edge -> downstream-selector -> policy -> upstream-selector -> core-fake-isp"
echo "core-fake-isp uplinks: 203.0.113.1/32 + 2001:db8:113::1/128 (TEST-NET-3)"
echo ""
echo "NOTE: This is a structural validation of the row-local intent fixture only."
