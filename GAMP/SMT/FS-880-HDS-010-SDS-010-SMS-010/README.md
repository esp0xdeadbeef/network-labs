# SMT Source: FS-880-HDS-010-SDS-010-SMS-010

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-880-HDS-010-SDS-010-SMS-010-lease-namespace-ownership.md`

Status: NOT OK until the current active-lab runtime artifact proof passes.

This row is registered in `GAMP/SMT/mini-smt/tests.nix` and uses
`../network-codex-agent/scripts/live-FS-880-HDS-010-SDS-010-SMS-010.sh`
for active-lab SMT/SIT artifact validation on `s-router-nixos`,
`s-router-clab`, and `s-router-test-clients`.

Expected runtime target split: `s-router-nixos=5`, `s-router-clab=5`,
`s-router-test-clients=0`. Actual Kea lease allocation and namespace answer
behavior remain HAT/SAT evidence.
