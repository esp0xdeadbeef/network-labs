# SMT Source Stub: FS-720-HDS-030-SDS-010-SMS-021

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-720-HDS-030-SDS-010-SMS-021-ae-cpm-only-consumption.md`

Status: OK - owning access-endpoint renderer construction evidence passes.

Focused evidence:

```bash
(cd ../network-renderer-access-endpoint-nixos &&
  NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/FS-720-HDS-030-SDS-010-SMS-021.sh)
```

This row mirrors the canonical SMS trace and records the owning renderer
construction proof. The focused test proves access-endpoint fixture data is
consumed through CPM `endpointAssignment`, rejects direct raw intent/inventory
rediscovery, rejects CPM-missing fallback recovery, and verifies the SMS-021
diagnostic guards. It does not claim HAT/SAT payload acceptance.

Title slug: `ae-cpm-only-consumption`
