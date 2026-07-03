# SMT Mini Source: FS-030-HDS-010-SDS-010-SMS-010

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-010-SMS-010-intent-authority-boundary.md`

Status: Active mini-SMT/SIT source; row-local live evidence required before
recording current validation closure.

This row is registered in `GAMP/SMT/mini-smt/tests.nix` as an `intent-source`
mini-SMT and uses the network-codex-agent live wrapper
`scripts/smt-live-FS-030-HDS-010-SDS-010-SMS-010.sh`.

The focused construction predicate remains owned by
`network-compiler/tests/test-intent-source-boundary.sh`. The live wrapper also
verifies that the selected active-lab artifacts on `s-router-nixos`,
`s-router-clab`, and `s-router-test-clients` carry the full trace ID with the
expected five-router / zero-client runtime-target split.

Title slug: `intent-authority-boundary`
