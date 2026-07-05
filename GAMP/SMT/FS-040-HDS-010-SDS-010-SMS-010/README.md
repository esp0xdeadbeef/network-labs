# SMT Active-Lab Source: FS-040-HDS-010-SDS-010-SMS-010

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-040-HDS-010-SDS-010-SMS-010-public-inventory-boundary.md`

Status: OK - active-lab live evidence current 2026-07-04.

This row is registered in `GAMP/SMT/mini-smt/tests.nix` as an active-lab
SMT/SIT runner for the public-inventory boundary. The focused construction
proof lives in `network-control-plane-model` at
`tests/FS-040-HDS-010-SDS-010-SMS-010-public-inventory-boundary.sh`; the live
row proof lives in `network-codex-agent` at
`scripts/smt-live-FS-040-HDS-010-SDS-010-SMS-010.sh`.

Current evidence:

- `network-control-plane-model/tests/FS-040-HDS-010-SDS-010-SMS-010-public-inventory-boundary.sh`
  PASS with `NETWORK_REPO_DIRECT_TEST_OK=1`.
- `network-codex-agent/scripts/smt-live-FS-040-HDS-010-SDS-010-SMS-010.sh`
  PASS at `5f1fb8fe`.
- Direct live evidence:
  `/tmp/s-router-live-smoke/FS-040-HDS-010-SDS-010-SMS-010/20260704T061645Z`.
- Active-lab runner evidence:
  `/tmp/active-lab-mini-smt-runs/20260704T062015Z-2938737/FS-040-HDS-010-SDS-010-SMS-010`.
- Active-lab runner live evidence:
  `/tmp/s-router-live-smoke/FS-040-HDS-010-SDS-010-SMS-010/20260704T062022Z`.
- Manual runtime comparer PASS:
  `python3 scripts/runtime-debugger/main.py --s-router-nixos s-router-nixos --s-router-clab s-router-clab --s-router-test-clients s-router-test-clients --check p2p --check routes --check runtime_signals`.

Both live passes showed `s-router-nixos` and `s-router-clab` artifacts with
runtimeTargets=5, publicInventoryAudits=15, traceHits=29; `s-router-test-clients`
had runtimeTargets=0, publicInventoryAudits=0, traceHits=1. Manual enumeration
captured `ip -br addr` and `ip -4 route show` for `client-edge`,
`downstream-selector`, `policy`, `upstream-selector`, and `vlan4-client-dhcp-slaac` in
both NixOS and CLAB.

Title slug: `public-inventory-boundary`
