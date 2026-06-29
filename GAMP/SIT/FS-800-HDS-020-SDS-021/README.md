# FS-800-HDS-020-SDS-021

Status: NOT OK - live active-lab secret materialization currently fails on the
deployed host generation.

Focused evidence:

```bash
bash tests/FS-800-HDS-020-SDS-021-SMS-010-hat-emulated-test-secret-materialization.sh &&
bash tests/FS-800-HDS-020-SDS-021-SIT-live-secret-presence.sh s-router-nixos
```

The source contract is tested by the SMT script. On 2026-06-29 the SMT check
was tightened to verify host-specific active-lab SOPS routing for
`s-router-nixos`, `s-router-clab`, and `s-router-test-clients`; source SMT and
live `s-router-nixos` decrypt of `sops-s-router-nixos.yaml` pass.

The live SIT probe must still pass before this row can support the next HAT
run. The deployed `s-router-nixos` generation still lacks
`/run/secrets/hat-pppoe-username` and `/run/secrets/hat-pppoe-password`, and
PPPoE containers fail before runtime PPPoE can be validated.
