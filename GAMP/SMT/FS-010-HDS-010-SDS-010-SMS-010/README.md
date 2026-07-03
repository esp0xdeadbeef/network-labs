# SMT: FS-010-HDS-010-SDS-010-SMS-010

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-010-HDS-010-SDS-010-SMS-010-accepted-source-set.md`

Status: OK - active-lab mini-SMT construction evidence.

This row mirrors the canonical accepted-source-set SMS and is registered in
`GAMP/SMT/mini-smt/tests.nix` with the focused runner
`tests/test-active-lab-mini-smt-fs010-accepted-source-set.sh`.

2026-07-03 verification:

- `tests/run-active-lab-mini-smt.sh FS-010-HDS-010-SDS-010-SMS-010` passed.
- The run executed the focused source-set construction check, offline
  compiler/NFM/CPM verification for `inventory-nixos.nix` and
  `inventory-clab.nix`, and the pinned `s-router-nixos` build.

This is SMT construction/source-set evidence only. It does not claim HAT/SAT
runtime behavior or internet-routing validation.

Title slug: `accepted-source-set`
