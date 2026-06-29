# FS-800-HDS-020-SDS-021

Status: OK - small source fixture and live active-lab secret materialization
pass.

Focused evidence:

```bash
bash tests/FS-800-HDS-020-SDS-021-SMS-010-hat-emulated-test-secret-materialization.sh &&
bash tests/FS-800-HDS-020-SDS-021-SIT-live-secret-presence.sh s-router-nixos
```

The source contract is tested by the SMT script. On 2026-06-29 the SMT check
was tightened to verify host-specific active-lab SOPS routing for
`s-router-nixos`, `s-router-clab`, and `s-router-test-clients`; source SMT and
live `s-router-nixos` decrypt of `sops-s-router-nixos.yaml` pass.

On 2026-06-29 the live SIT probe passed on `s-router-nixos`: both
`/run/secrets/hat-pppoe-username` and `/run/secrets/hat-pppoe-password` exist
with the required root-only boundary. This row no longer blocks PPPoE runtime
validation.
