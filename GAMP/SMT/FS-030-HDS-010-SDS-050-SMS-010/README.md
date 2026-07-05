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
- `network-compiler` commit `3d2f3f3` PASS:
  `NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-FS-030-HDS-010-SDS-050-SMS-010.sh`.
- `network-codex-agent` commit `a61f921c` PASS:
  `bash tests/test-smt-live-FS-030-HDS-010-SDS-050-SMS-010.sh`.
- `network-labs` PASS:
  `GAMP/SMT/FS-030-HDS-010-SDS-050-SMS-010/test.sh`.
- Active-lab shutdown loop PASS for
  `S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-030-HDS-010-SDS-050-SMS-010`.
- Live evidence directories:
  `/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-050-SMS-010/20260704T055541Z`
  and
  `/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-050-SMS-010/20260704T055923Z`.
- Active-lab runner evidence:
  `/tmp/active-lab-mini-smt-runs/20260704T055916Z-2927018/FS-030-HDS-010-SDS-050-SMS-010`.
- Both live passes showed `s-router-nixos` runtimeTargets=5 traceHits=29,
  `s-router-clab` runtimeTargets=5 traceHits=29, and
  `s-router-test-clients` runtimeTargets=0 traceHits=1.
- Manual enumeration confirmed the pinned `nixos` flake selected
  `network-labs` rev `58836c92e9d96d16e0ee073b7771a855afff0014` and full trace
  `FS-030-HDS-010-SDS-050-SMS-010`.
- Manual enumeration confirmed NixOS nspawn containers `client-edge`,
  `downstream-selector`, `policy`, `upstream-selector`, and `core-vlan4-client-dhcp-slaac`
  exist with p2p interfaces up, and CLAB containers
  `clab-fabric-mini-smt-FS-030-HDS-010-SDS-050-SMS-010-*` are up with routes
  along the canonical access -> downstream-selector -> policy ->
  upstream-selector -> core chain.
- Manual runtime comparer PASS:
  `python3 scripts/runtime-debugger/main.py --s-router-nixos s-router-nixos --s-router-clab s-router-clab --s-router-test-clients s-router-test-clients --check p2p --check routes --check runtime_signals`.

This row proves the SMT construction and active-lab artifact realization for
the core role boundary. It does not claim HAT, SAT, production readiness, or
general client internet reachability.
