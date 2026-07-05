#!/usr/bin/env bash
# GAMP-ID: FS-670-HDS-010-SDS-010-SMS-040
# GAMP-SCOPE: row-local focused SMT construction test; not HAT/SAT evidence
# Validates: row-local intent.nix topology structure, relation IDs, ownership, pools
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
intent_file="${repo_root}/GAMP/SMT/FS-670-HDS-010-SDS-010-SMS-040/intent.nix"
trace_id="FS-670-HDS-010-SDS-010-SMS-040"

fail() {
  echo "FAIL ${trace_id} row-local-structural: $*" >&2
  exit 1
}

[[ -f "${intent_file}" ]] || fail "missing ${intent_file}"

nix eval --impure --expr "
  let
    intent = import ${intent_file};
    lab = intent.\"mini-smt\".\"fs_670_hds_010_sds_010_sms_040\";
    require = cond: msg: if cond then true else throw msg;
    nodes = builtins.attrNames lab.topology.nodes;
    links = lab.topology.links;
    relations = lab.communicationContract.relations;
  in
    require (builtins.length nodes == 2)
      \"P1 FAIL: expected 2 nodes, got \${toString (builtins.length nodes)}\"
    && require (builtins.elem \"client-edge\" nodes)
      \"P1 FAIL: missing client-edge node\"
    && require (builtins.elem \"vlan4-client-dhcp-slaac\" nodes)
      \"P1 FAIL: missing vlan4-client-dhcp-slaac node\"
    && require (builtins.length links == 1)
      \"P2 FAIL: expected 1 link, got \${toString (builtins.length links)}\"
    && require (builtins.head links == [ \"client-edge\" \"vlan4-client-dhcp-slaac\" ])
      \"P2 FAIL: link must be client-edge <-> vlan4-client-dhcp-slaac\"
    && require (builtins.length lab.topology.nodes.\"client-edge\".attachments == 1)
      \"P3 FAIL: client-edge must have 1 attachment\"
    && require (builtins.any (a: a.kind == \"tenant\" && a.name == \"client\") lab.topology.nodes.\"client-edge\".attachments)
      \"P3 FAIL: missing client tenant attachment\"
    && require (lab.topology.nodes.\"vlan4-client-dhcp-slaac\" ? uplinks)
      \"P4 FAIL: vlan4-client-dhcp-slaac missing uplinks\"
    && require (lab.topology.nodes.\"vlan4-client-dhcp-slaac\".uplinks ? testnet)
      \"P4 FAIL: vlan4-client-dhcp-slaac missing testnet uplink\"
    && require (builtins.length relations == 1)
      \"P5 FAIL: expected 1 relation, got \${toString (builtins.length relations)}\"
    && require (relations != [ ] && (builtins.head relations).id == \"${trace_id}__mini-client-to-testnet\")
      \"P5 FAIL: relation ID mismatch or empty relations\"
    && require (builtins.any (r: r.action == \"allow\" && r.from.name == \"client\" && r.to.name == \"testnet\") relations)
      \"P6 FAIL: client-to-testnet allow relation missing\"
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
echo ""
echo "NOTE: This is a structural validation of the row-local intent fixture only."
echo "SMS predicate verification for FS-670-HDS-010-SDS-010-SMS-040 is in the owning repo construction test."
echo "SMS Validation Evidence Boundary: construction-only."
