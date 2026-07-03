# FS-030-HDS-010-SDS-050-SMS-010 SMT

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-050-SMS-010-core-role-boundary.md`

Status: OK.

This row is registered in `GAMP/SMT/mini-smt/tests.nix` as an `intent-source`
mini-SMT and uses the full trace-ID live verifier:
`../network-codex-agent/scripts/smt-live-FS-030-HDS-010-SDS-050-SMS-010.sh`.

## Construction Evidence

The authoritative construction test lives in `network-compiler`:
`tests/test-FS-030-HDS-010-SDS-050-SMS-010.sh`

Per the SMS Construction Handoff, the test proves:
- valid canonical access -> downstream-selector -> policy -> upstream-selector -> core topology compiles;
- direct core-to-access links hard-fail;
- direct core-to-downstream-selector links hard-fail;
- core reachability without policy traversal hard-fails;
- core appears only as the exit anchor in compiled stage paths;
- SN2 permission scope stays delegated to FS-250/CPM instead of being duplicated in the compiler.

## Evidence Boundary

Construction-plus-live-artifact. The compiler construction test is the authority
for the core-role boundary predicates. The active-lab runtime check must still
prove that the selected row is loaded into the pinned NixOS and CLAB artifacts
with the expected runtime targets and that `s-router-test-clients` has no local
runtime targets for this row.

## Current Evidence

2026-07-04 evidence:
- `network-compiler` commit `11afb39` PASS:
  `NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-FS-030-HDS-010-SDS-050-SMS-010.sh`.
- `network-compiler` PASS:
  `nix flake check --no-build`.
- `network-compiler` PASS:
  `NETWORK_REPO_DIRECT_TEST_OK=1 TEST_ASYNC_JOBS=4 bash run-all-tests.sh` (50/50).
- `network-codex-agent` PASS:
  `bash tests/test-smt-live-FS-030-HDS-010-SDS-050-SMS-010.sh`.
- Active-lab shutdown loop PASS for
  `S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-030-HDS-010-SDS-050-SMS-010`.
- Live evidence directories:
  `/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-050-SMS-010/20260703T230438Z`
  and
  `/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-050-SMS-010/20260703T230541Z`.
- Both live passes showed `s-router-nixos` runtimeTargets=5 traceHits=29,
  `s-router-clab` runtimeTargets=5 traceHits=29, and
  `s-router-test-clients` runtimeTargets=0 traceHits=1.
- Manual enumeration confirmed the pinned `nixos` flake selected
  `network-labs` rev `71ae5dcbea1c4409d96dd4413c8a7a04bd077ebf` and full trace
  `FS-030-HDS-010-SDS-050-SMS-010`.
- Manual enumeration confirmed NixOS nspawn containers `client-edge`,
  `downstream-selector`, `policy`, `upstream-selector`, and `testnet-edge`
  exist with p2p interfaces up, and CLAB containers
  `clab-fabric-mini-smt-FS-030-HDS-010-SDS-050-SMS-010-*` are up with routes
  along the canonical access -> downstream-selector -> policy ->
  upstream-selector -> core chain.

This row proves the SMT construction and active-lab artifact realization for
the core role boundary. It does not claim HAT, SAT, production readiness, or
general client internet reachability.
