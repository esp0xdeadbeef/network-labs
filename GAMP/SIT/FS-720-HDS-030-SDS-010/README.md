# SIT Source Stub: FS-720-HDS-030-SDS-010

Status: OK - SMS-021/SMS-041 construction evidence, active-lab source
evidence, and live active-lab runtime materialization probes pass.

Focused evidence:

```bash
bash tests/FS-720-HDS-030-SDS-010-SMS-041-active-lab-tenant-bridge-source.sh
bash tests/FS-720-HDS-030-SDS-010-SMS-041-SIT-live-clab-render-status.sh s-router-clab
(cd ../network-renderer-access-endpoint-nixos &&
  NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/FS-720-HDS-030-SDS-010-SMS-021.sh &&
  NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/FS-720-HDS-030-SDS-010-SMS-041.sh)
(cd ../network-renderer-containerlab-linux-backend &&
  NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-fs720-hds030-sds010-sms041-wan-host-uplink-bridge.sh)
(cd ../network-codex-agent &&
  scripts/fs720-active-lab-endpoint-clab-runtime-check.sh --live)
```

This proves the active-lab HAT inventories expose explicit tenant bridge fields
required by the CLAB renderer fail-closed contract, then checks the live CLAB
render marker. On 2026-06-29 the live marker is `phase=complete`,
`result=success`; the prior duplicate `br-wan` target-host bridge failure is no
longer present. The live verifier at `network-codex-agent@616d8272` also SSHes
to `s-router-test-clients` and checks endpoint CPM assignment records, active
endpoint containers, host bridge plumbing, absence of host IP assignment on
endpoint bridges, and static endpoint container addresses/routes. This is
row-specific SIT/runtime materialization evidence and does not promote HAT/SAT
payload acceptance.
