# FS-840-HDS-010-SDS-010-SMS-040 SMT

Row-local source for Impermanence-Safe Early SOPS Delivery.

**Validation Evidence Boundary:** split. Construction tests prove the
configuration predicates. The active-lab SMT/SIT wrapper
`../network-codex-agent/scripts/smt-live-FS-840-HDS-010-SDS-010-SMS-040.sh`
must also prove the selected full trace on `s-router-nixos`, `s-router-clab`,
and `s-router-test-clients`.

Expected runtime target split: `s-router-nixos=5`, `s-router-clab=5`,
`s-router-test-clients=0`. Post-reboot secret delivery remains HAT/SAT
evidence.
