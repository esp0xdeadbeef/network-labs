# FS-030-HDS-010-SDS-020-SMS-010 SMS Template

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-020-SMS-010-stage-topology-enforcement.md`

Template row for Stage Topology Enforcement.

**Evidence Boundary:** active-lab mini-SMT runtime plus compiler construction
evidence.

This row provides the row-local mini-SMT source for the canonical
`client-edge -> downstream-selector -> policy -> upstream-selector -> testnet-edge`
path. It mirrors the canonical `network-codex-agent` SMS so lab-source coverage
cannot silently omit the stage-topology enforcement trace.

The authoritative construction test lives in `network-compiler`:
`tests/test-FS-030-HDS-010-SDS-020-SMS-010.sh`.

The current live evidence is recorded in the SMT/SIT rows after the
row-specific `network-codex-agent` live wrapper and
`tests/run-active-lab-mini-smt.sh FS-030-HDS-010-SDS-020-SMS-010` pass against
the locked active-lab hosts.

Title slug: `stage-topology-enforcement`
