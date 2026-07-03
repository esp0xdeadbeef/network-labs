# FS-030-HDS-010-SDS-020-SMS-010 SMT

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-020-SMS-010-stage-topology-enforcement.md`

Status: OK - row-local mini-SMT source with compiler construction evidence.

This row provides a small intent-source fixture that exercises the compiler
stage-topology boundary and active-lab artifact path for the canonical
access -> downstream-selector -> policy -> upstream-selector -> core flow.

The authoritative construction test lives in `network-compiler`:
`tests/test-FS-030-HDS-010-SDS-020-SMS-010.sh`

Run:

```bash
tests/run-active-lab-mini-smt.sh --source FS-030-HDS-010-SDS-020-SMS-010
```

This row may start at most 5 runtime targets.
