# FS-100-HDS-010-SDS-010-SMS-010

SMS template row for emitter repository provenance recording.

This SMS governs the compiler's emitter provenance recorder module. All predicates
are construction-provable (output field inspection, test fixture injection,
source scanning). No mini-SMT runtime surface exists — this trace is
construction-only per its Validation Evidence Boundary.

Current SMT evidence:
`network-compiler/tests/test-emitter-provenance-repo-boundary.sh`
(verified PASS at network-compiler HEAD aedc0f1, 2026-07-04).

Active-lab selection evidence:
`tests/run-active-lab-mini-smt.sh FS-100-HDS-010-SDS-010-SMS-010`
selects a construction-only current-lab stub with `source = null`,
`evidenceBoundary = "construction-only"`, and `maxRuntimeTargets = 0`. The
wrapper records optional `s-router-nixos`, `s-router-clab`, and
`s-router-test-clients` artifact context without treating runtime artifacts as
acceptance evidence.
