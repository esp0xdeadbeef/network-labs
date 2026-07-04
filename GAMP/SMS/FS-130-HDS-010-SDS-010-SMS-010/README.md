# FS-130-HDS-010-SDS-010-SMS-010

Layer: SMS

This row-local source reference binds the canonical
`network-codex-agent/GAMP/SMS/FS-130-HDS-010-SDS-010-SMS-010-scoped-request-contract.md`
SMS to the active-lab construction-only selector.

The row does not create runtime targets. Current evidence is the
`network-codex-agent` focused construction proof:

```text
bash tests/FS-130-HDS-010-SDS-010-SMS-010.sh
```

and the active-lab wrapper:

```text
MINI_SMT_OFFLINE_VERIFY=0 tests/run-active-lab-mini-smt.sh FS-130-HDS-010-SDS-010-SMS-010
```

This row does not claim HAT, SAT, production readiness, or router runtime
behavior.
