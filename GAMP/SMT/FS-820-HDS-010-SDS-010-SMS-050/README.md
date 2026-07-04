# SMT Source: FS-820-HDS-010-SDS-010-SMS-050

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-820-HDS-010-SDS-010-SMS-050-network-labs-sops-configuration-validation.md`

Status: NOT OK until the current active-lab runtime artifact proof passes.

The construction guard `NETWORK_REPO_DIRECT_TEST_OK=1 bash
tests/FS-820-HDS-010-SDS-010-SMS-050.sh` passed on 2026-06-30. This row now
also requires `../network-codex-agent/scripts/smt-live-FS-820-HDS-010-SDS-010-SMS-050.sh`
to prove the selected full trace on `s-router-nixos`, `s-router-clab`, and
`s-router-test-clients`.

Expected runtime target split: `s-router-nixos=5`, `s-router-clab=5`,
`s-router-test-clients=0`. This is SMT/SIT active-lab artifact evidence only;
secret decryptability, DHCP/DNS behavior, HAT, SAT, and production readiness
remain separate evidence.
