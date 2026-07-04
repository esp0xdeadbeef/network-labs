# FS-830-HDS-010-SDS-010-SMS-040 SMT

Row-local source for SOPS Bootstrap Identity Transport for nixos-anywhere.

**Validation Evidence Boundary:** split. Construction tests prove the
preparation plan and staged file tree. The active-lab SMT/SIT wrapper
`../network-codex-agent/scripts/smt-live-FS-830-HDS-010-SDS-010-SMS-040.sh`
must also prove the selected full trace on `s-router-nixos`, `s-router-clab`,
and `s-router-test-clients`.

Expected runtime target split: `s-router-nixos=5`, `s-router-clab=5`,
`s-router-test-clients=0`. Live host activation and post-reboot decryptability
remain HAT/SAT evidence.
