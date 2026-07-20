# SIT Mini Source: FS-030-HDS-010-SDS-020

SIT integration source for FS-030-HDS-010-SDS-020 stage-topology enforcement.

**Evidence Boundary:** active-lab mini-SMT runtime for
`FS-030-HDS-010-SDS-020-SMS-010`.

This row integrates the row-local intent source with the compiler construction
test and the locked active-lab runtime on `s-router-nixos`, `s-router-clab`,
and `s-router-test-clients`.

Current validation evidence must include:

- `NETWORK_REPO_DIRECT_TEST_OK=1 bash ../network-compiler/tests/FS-030-HDS-010-SDS-020-SMS-010.sh`.
- `NETWORK_LABS_PATH=/home/deadbeef/github/network-labs S_ROUTER_NIXOS=s-router-nixos S_ROUTER_CLAB=s-router-clab S_ROUTER_TEST_CLIENTS=s-router-test-clients bash ../network-codex-agent/scripts/live-FS-030-HDS-010-SDS-020-SMS-010.sh`.
- `MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-030-HDS-010-SDS-020-SMS-010`.

This is SIT active-lab child-row evidence only and does not promote HAT/SAT or
production readiness.

Latest validation, 2026-07-04, for `FS-030-HDS-010-SDS-020-SMS-010`:

- `s-router-nixos` current system:
  `/nix/store/xrzgj3p38iqlaw2d8nsm9xdji3mnwlm6-nixos-system-s-router-nixos-26.05.20260630.95ca1e2`;
  `/etc/network-artifacts/control-plane.json` had 5 runtime targets and 29
  full-trace hits.
- `s-router-clab` current system:
  `/nix/store/7a58zp8bwyqybxgp9bimbmg12g46gd2c-nixos-system-s-router-clab-26.05.20260630.95ca1e2`;
  `/etc/network-artifacts/control-plane.json` had 5 runtime targets and 29
  full-trace hits.
- `s-router-test-clients` current system:
  `/nix/store/njsq1nkk5g1r4hf5hmmxw8fjc3p7n4yn-nixos-system-s-router-test-clients-26.05.20260630.95ca1e2`;
  `/etc/network-artifacts/control-plane.json` had 0 runtime targets and 1
  full-trace hit.
- Manual runtime-debugger enumeration passed for p2p, routes, and runtime
  signals; CLAB artifacts were taken from
  `/persist/s-router-clab/live-boot/network-artifacts`.
