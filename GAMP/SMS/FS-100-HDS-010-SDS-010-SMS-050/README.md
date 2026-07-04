# FS-100-HDS-010-SDS-010-SMS-050

Layer: SMS

This row-local source reference binds the canonical
`network-codex-agent/GAMP/SMS/FS-100-HDS-010-SDS-010-SMS-050-output-artifact-baseline-binding.md`
SMS to the active-lab construction-only selector.

The row does not create runtime targets. Current evidence is the
`network-codex-agent` focused construction proof at code commit `f06e03c2` and
the active-lab wrapper run:

```text
MINI_SMT_OFFLINE_VERIFY=0 tests/run-active-lab-mini-smt.sh FS-100-HDS-010-SDS-010-SMS-050
```

This row does not claim HAT, SAT, production readiness, or router runtime
behavior.
