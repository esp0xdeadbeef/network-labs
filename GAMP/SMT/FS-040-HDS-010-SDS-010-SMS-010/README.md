# SMT Active-Lab Source: FS-040-HDS-010-SDS-010-SMS-010

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-040-HDS-010-SDS-010-SMS-010-public-inventory-boundary.md`

Status: NOT OK - runnable active-lab row pending current live evidence.

This row is registered in `GAMP/SMT/mini-smt/tests.nix` as an active-lab
SMT/SIT runner for the public-inventory boundary. The focused construction
proof lives in `network-control-plane-model` at
`tests/FS-040-HDS-010-SDS-010-SMS-010-public-inventory-boundary.sh`; the live
row proof lives in `network-codex-agent` at
`scripts/smt-live-FS-040-HDS-010-SDS-010-SMS-010.sh`.

The row is not OK until the active-lab selection points to this trace and the
live verifier passes against `s-router-nixos`, `s-router-clab`, and
`s-router-test-clients`.

Title slug: `public-inventory-boundary`
