# SMS Mirror: FS-040-HDS-010-SDS-010-SMS-010

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-040-HDS-010-SDS-010-SMS-010-public-inventory-boundary.md`

This network-labs row mirrors the canonical GAMP SMS trace so lab-source
coverage cannot silently omit it.

Status: OK - active-lab live evidence current 2026-07-04.

The canonical SMS title slug is `public-inventory-boundary`. The row-specific
lab source is present and the active-lab runner passed during the 2026-07-04
full rebuild loop.

Current evidence:

- `network-control-plane-model/tests/FS-040-HDS-010-SDS-010-SMS-010.sh`
  PASS with `NETWORK_REPO_DIRECT_TEST_OK=1`.
- `network-codex-agent/scripts/live-FS-040-HDS-010-SDS-010-SMS-010.sh`
  PASS at `5f1fb8fe`, including manual NixOS/CLAB container enumeration.
- Direct evidence:
  `/tmp/s-router-live-smoke/FS-040-HDS-010-SDS-010-SMS-010/20260704T061645Z`.
- Active-lab runner evidence:
  `/tmp/active-lab-mini-smt-runs/20260704T062015Z-2938737/FS-040-HDS-010-SDS-010-SMS-010`.
- Runner live evidence:
  `/tmp/s-router-live-smoke/FS-040-HDS-010-SDS-010-SMS-010/20260704T062022Z`.

The evidence proves public-inventory binder audit records in NixOS and CLAB
runtime artifacts, zero router runtime targets on `s-router-test-clients`, and
live interface/route enumeration for the five expected runtime containers.
