# SMS Mirror: FS-030-HDS-010-SDS-050-SMS-010

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-050-SMS-010-core-role-boundary.md`

This network-labs row mirrors the canonical GAMP SMS trace and binds it to the
row-local mini-SMT source used by `GAMP/SMT/mini-smt/tests.nix`.

Status: OK.

Source inputs:
- `FS-030-HDS-010-SDS-050-SMS-010`: active intent-source mini-SMT input with
  five expected runtime targets on NixOS/CLAB and zero on test-clients.
- `canonical-source-stub`: retained mirror source-reference for canonical SMS
  coverage.

The authoritative construction test is
`network-compiler/tests/FS-030-HDS-010-SDS-050-SMS-010.sh`. The row-local
`GAMP/SMT/FS-030-HDS-010-SDS-050-SMS-010/test.sh` verifies the network-labs
source binding; the live runner is
`network-codex-agent/scripts/live-FS-030-HDS-010-SDS-050-SMS-010.sh`.

Current evidence, 2026-07-04:

- `NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/FS-030-HDS-010-SDS-050-SMS-010.sh`
  in `network-compiler` at `3d2f3f3`.
- `bash tests/FS-030-HDS-010-SDS-050-SMS-010.sh` in
  `network-codex-agent` at `a61f921c`.
- `GAMP/SMT/FS-030-HDS-010-SDS-050-SMS-010/test.sh` in `network-labs`.
- Direct live verifier PASS:
  `/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-050-SMS-010/20260704T055541Z`.
- Active-lab runner PASS:
  `/tmp/active-lab-mini-smt-runs/20260704T055916Z-2927018/FS-030-HDS-010-SDS-050-SMS-010`.
- Active-lab runner live verifier evidence:
  `/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-050-SMS-010/20260704T055923Z`.

The live evidence proves NixOS and CLAB expose the five expected runtime
targets, `s-router-test-clients` exposes zero local runtime targets for this
row, and manual runtime-debugger p2p/routes/runtime_signals checks pass for the
focused row. This is not HAT, SAT, production readiness, or general client
internet reachability evidence.
