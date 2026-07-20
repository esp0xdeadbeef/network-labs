# SIT Mini Source: FS-020-HDS-010-SDS-010

Status: OK - active-lab mini-SMT integration evidence.

This SDS-scoped SIT row uses the row-local mini-SMT source and the
network-codex-agent live wrapper to prove that the locked active-lab artifacts
carry the source-class assignment trace on all three s-router lab hosts.

2026-07-04 verification:

- `MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-020-HDS-010-SDS-010-SMS-010` passed.
- `NETWORK_LABS_PATH=/home/deadbeef/github/network-labs S_ROUTER_NIXOS=s-router-nixos S_ROUTER_CLAB=s-router-clab S_ROUTER_TEST_CLIENTS=s-router-test-clients bash ../network-codex-agent/scripts/live-FS-020-HDS-010-SDS-010-SMS-010.sh` passed.
- Evidence directory:
  `/tmp/s-router-live-smoke/FS-020-HDS-010-SDS-010-SMS-010/20260704T032942Z`.
- Runtime target counts were `s-router-nixos=5`, `s-router-clab=5`, and
  `s-router-test-clients=0`.

This row does not claim HAT/SAT production readiness.
