#!/usr/bin/env bash
# GAMP-ID: FS-030-HDS-010-SDS-010-SMS-040
# GAMP-SCOPE: row-local focused SMT construction test; not HAT/SAT evidence
# Validates: intent.nix topology structure, SMS predicate coverage verification
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
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
    lab = intent.\"mini-smt\".\"fs_030_hds_010_sds_010_sms_040\";
    require = cond: msg: if cond then true else throw msg;
    traceId = \"${trace_id}\";

    nodes = builtins.attrNames lab.topology.nodes;
    links = lab.topology.links;
    relations = lab.communicationContract.relations;

    expectedIds = [
      \"${trace_id}__mini-client-to-testnet\"
    ];
  in
    # P1: Two nodes defined
    require (builtins.length nodes == 2)
      \"P1 FAIL: expected 2 nodes, got \${toString (builtins.length nodes)}\"
    && require (builtins.elem \"client-edge\" nodes)
      \"P1 FAIL: missing client-edge node\"
    && require (builtins.elem \"testnet-edge\" nodes)
      \"P1 FAIL: missing testnet-edge node\"

    # P2: One link between nodes
    && require (builtins.length links == 1)
      \"P2 FAIL: expected 1 link, got \${toString (builtins.length links)}\"
    && require (builtins.head links == [ \"client-edge\" \"testnet-edge\" ])
      \"P2 FAIL: link must be client-edge <-> testnet-edge\"

    # P3: Client-edge has one tenant attachment
    && require (builtins.length lab.topology.nodes.\"client-edge\".attachments == 1)
      \"P3 FAIL: client-edge must have 1 attachment, got \${toString (builtins.length lab.topology.nodes.\"client-edge\".attachments)}\"
    && require (builtins.any (a: a.kind == \"tenant\" && a.name == \"client\") lab.topology.nodes.\"client-edge\".attachments)
      \"P3 FAIL: missing client tenant attachment on client-edge\"

    # P4: Testnet-edge has uplink
    && require (lab.topology.nodes.\"testnet-edge\" ? uplinks)
      \"P4 FAIL: testnet-edge missing uplinks\"

    # P5: One communication relation with correct ID
    && require (builtins.length relations == 1)
      \"P5 FAIL: expected 1 relation, got \${toString (builtins.length relations)}\"
    && require (builtins.all (r: builtins.elem r.id expectedIds) relations)
      \"P5 FAIL: relation IDs must match expected IDs\"

    # P6: Client→testnet allow relation with correct fields
    && require (builtins.any (r: r.id == \"${trace_id}__mini-client-to-testnet\" && r.action == \"allow\" && r.from.kind == \"tenant\" && r.from.name == \"client\" && r.to.kind == \"external\" && r.to.name == \"testnet\") relations)
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
    && require (lab.topology.nodes.\"testnet-edge\".role == \"core\")
      \"P10 FAIL: testnet-edge role must be core\"
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
