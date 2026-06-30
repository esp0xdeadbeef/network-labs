# FS-270-HDS-010-SDS-010-SMS-040 SMT

Row-local source for the selector handoff transport forwarding boundary SMT.

**Validation Evidence Boundary:** construction-only — all predicates are provable with construction tests against CPM output. No live host/runtime surface required.

Run:

```bash
tests/run-active-lab-mini-smt.sh --source FS-270-HDS-010-SDS-010-SMS-040
```

Focused construction test: `network-control-plane-model/tests/FS-270-HDS-010-SDS-010-SMS-040-selector-forwarding-relation-identity.sh`

This row validates that selector routers emit only modeled handoff and transport forwarding, preserving relation identity, and reject unlabeled broad forwarding from local interface fanout.
