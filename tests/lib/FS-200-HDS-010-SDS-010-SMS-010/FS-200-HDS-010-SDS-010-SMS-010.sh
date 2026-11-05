#!/usr/bin/env bash
# GAMP-ID: FS-200-HDS-010-SDS-010-SMS-010
# GAMP-SCOPE: row-local focused SMT construction test; not HAT/SAT evidence
# Validates: intent.nix topology structure, relation IDs, ownership, pools
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
intent_file="${repo_root}/GAMP/SMT/FS-200-HDS-010-SDS-010-SMS-010/intent.nix"
trace_id="FS-200-HDS-010-SDS-010-SMS-010"

fail() {
  echo "FAIL ${trace_id} shared-service-exposure-boundary: $*" >&2
  exit 1
}

[[ -f "${intent_file}" ]] || fail "missing ${intent_file}"

nix eval --impure --expr "
  let
    intent = import ${intent_file};
    lab = intent.\"mini-smt\".\"shared-service-exposure-boundary\";
    require = cond: msg: if cond then true else throw msg;
    nodes = builtins.attrNames lab.topology.nodes;
    links = lab.topology.links;
    relations = lab.communicationContract.relations;
  in
    require (builtins.all (r: builtins.elem r [ \"access\" \"downstream-selector\" \"policy\" \"upstream-selector\" \"core\" ]) (map (n: lab.topology.nodes.\${n}.role or \"\") nodes))
      \"P1 FAIL: fixture must use only canonical fabric roles (access/downstream-selector/policy/upstream-selector/core)\"
    && require (builtins.elem \"client-edge\" nodes)
      \"P1 FAIL: missing client-edge node\"
    && require (builtins.elem \"core-vlan4-client-dhcp-slaac\" nodes)
      \"P1 FAIL: missing core-vlan4-client-dhcp-slaac node\"
    && require (builtins.elem \"access\" (map (n: lab.topology.nodes.\${n}.role or \"\") nodes) && builtins.elem \"core\" (map (n: lab.topology.nodes.\${n}.role or \"\") nodes))
      \"P1 FAIL: fixture must model an access and a core role\"
    && require ((builtins.filter (r: builtins.elem r (map (n: lab.topology.nodes.\${n}.role or \"\") nodes)) [ \"downstream-selector\" \"policy\" \"upstream-selector\" ]) == [ ] || builtins.length (builtins.filter (r: builtins.elem r (map (n: lab.topology.nodes.\${n}.role or \"\") nodes)) [ \"downstream-selector\" \"policy\" \"upstream-selector\" ]) == 3)
      \"P1 FAIL: the fabric selectors must be modelled as the complete access -> downstream-selector -> policy -> upstream-selector -> core chain or not at all\"
    && require (builtins.all (l: builtins.isList l && builtins.length l == 2) links)
      \"P2 FAIL: every fabric link must be a node pair\"
    && require (!(builtins.any (l: builtins.elem \"client-edge\" l && builtins.elem \"core-vlan4-client-dhcp-slaac\" l) links))
      \"P2 FAIL: client-edge must not link directly to core-vlan4-client-dhcp-slaac; fabric traffic crosses access -> downstream-selector -> policy -> upstream-selector -> core\"
    && require (builtins.length lab.topology.nodes.\"client-edge\".attachments == 1)
      \"P3 FAIL: client-edge must have 1 attachment\"
    && require (builtins.any (a: a.kind == \"tenant\" && a.name == \"client\") lab.topology.nodes.\"client-edge\".attachments)
      \"P3 FAIL: missing client tenant attachment\"
    && require (builtins.length (builtins.attrValues (lab.topology.nodes.\"core-vlan4-client-dhcp-slaac\".uplinks or { })) == 1)
      \"P4 FAIL: core-vlan4-client-dhcp-slaac must model exactly one exit uplink\"
    && require (builtins.any (u: builtins.elem \"0.0.0.0/0\" (u.ipv4 or [ ])) (builtins.attrValues (lab.topology.nodes.\"core-vlan4-client-dhcp-slaac\".uplinks or { })))
      \"P4 FAIL: the core-vlan4-client-dhcp-slaac exit uplink must offer a default route; an uplink named testnet is not required by the contract\"
    && require (builtins.length relations == 1)
      \"P5 FAIL: expected 1 relation, got \${toString (builtins.length relations)}\"
    && require (relations != [ ] && (builtins.head relations).id == \"${trace_id}__mini-client-to-testnet\")
      \"P5 FAIL: relation ID mismatch or empty relations\"
    && require (builtins.any (r: r.action == \"allow\" && r.from.name == \"client\" && r.to.kind == \"external\" && !(r.to ? name) && !(r.to ? uplinks)) relations)
      \"P6 FAIL: client-to-external allow relation missing\"
    && require (builtins.length lab.ownership.prefixes == 1)
      \"P7 FAIL: expected 1 ownership prefix\"
    && require (lab.pools ? loopback && lab.pools ? p2p)
      \"P8 FAIL: missing pool definitions\"
    && require (lab.communicationContract ? interfaceTags)
      \"P9 FAIL: missing interfaceTags\"
    && require (builtins.length lab.communicationContract.trafficTypes == 1)
      \"P10 FAIL: expected 1 trafficType\"
" >/dev/null || fail "intent.nix structural validation failed"

echo "PASS ${trace_id} shared-service-exposure-boundary (structural)"
echo ""
echo "Evidence tier: construction/local-build"
echo "10/10 structural predicates PASS"
echo ""
echo "NOTE: Structural validation of row-local intent fixture only."
echo "Shared-service exposure boundary predicates verified by:"
echo "  network-compiler/tests/FS-200-HDS-010-SDS-010-SMS-010.sh"
echo "  network-labs/tests/test-fs200-shared-service-source-matrix.sh"
echo ""
echo "SMS Validation Evidence Boundary: construction-only."
