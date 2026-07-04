# FS-100-HDS-010-SDS-010-SMS-040 SMT

Row-local source for Provenance Redaction.

**Validation Evidence Boundary:** construction-only — all predicates are provable with construction tests against compile-time output. No live host/runtime surface required.

Construction test: `network-codex-agent/tests/FS-100-HDS-010-SDS-010-SMS-040.sh`

See SMS spec in network-codex-agent/GAMP/SMS/FS-100-HDS-010-SDS-010-SMS-040-*.md

Current SMT construction evidence:
`bash tests/FS-100-HDS-010-SDS-010-SMS-040.sh` passed at
`network-codex-agent` HEAD `018960fe` on 2026-07-04.

Active-lab wrapper evidence:
`MINI_SMT_OFFLINE_VERIFY=0 tests/run-active-lab-mini-smt.sh FS-100-HDS-010-SDS-010-SMS-040`
must select a construction-only current-lab stub. Runtime compiler/NFM/CPM
verification and pinned `s-router-nixos` runtime build are not applicable
because `maxRuntimeTargets = 0`.
