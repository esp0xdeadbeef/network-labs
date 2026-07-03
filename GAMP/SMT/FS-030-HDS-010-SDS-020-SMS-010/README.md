# FS-030-HDS-010-SDS-020-SMS-010 SMT

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-020-SMS-010-stage-topology-enforcement.md`

Status: Source OK - row-local mini-SMT fixture is selectable and renderable.
Overall SMT status remains governed by
`network-codex-agent/GAMP/SMT/README.md`; at the time of this source update
`FS-030-HDS-010-SDS-020-SMS-010` remains `NOT OK` because the owning compiler
construction test still records pairwise-adjacent multi-hop policy-bypass known
gaps (`core -> upstream -> core` and `access -> downstream -> access`).

This row provides a small intent-source fixture that exercises the compiler
stage-topology boundary and active-lab artifact path for the canonical
access -> downstream-selector -> policy -> upstream-selector -> core flow.
It is runtime fixture evidence for the valid canonical path; it is not proof
that all non-canonical graph shapes are rejected.

The authoritative construction test lives in `network-compiler`:
`tests/test-FS-030-HDS-010-SDS-020-SMS-010.sh`

Run:

```bash
tests/run-active-lab-mini-smt.sh --source FS-030-HDS-010-SDS-020-SMS-010
```

This row may start at most 5 runtime targets.
