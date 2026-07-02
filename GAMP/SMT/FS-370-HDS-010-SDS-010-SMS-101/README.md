# FS-370-HDS-010-SDS-010-SMS-101 SMT

Row-local intent-source fixture for per-lane return-path routing on policy and downstream-selector nodes.

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-370-HDS-010-SDS-010-SMS-101-policy-ds-per-lane-return-path-routing.md`

Status: OK - split boundary, construction evidence with active-lab context.

Validation Evidence Boundary: split
- Construction-provable (SMT): policy node routing table structure, lane-table routing, diagnostic correctness
- Live-required (HAT): runtime observation of actual return traffic paths through policy node

Mini topology: access (client-edge) -> core (provider-edge) with policy and downstream-selector in the fabric chain. The policy node must use per-lane return routing instead of ECMP main-table symmetric return.

Owning construction evidence lives in `network-control-plane-model`:
`NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/FS-370-HDS-010-SDS-010-SMS-101-per-lane-return-path-routing.sh`

The active-lab context runner is:
`NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/run-active-lab-mini-smt.sh FS-370-HDS-010-SDS-010-SMS-101`

Sibling traces: FS-370-HDS-010-SDS-010-SMS-050 (lane-egress-binding), FS-370-HDS-010-SDS-010-SMS-090 (core return-path), FS-370-HDS-010-SDS-010-SMS-100 (upstream-selector shared-iface ip rules).
