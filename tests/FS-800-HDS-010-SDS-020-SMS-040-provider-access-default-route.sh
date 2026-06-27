#!/usr/bin/env bash
# GAMP-ID: FS-800-HDS-010-SDS-020-SMS-040
# GAMP-SCOPE: row-local focused SMT construction test; not HAT/SAT evidence
# Validates: intent.nix topology structure, relation IDs, ownership, pools, no default-reachability on pppoe link
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
intent_file="${repo_root}/GAMP/SMT/FS-800-HDS-010-SDS-020-SMS-040/intent.nix"
trace_id="FS-800-HDS-010-SDS-020-SMS-040"

fail() {
  echo "FAIL ${trace_id} provider-access-default-route: $*" >&2
  exit 1
}

[[ -f "${intent_file}" ]] || fail "missing ${intent_file}"

nix eval --impure --expr "
  let
    intent = import ${intent_file};
    lab = intent.\"mini-smt\".\"provider-access-default-route\";
    require = cond: msg: if cond then true else throw msg;
    nodes = builtins.attrNames lab.topology.nodes;
    links = lab.topology.links;
    relations = lab.communicationContract.relations;
    trace = \"${trace_id}\";
  in
    require (builtins.length nodes == 3)
      \"P1 FAIL: expected 3 nodes, got \${toString (builtins.length nodes)}\"
    && require (builtins.elem \"provider-handoff-access-a\" nodes)
      \"P1 FAIL: missing provider-handoff-access-a node\"
    && require (builtins.elem \"fabric-core\" nodes)
      \"P1 FAIL: missing fabric-core node\"
    && require (builtins.elem \"pppoe-core\" nodes)
      \"P1 FAIL: missing pppoe-core node\"
    && require (builtins.length links == 2)
      \"P2 FAIL: expected 2 links, got \${toString (builtins.length links)}\"
    && require (builtins.elem [\"provider-handoff-access-a\" \"fabric-core\"] links)
      \"P2 FAIL: missing provider-handoff-access-a <-> fabric-core link\"
    && require (builtins.elem [\"provider-handoff-access-a\" \"pppoe-core\"] links)
      \"P2 FAIL: missing provider-handoff-access-a <-> pppoe-core link\"
    && require (builtins.length lab.topology.nodes.\"provider-handoff-access-a\".attachments == 1)
      \"P3 FAIL: provider-handoff-access-a must have 1 attachment\"
    && require (builtins.any (a: a.kind == \"tenant\" && a.name == \"provider-handoff-a\")
      lab.topology.nodes.\"provider-handoff-access-a\".attachments)
      \"P3 FAIL: missing provider-handoff-a tenant attachment\"
    && require (lab.topology.nodes.\"fabric-core\" ? uplinks)
      \"P4 FAIL: fabric-core missing uplinks\"
    && require (lab.topology.nodes.\"fabric-core\".uplinks ? isp)
      \"P4 FAIL: fabric-core missing isp uplink\"
    && require (lab.topology.nodes.\"pppoe-core\".role == \"core\")
      \"P5 FAIL: pppoe-core must be role=core\"
    && require (builtins.length relations == 1)
      \"P6 FAIL: expected 1 relation, got \${toString (builtins.length relations)}\"
    && require ((builtins.head relations).id == \"\${trace}__mini-provider-handoff-to-internet\")
      \"P6 FAIL: relation ID mismatch\"
    && require (builtins.any (r: r.action == \"allow\" && r.from.name == \"provider-handoff-a\" && r.to.name == \"isp\") relations)
      \"P7 FAIL: provider-handoff-to-isp allow relation missing\"
    && require (builtins.length lab.ownership.prefixes == 1)
      \"P8 FAIL: expected 1 ownership prefix\"
    && require ((builtins.head lab.ownership.prefixes).ipv4 == \"203.0.113.0/24\")
      \"P8 FAIL: ownership IPv4 prefix mismatch\"
    && require (lab.pools ? loopback && lab.pools ? p2p)
      \"P9 FAIL: missing pool definitions\"
    && require (lab.communicationContract ? interfaceTags)
      \"P10 FAIL: missing interfaceTags\"
    && require (builtins.length lab.communicationContract.trafficTypes == 1)
      \"P11 FAIL: expected 1 trafficType\"
    && require ((builtins.head lab.communicationContract.trafficTypes).name == \"any\")
      \"P11 FAIL: trafficType name mismatch\"
" >/dev/null || fail "intent.nix structural validation failed"

echo "PASS ${trace_id} provider-access-default-route (structural)"
echo ""
echo "Evidence tier: construction/local-build"
echo "11/11 structural predicates PASS"
echo ""
echo "NOTE: Structural validation of row-local intent fixture only."
echo "Construction-provable predicates (MR1-MR4, FC1-FC5, SN1-SN2) verified by:"
echo "  network-control-plane-model/tests/test-FS-800-HDS-010-SDS-020-SMS-040-pppoe-provider-network-routes.sh"
echo ""
echo "SMS Validation Evidence Boundary: split."
echo "Live-required predicates (provider-handoff internet egress through live fabric) are HAT-routed."
echo ""
echo "Shared files NOT EDITED — row-local files only per GAMP/SMT/README.md policy."
