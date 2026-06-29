# FS-800-HDS-020-SDS-021

Status: NOT OK - live active-lab secret materialization currently fails.

Focused evidence:

```bash
bash tests/FS-800-HDS-020-SDS-021-SMS-010-hat-emulated-test-secret-materialization.sh &&
bash tests/FS-800-HDS-020-SDS-021-SIT-live-secret-presence.sh s-router-nixos
```

The source contract is still tested by the SMT script. The live SIT probe must
also pass before this row can support the next HAT run. On 2026-06-29 the live
host lacks `/run/secrets/hat-pppoe-username` and
`/run/secrets/hat-pppoe-password`, and PPPoE containers fail before runtime
PPPoE can be validated.
