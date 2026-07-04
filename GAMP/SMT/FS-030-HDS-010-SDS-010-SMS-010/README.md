# SMT Mini Source: FS-030-HDS-010-SDS-010-SMS-010

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-010-SMS-010-intent-authority-boundary.md`

Status: OK - active-lab mini-SMT runtime evidence.

This row is registered in `GAMP/SMT/mini-smt/tests.nix` as an `intent-source`
mini-SMT and uses the network-codex-agent live wrapper
`scripts/smt-live-FS-030-HDS-010-SDS-010-SMS-010.sh`.

The focused construction predicate remains owned by
`network-compiler/tests/test-intent-source-boundary.sh`. The live wrapper also
verifies that the selected active-lab artifacts on `s-router-nixos`,
`s-router-clab`, and `s-router-test-clients` carry the full trace ID with the
expected five-router / zero-client runtime-target split.

2026-07-04 verification:

- `MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-030-HDS-010-SDS-010-SMS-010` passed.
- `NETWORK_REPO_DIRECT_TEST_OK=1 bash ../network-compiler/tests/test-intent-source-boundary.sh` passed inside the live wrapper, proving side-channel and realization-technology seeded negatives fail before behavior-model emission and clean intent input succeeds.
- `../network-codex-agent/scripts/smt-live-FS-030-HDS-010-SDS-010-SMS-010.sh` passed on `s-router-nixos`, `s-router-clab`, and `s-router-test-clients`.
- Evidence directory:
  `/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-010-SMS-010/20260704T034222Z`.
- Runtime target counts were `s-router-nixos=5`, `s-router-clab=5`, and
  `s-router-test-clients=0`.

Title slug: `intent-authority-boundary`
