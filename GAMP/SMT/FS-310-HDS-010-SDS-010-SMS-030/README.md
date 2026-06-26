# FS-310-HDS-010-SDS-010-SMS-030 SMT

Row-local source for the mini policy-router relation identity SMT.

Run:

```bash
tests/run-active-lab-mini-smt.sh --source policy-router-relation-identity
```

This row exercises policy router relation identity preservation: one tenant-to-external allow relation with an explicit `id` field, flowing through access → downstream-selector → policy → upstream-selector → core stages.
