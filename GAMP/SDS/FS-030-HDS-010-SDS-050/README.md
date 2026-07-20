# FS-030-HDS-010-SDS-050 SDS

Status: OK - row-local mini-SMT source and live runtime evidence current.

This row groups the compiler core-role boundary source used by
`FS-030-HDS-010-SDS-050-SMS-010`.

The design proves that the compiler owns canonical stage adjacency and core
exit anchoring, while permission scope such as DNS recursion, service exposure,
and tenant reachability stays delegated to downstream FS-250/CPM authority.

Current evidence, 2026-07-04:

- `NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/FS-030-HDS-010-SDS-050-SMS-010.sh`
  in `network-compiler`.
- `GAMP/SMT/FS-030-HDS-010-SDS-050-SMS-010/test.sh` in `network-labs`.
- `NETWORK_LABS_PATH=/home/deadbeef/github/network-labs S_ROUTER_NIXOS=s-router-nixos S_ROUTER_CLAB=s-router-clab S_ROUTER_TEST_CLIENTS=s-router-test-clients bash scripts/live-FS-030-HDS-010-SDS-050-SMS-010.sh`
  in `network-codex-agent`.
- `MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-030-HDS-010-SDS-050-SMS-010`
  in `network-labs`; offline verifier was skipped, the live wrapper passed,
  and the pinned `s-router-nixos` build passed.
- Manual runtime comparer:
  `python3 scripts/runtime-debugger/main.py --s-router-nixos s-router-nixos --s-router-clab s-router-clab --s-router-test-clients s-router-test-clients --check p2p --check routes --check runtime_signals`.

Evidence paths:

- `/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-050-SMS-010/20260704T055541Z`
- `/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-050-SMS-010/20260704T055923Z`
- `/tmp/active-lab-mini-smt-runs/20260704T055916Z-2927018/FS-030-HDS-010-SDS-050-SMS-010`

This is SDS/SMS/SMT/SIT evidence for the focused row. It does not claim HAT,
SAT, production readiness, or general client internet reachability.
