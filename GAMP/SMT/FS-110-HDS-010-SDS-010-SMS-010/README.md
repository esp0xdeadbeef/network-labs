# FS-110-HDS-010-SDS-010-SMS-010

Layer: SMT

This row-local SMT selector is construction-only. It delegates the actual module
proof to `network-codex-agent`:

```text
bash tests/FS-110-HDS-010-SDS-010-SMS-010.sh
```

The active-lab wrapper verifies `source = null`,
`evidenceBoundary = "construction-only"`, and `maxRuntimeTargets = 0`; live
`s-router-*` artifacts are context only. This row does not claim HAT, SAT,
production readiness, or router runtime behavior.
