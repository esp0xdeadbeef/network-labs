# FS-030-HDS-010-SDS-010-SMS-020 SMT

Row-local source for the mini CPM realization binder authority boundary SMT.

The authoritative construction test lives in `network-control-plane-model`:
`tests/FS-030-HDS-010-SDS-010-SMS-020-cpm-realization-binder-source-audit.sh`

This row provides a small intent-source fixture that exercises the CPM pipeline
for binder behavior testing: one tenant-to-external allow relation through
access → external stages.

Run:

```bash
tests/run-active-lab-mini-smt.sh --source binder-authority-boundary
```

This row may start at most 2 runtime targets.
