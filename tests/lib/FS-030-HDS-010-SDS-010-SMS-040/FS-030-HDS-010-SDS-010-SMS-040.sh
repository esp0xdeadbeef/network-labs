#!/usr/bin/env bash
# GAMP-ID: FS-030-HDS-010-SDS-010-SMS-040
# GAMP-SCOPE: row-local focused SMT construction test; not HAT/SAT evidence
# Validates: intent.nix topology structure, SMS predicate coverage verification
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
intent_file="${repo_root}/GAMP/SMT/FS-030-HDS-010-SDS-010-SMS-040/intent.nix"
trace_id="FS-030-HDS-010-SDS-010-SMS-040"

fail() {
  echo "FAIL ${trace_id} cpm-binder-source-audit: $*" >&2
  exit 1
}

[[ -f "${intent_file}" ]] || fail "missing ${intent_file}"

# Structural validation via nix eval
nix eval --impure --expr "
  let
    intent = import ${intent_file};
    lab = intent.\"mini-smt\".\"${trace_id}\";
    require = cond: msg: if cond then true else throw msg;
    traceId = \"${trace_id}\";

    nodes = builtins.attrNames lab.topology.nodes;
    links = lab.topology.links;
    relations = lab.communicationContract.relations;

    expectedIds = [
      \"${trace_id}__mini-verify\"
    ];
  in
    # P1: Two nodes defined
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

    # P3: Client-edge has one tenant attachment
    && require (builtins.length lab.topology.nodes.\"client-edge\".attachments == 1)
      \"P3 FAIL: client-edge must have 1 attachment, got \${toString (builtins.length lab.topology.nodes.\"client-edge\".attachments)}\"
    && require (builtins.any (a: a.kind == \"tenant\" && a.name == \"client\") lab.topology.nodes.\"client-edge\".attachments)
      \"P3 FAIL: missing client tenant attachment on client-edge\"

    # P4: Testnet-edge has uplink
    && require (lab.topology.nodes.\"core-vlan4-client-dhcp-slaac\" ? uplinks)
      \"P4 FAIL: core-vlan4-client-dhcp-slaac missing uplinks\"

    # P5: One communication relation with correct ID
    && require (builtins.length relations == 1)
      \"P5 FAIL: expected 1 relation, got \${toString (builtins.length relations)}\"
    && require (builtins.all (r: builtins.elem r.id expectedIds) relations)
      \"P5 FAIL: relation IDs must match expected IDs\"

    # P6: Client→testnet allow relation with correct fields
    && require (builtins.any (r: r.id == \"${trace_id}__mini-verify\" && r.action == \"allow\" && r.from.kind == \"tenant\" && r.from.name == \"client\" && r.to.kind == \"external\" && !(r.to ? name) && !(r.to ? uplinks)) relations)
      \"P6 FAIL: client→testnet allow relation missing or malformed\"

    # P7: Ownership prefix for client tenant
    && require (builtins.length lab.ownership.prefixes == 1)
      \"P7 FAIL: expected 1 ownership prefix, got \${toString (builtins.length lab.ownership.prefixes)}\"

    # P8: Pool definitions present
    && require (lab.pools ? loopback && lab.pools ? p2p)
      \"P8 FAIL: missing loopback or p2p pool definitions\"

    # P9: Client-edge role is access
    && require (lab.topology.nodes.\"client-edge\".role == \"access\")
      \"P9 FAIL: client-edge role must be access\"

    # P10: Testnet-edge role is core
    && require (lab.topology.nodes.\"core-vlan4-client-dhcp-slaac\".role == \"core\")
      \"P10 FAIL: core-vlan4-client-dhcp-slaac role must be core\"
" >/dev/null || fail "intent.nix structural validation failed"

echo "PASS ${trace_id} cpm-binder-source-audit (structural)"
echo ""
echo "Evidence tier: construction/local-build"
echo "10/10 structural predicates PASS"
echo ""
echo "NOTE: This is structural validation of the row-local intent fixture only."
echo "The authoritative construction test for CPM binder source audit predicates"
echo "(MR, FC, SN1, SN2) lives in network-control-plane-model:"
echo "tests/test-cpm-realization-binder-source-audit.sh"
echo ""
echo "SMS: GAMP/SMS/FS-030-HDS-010-SDS-010-SMS-040-cpm-binder-source-audit.md"
echo "SMS predicates: bind source-class audit + upstream behavior ref on every"
echo "CPM realization-binding field; fail closed on missing/cross-stage audit records"

bash "${repo_root}/tests/lib/FS-030-HDS-010-SDS-010-SMS-040-structure.sh"
