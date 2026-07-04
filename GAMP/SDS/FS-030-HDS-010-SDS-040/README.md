# FS-030-HDS-010-SDS-040

Layer: SDS

This row-local source keeps the platform-independence contract addressable from
`network-labs`.

The row proves the SDS design with a focused mini-SMT input and live
integration path:

- compiler construction rejects renderer, platform, bridge, substrate
  technology, and platform-output leak predicates;
- the active-lab source remains an intent-source fixture with one modeled
  relation, not renderer-specific source authority;
- NixOS and Containerlab consume the same full-trace source and materialize
  five runtime targets without needing renderer-specific intent fields;
- `s-router-test-clients` consumes the same row with zero runtime targets.

Current evidence, 2026-07-04:

- `NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-FS-030-HDS-010-SDS-040-SMS-010.sh`
  in `network-compiler`.
- `NETWORK_LABS_PATH=/home/deadbeef/github/network-labs S_ROUTER_NIXOS=s-router-nixos S_ROUTER_CLAB=s-router-clab S_ROUTER_TEST_CLIENTS=s-router-test-clients bash scripts/smt-live-FS-030-HDS-010-SDS-040-SMS-010.sh`
  in `network-codex-agent`.
- `MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-030-HDS-010-SDS-040-SMS-010`
  in `network-labs`; offline verifier was skipped, the live wrapper passed,
  and the pinned `s-router-nixos` build passed.
- Manual runtime comparer:
  `python3 scripts/runtime-debugger/main.py --s-router-nixos s-router-nixos --s-router-clab s-router-clab --s-router-test-clients s-router-test-clients --check p2p --check routes --check runtime_signals`.

Evidence paths:

- `/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-040-SMS-010/20260704T053321Z`
- `/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-040-SMS-010/20260704T053649Z`
- `/tmp/active-lab-mini-smt-runs/20260704T053642Z-2913672/FS-030-HDS-010-SDS-040-SMS-010`

This is SDS/SMS/SMT/SIT evidence for the focused row. It does not claim HAT,
SAT, or production readiness.
