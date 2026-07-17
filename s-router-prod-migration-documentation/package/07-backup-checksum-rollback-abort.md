# Backup, Checksum, Idempotence, Rollback and Abort Plan

Trace: FS-950-HDS-010-SDS-010-SMS-050

## Backup Artifacts

- offline-export/kea-leases-<vlan>.tar
- offline-export/kea-reservation-overrides.redacted.json
- offline-export/nebula-secret-references.json
- versioned repo history at the source pin revisions (flake.lock lineage)

## Checksum Verification

- sha256 comparison of every restored artifact against the checksums recorded in the provenance manifest of the declared offline-export root; a mismatch stops the rollback step and escalates to the abort plan

## Idempotence Keys

- kea-leases-per-vlan-memfile-v1
- kea-reservation-overrides-refs-v1
- nebula-secret-references-v1
- qemu-contract-parity-v1
- flake-lock-source-pin-set-v1

## Ordered Rollback Steps

1. Stop the migration attempt at the failed step; do not proceed to later steps.
2. Restore flake.lock to the recorded source pin manifest revision set (inputs/source-pins.json).
3. Restore durable state from the backup artifacts in the declared offline-export root to their identical source path classes.
4. Re-verify every restored artifact against its recorded sha256 checksum before declaring rollback complete.
5. Regenerate derived configuration from the restored source pins; never restore generated routes, nftables, networkd, renderer output, Nix store paths, or VM images as authoritative data.

## Abort Plan

- trigger: any failed checksum verification, missing backup artifact, unclassified override encountered mid-plan, or unapproved semantic delta discovered during review
- procedure: halt all remaining steps, keep the source baseline pins authoritative, leave durable state untouched, and route the finding back to this documentation package for a new review cycle
- authority: abort requires no approval; resuming after abort requires a new explicit human authorization recorded outside this package
