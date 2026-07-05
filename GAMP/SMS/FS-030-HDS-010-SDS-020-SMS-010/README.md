# FS-030-HDS-010-SDS-020-SMS-010 SMS Template

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-020-SMS-010-stage-topology-enforcement.md`

Template row for Stage Topology Enforcement.

**Evidence Boundary:** active-lab mini-SMT runtime plus compiler construction
evidence.

This row provides the row-local mini-SMT source for the canonical
`client-edge -> downstream-selector -> policy -> upstream-selector -> vlan4-client-dhcp-slaac`
path. It mirrors the canonical `network-codex-agent` SMS so lab-source coverage
cannot silently omit the stage-topology enforcement trace.

The authoritative construction test lives in `network-compiler`:
`tests/test-FS-030-HDS-010-SDS-020-SMS-010.sh`.

The current live evidence is recorded in the SMT/SIT rows after the
row-specific `network-codex-agent` live wrapper and
`tests/run-active-lab-mini-smt.sh FS-030-HDS-010-SDS-020-SMS-010` pass against
the locked active-lab hosts.

Latest validation, 2026-07-04:

- `NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-FS-030-HDS-010-SDS-020-SMS-010.sh`
  passed in `network-compiler`.
- `NETWORK_LABS_PATH=/home/deadbeef/github/network-labs S_ROUTER_NIXOS=s-router-nixos S_ROUTER_CLAB=s-router-clab S_ROUTER_TEST_CLIENTS=s-router-test-clients bash scripts/smt-live-FS-030-HDS-010-SDS-020-SMS-010.sh`
  passed in `network-codex-agent`; evidence root:
  `/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-020-SMS-010/20260704T044440Z`.
- `MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-030-HDS-010-SDS-020-SMS-010`
  passed; run root:
  `/tmp/active-lab-mini-smt-runs/20260704T044518Z-2877159/FS-030-HDS-010-SDS-020-SMS-010`.
- Manual runtime-debugger enumeration passed for p2p, routes, and runtime
  signals on `s-router-nixos`, `s-router-clab`, and
  `s-router-test-clients`.

Title slug: `stage-topology-enforcement`
