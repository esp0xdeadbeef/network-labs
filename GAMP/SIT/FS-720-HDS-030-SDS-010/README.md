# SIT Source Stub: FS-720-HDS-030-SDS-010

Status: NOT OK - SMS-041 source evidence passes, but live CLAB render status
currently fails; SMS-021 remains source stub only.

Focused evidence:

```bash
bash tests/FS-720-HDS-030-SDS-010-SMS-041-active-lab-tenant-bridge-source.sh
bash tests/FS-720-HDS-030-SDS-010-SMS-041-SIT-live-clab-render-status.sh s-router-clab
```

This proves the active-lab HAT inventories expose explicit tenant bridge fields
required by the CLAB renderer fail-closed contract, then checks the live CLAB
render marker. On 2026-06-29 the live marker is still `phase=render`,
`result=failure`, and the service journal shows duplicate `br-wan` target-host
bridge scoping before locked artifact acceptance.
