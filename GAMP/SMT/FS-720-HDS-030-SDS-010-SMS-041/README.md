# SMT Source Stub: FS-720-HDS-030-SDS-010-SMS-041

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-720-HDS-030-SDS-010-SMS-041-ae-fail-closed-contract.md`

Status: OK - active-lab source fixture evidence only.

Focused evidence:

```bash
bash tests/FS-720-HDS-030-SDS-010-SMS-041.sh
```

This proves the active-lab HAT inventories expose explicit tenant `attach.bridge`
fields for CLAB/NixOS core tenant surfaces and provider handoff surfaces before
the CLAB renderer fail-closed bridge-field contract is exercised. It does not
claim live HAT/SAT session acceptance.

Title slug: `ae-fail-closed-contract`
