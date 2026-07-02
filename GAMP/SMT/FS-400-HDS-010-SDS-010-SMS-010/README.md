# SMT Construction Row: FS-400-HDS-010-SDS-010-SMS-010

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-400-HDS-010-SDS-010-SMS-010-ipv6-internet-mode-selection.md`

Status: OK - construction-only.

This row has no live runtime target. `GAMP/SMT/mini-smt/tests.nix` dispatches
the construction-only verifier in `network-codex-agent`, which aggregates the
mode-specific CPM construction proofs for ULA NAT66, routed client GUA, and
overlay client GUA. Live runtime rows stay on the mode-specific child SMS rows.

Title slug: `ipv6-internet-mode-selection`
