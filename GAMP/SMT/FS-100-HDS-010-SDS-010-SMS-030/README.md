# FS-100-HDS-010-SDS-010-SMS-030

Layer: SMT

This row-local source stub keeps the controlled GAMP input addressable from
`network-labs`. It is construction/integration preparation only and does not
claim HAT, SAT, or production readiness.

Current SMT construction evidence:
`NETWORK_REPO_DIRECT_TEST_OK=1 NETWORK_FOREIGN_CWD=/home/deadbeef/github/network-codex-agent bash tests/FS-100-HDS-010-SDS-010-SMS-030.sh`
passed at `network-compiler` HEAD `878f54c` on 2026-07-04.

Active-lab wrapper evidence:
`MINI_SMT_OFFLINE_VERIFY=0 tests/run-active-lab-mini-smt.sh FS-100-HDS-010-SDS-010-SMS-030`
must select a construction-only current-lab stub. Runtime compiler/NFM/CPM
verification and pinned `s-router-nixos` runtime build are not applicable
because `maxRuntimeTargets = 0`.
