# SIT Mini Source: FS-030-HDS-010-SDS-010

SIT integration source for FS-030-HDS-010-SDS-010 active mini-SMT rows.

**Evidence Boundary:** active-lab mini-SMT runtime for the validated child row.

2026-07-04 verification for child
`FS-030-HDS-010-SDS-010-SMS-010`:

- `MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-030-HDS-010-SDS-010-SMS-010` passed.
- `NETWORK_LABS_PATH=/home/deadbeef/github/network-labs S_ROUTER_NIXOS=s-router-nixos S_ROUTER_CLAB=s-router-clab S_ROUTER_TEST_CLIENTS=s-router-test-clients bash ../network-codex-agent/scripts/smt-live-FS-030-HDS-010-SDS-010-SMS-010.sh` passed.
- Evidence directory:
  `/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-010-SMS-010/20260704T034222Z`.
- Runtime target counts were `s-router-nixos=5`, `s-router-clab=5`, and
  `s-router-test-clients=0`.

Sibling rows `FS-030-HDS-010-SDS-010-SMS-020`,
`FS-030-HDS-010-SDS-010-SMS-030`, and
`FS-030-HDS-010-SDS-010-SMS-040` retain their own independent evidence.
