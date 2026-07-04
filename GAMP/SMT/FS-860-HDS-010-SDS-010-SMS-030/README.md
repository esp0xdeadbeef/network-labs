# SMT Source: FS-860-HDS-010-SDS-010-SMS-030

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-860-HDS-010-SDS-010-SMS-030-scoped-storage-binding-emission.md`

Status: NOT OK until the current active-lab runtime artifact proof passes.

This row is registered in `GAMP/SMT/mini-smt/tests.nix` and uses
`../network-codex-agent/scripts/smt-live-FS-860-HDS-010-SDS-010-SMS-030.sh`
for active-lab SMT/SIT artifact validation on `s-router-nixos`,
`s-router-clab`, and `s-router-test-clients`.

Expected runtime target split: `s-router-nixos=5`, `s-router-clab=5`,
`s-router-test-clients=0`. Service restart persistence and lease/database
survival remain HAT/SAT evidence.
