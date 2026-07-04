# FS-100-HDS-010-SDS-010-SMS-050

Layer: SMT

This row-local SMT selector is construction-only. It delegates the actual module
proof to `network-codex-agent`:

```text
bash tests/FS-100-HDS-010-SDS-010-SMS-050.sh
```

The active-lab wrapper was verified on 2026-07-04:

```text
MINI_SMT_OFFLINE_VERIFY=0 tests/run-active-lab-mini-smt.sh FS-100-HDS-010-SDS-010-SMS-050
```

The run selected `source = null`, `evidenceBoundary = "construction-only"`, and
`maxRuntimeTargets = 0`; live `s-router-*` artifacts were collected as context
only. This row does not claim HAT, SAT, production readiness, or router runtime
behavior.
