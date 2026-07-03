# SMS Mirror: FS-030-HDS-010-SDS-050-SMS-010

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-050-SMS-010-core-role-boundary.md`

This network-labs row mirrors the canonical GAMP SMS trace and binds it to the
row-local mini-SMT source used by `GAMP/SMT/mini-smt/tests.nix`.

Status: PENDING LIVE REVALIDATION.

Source inputs:
- `FS-030-HDS-010-SDS-050-SMS-010`: active intent-source mini-SMT input with
  five expected runtime targets on NixOS/CLAB and zero on test-clients.
- `canonical-source-stub`: retained mirror source-reference for canonical SMS
  coverage.

The authoritative construction test is
`network-compiler/tests/test-FS-030-HDS-010-SDS-050-SMS-010.sh`. Runtime artifact
evidence is pending the active-lab shutdown loop. The row-local
`GAMP/SMT/FS-030-HDS-010-SDS-050-SMS-010/test.sh` verifies the network-labs
source binding; the live runner remains
`network-codex-agent/scripts/smt-live-FS-030-HDS-010-SDS-050-SMS-010.sh`.
