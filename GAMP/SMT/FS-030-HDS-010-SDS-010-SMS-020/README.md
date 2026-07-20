# SMT Mini Source: FS-030-HDS-010-SDS-010-SMS-020

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-010-SMS-020-realization-binder-authority.md`

Status: OK - active-lab mini-SMT runtime evidence.

The authoritative construction test lives in `network-control-plane-model`:
`tests/FS-030-HDS-010-SDS-010-SMS-020.sh`

This row provides a small intent-source fixture that exercises the CPM pipeline
for binder behavior testing: one tenant-to-external allow relation through
access → external stages.

The live wrapper verifies that the selected active-lab artifacts on
`s-router-nixos`, `s-router-clab`, and `s-router-test-clients` carry the full
trace ID with the expected five-router / zero-client runtime-target split.

2026-07-04 verification:

- `MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-030-HDS-010-SDS-010-SMS-020` passed.
- `NETWORK_REPO_DIRECT_TEST_OK=1 bash ../network-control-plane-model/tests/FS-030-HDS-010-SDS-010-SMS-020.sh` passed inside the live wrapper, proving unauthorized inventory egress and untraceable route seeded negatives are rejected while the traced binder input is accepted.
- `../network-codex-agent/scripts/live-FS-030-HDS-010-SDS-010-SMS-020.sh` passed on `s-router-nixos`, `s-router-clab`, and `s-router-test-clients`.
- Evidence directory:
  `/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-010-SMS-020/20260704T035818Z`.
- Runtime target counts were `s-router-nixos=5`, `s-router-clab=5`, and
  `s-router-test-clients=0`.

Title slug: `realization-binder-authority`
