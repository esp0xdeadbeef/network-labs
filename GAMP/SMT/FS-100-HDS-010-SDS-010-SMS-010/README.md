# FS-100-HDS-010-SDS-010-SMS-010 SMT

Row-local source stub for emitter repository provenance recording.

This SMS is construction-only — no active-lab mini-SMT runtime targets.
Current SMT construction evidence is in `network-compiler`:
`NETWORK_REPO_DIRECT_TEST_OK=1 NETWORK_FOREIGN_CWD=/home/deadbeef/github/network-codex-agent bash tests/test-emitter-provenance-repo-boundary.sh`

Active-lab wrapper evidence:
`MINI_SMT_OFFLINE_VERIFY=0 tests/run-active-lab-mini-smt.sh FS-100-HDS-010-SDS-010-SMS-010`
PASS on 2026-07-04. The selected current-lab metadata evaluated to
`sourceKind = "construction-only"` and `constructionOnly = true`; offline
compiler/NFM/CPM runtime verification and pinned `s-router-nixos` runtime build
were not applicable because `maxRuntimeTargets = 0`.

SMT status: OK (re-verified 2026-07-04 at network-compiler HEAD aedc0f1).
