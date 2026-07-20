#!/usr/bin/env bash
# GAMP-ID: FS-320-HDS-010-SDS-010-SMS-010
# GAMP-SCOPE: row-local focused SMT construction test; not HAT/SAT evidence
# Validates: intent.nix topology structure, relation IDs, role co-location
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
intent_file="${repo_root}/GAMP/SMT/FS-320-HDS-010-SDS-010-SMS-010/intent.nix"
trace_id="FS-320-HDS-010-SDS-010-SMS-010"

fail() {
  echo "FAIL FS-320-HDS-010-SDS-010-SMS-010 layout-preservation: $*" >&2
  exit 1
}

[[ -f "${intent_file}" ]] || fail "missing ${intent_file}"

# Structural validation via nix eval
nix eval --impure --expr "
  let
    intent = import ${intent_file};
    lab = intent.\"mini-smt\".\"renderer-layout-preservation\";
    require = cond: msg: if cond then true else throw msg;
    traceId = \"${trace_id}\";

    # Topology checks
    nodes = builtins.attrNames lab.topology.nodes;
    links = lab.topology.links;
    relations = lab.communicationContract.relations;

    # Expected relation IDs
    expectedIds = [
      \"${trace_id}__mini-client-to-testnet-allow\"
      \"${trace_id}__mini-mgmt-deny-internet\"
    ];
  in
    # P1: Two nodes defined
    require (builtins.length nodes == 2)
      \"P1 FAIL: expected 2 nodes, got \${toString (builtins.length nodes)}\"
    && require (builtins.elem \"access-cohost\" nodes)
      \"P1 FAIL: missing access-cohost node\"
    && require (builtins.elem \"core-exit\" nodes)
      \"P1 FAIL: missing core-exit node\"

    # P2: One link between nodes
    && require (builtins.length links == 1)
      \"P2 FAIL: expected 1 link, got \${toString (builtins.length links)}\"
    && require (builtins.head links == [ \"access-cohost\" \"core-exit\" ])
      \"P2 FAIL: link must be access-cohost <-> core-exit\"

    # P3: Role co-location — access-cohost has two tenant attachments
    && require (builtins.length lab.topology.nodes.\"access-cohost\".attachments == 2)
      \"P3 FAIL: access-cohost must have 2 attachments for role co-location, got \${toString (builtins.length lab.topology.nodes.\"access-cohost\".attachments)}\"
    && require (builtins.any (a: a.kind == \"tenant\" && a.name == \"client\") lab.topology.nodes.\"access-cohost\".attachments)
      \"P3 FAIL: missing client tenant attachment on access-cohost\"
    && require (builtins.any (a: a.kind == \"tenant\" && a.name == \"mgmt\") lab.topology.nodes.\"access-cohost\".attachments)
      \"P3 FAIL: missing mgmt tenant attachment on access-cohost\"

    # P4: Core-exit has uplink
    && require (lab.topology.nodes.\"core-exit\" ? uplinks)
      \"P4 FAIL: core-exit missing uplinks\"

    # P5: Two communication relations with correct IDs
    && require (builtins.length relations == 2)
      \"P5 FAIL: expected 2 relations, got \${toString (builtins.length relations)}\"
    && require (builtins.all (r: builtins.elem r.id expectedIds) relations)
      \"P5 FAIL: relation IDs must match expected IDs\"

    # P6: Client→testnet allow relation
    && require (builtins.any (r: r.id == \"${trace_id}__mini-client-to-testnet-allow\" && r.action == \"allow\" && r.from.kind == \"tenant\" && r.from.name == \"client\" && r.to.kind == \"external\" && r.to.name == \"testnet\") relations)
      \"P6 FAIL: client→testnet allow relation missing or malformed\"

    # P7: Mgmt→testnet deny relation (seeded negative: distinct deny policy)
    && require (builtins.any (r: r.id == \"${trace_id}__mini-mgmt-deny-internet\" && r.action == \"deny\" && r.from.kind == \"tenant\" && r.from.name == \"mgmt\" && r.to.kind == \"external\" && r.to.name == \"testnet\") relations)
      \"P7 FAIL: mgmt→testnet deny relation missing or malformed\"

    # P8: Role identity preserved — client allow ≠ mgmt deny (policy boundary)
    && require (builtins.any (r: r.action == \"allow\") relations)
      \"P8 FAIL: no allow relation present\"
    && require (builtins.any (r: r.action == \"deny\") relations)
      \"P8 FAIL: no deny relation present\"

    # P9: Ownership prefixes for both tenants
    && require (builtins.length lab.ownership.prefixes == 2)
      \"P9 FAIL: expected 2 ownership prefixes, got \${toString (builtins.length lab.ownership.prefixes)}\"

    # P10: Pool definitions present
    && require (lab.pools ? loopback && lab.pools ? p2p)
      \"P10 FAIL: missing loopback or p2p pool definitions\"
" >/dev/null || fail "intent.nix structural validation failed"

echo "PASS FS-320-HDS-010-SDS-010-SMS-010 layout-preservation (structural)"
echo ""
echo "Evidence tier: construction/local-build"
echo "10/10 structural predicates PASS"
echo ""
echo "NOTE: This is structural validation of the row-local intent fixture only."
echo "Behavioral proof (renderer output with role identity preservation, target"
echo "limitation diagnostics, seed negative exercise) requires RaTM work:"
echo "validators in mini-smt/default.nix and full compiler→NFM→CPM→renderer pipeline."
echo "per FS-320-HDS-010-SDS-010-SMS-010 Construction Handoff items 1-3."
