# SMT: FS-010-HDS-010-SDS-010-SMS-010

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-010-HDS-010-SDS-010-SMS-010-accepted-source-set.md`

Status: OK - active-lab mini-SMT construction and live runtime evidence.

This row mirrors the canonical accepted-source-set SMS and is registered in
`GAMP/SMT/mini-smt/tests.nix` with the focused runner
`tests/test-active-lab-mini-smt-fs010-accepted-source-set.sh`.

2026-07-04 verification:

- `MINI_SMT_OFFLINE_VERIFY=0 tests/run-active-lab-mini-smt.sh FS-010-HDS-010-SDS-010-SMS-010` passed.
- The run executed the focused source-set construction check with the offline
  compiler/NFM/CPM verifier disabled and the pinned `s-router-nixos` build
  enabled.
- `../network-codex-agent/scripts/live-FS-010-HDS-010-SDS-010-SMS-010.sh`
  passed after the local-only NixOS lock consumed `network-labs` commit
  `d1bc908670207cae9a79ce153c9dc506250dadd3`.
- Live evidence directory:
  `/tmp/s-router-live-smoke/FS-010-HDS-010-SDS-010-SMS-010/20260704T025858Z`.
- Runtime target counts were `s-router-nixos=5`, `s-router-clab=5`, and
  `s-router-test-clients=0`.

This is SMT/SIT active-lab evidence for accepted-source-set intake and bounded
runtime artifact projection. It does not claim HAT/SAT internet-routing
validation.

Title slug: `accepted-source-set`
