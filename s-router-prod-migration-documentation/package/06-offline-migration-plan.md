# Ordered Offline Migration Plan

Trace: FS-950-HDS-010-SDS-010-SMS-050

1. Freeze the source baseline: record the versioned nixos repo flake.lock *-prod input nodes as the source pin manifest (already captured in inputs/source-pins.json).
2. Bump flake.lock to the candidate coherent target pin set (flake.nix keeps floating refs per FS-985; flake.lock stays the sole authoritative revision-pinning surface).
3. Build the candidate offline artifact from the target pins without registering or starting any image.
4. Review this documentation package (parity matrix, override disposition ledger, semantic deltas, durable-state map) as the offline artifact review gate.
5. Authorize and perform the separately approved export of durable state into the declared offline-export root (Kea leases per VLAN, redacted reservation-override references, Nebula secret references); record sha256 checksums in the provenance manifest.
6. Verify exported artifact checksums against the provenance manifest before any restore is planned.
7. Define the s-tau canary VM from the candidate artifact with autoStart=false; do not start it from this plan.
8. After explicit human approval recorded outside this package, schedule the production migration as a separately authorized maintenance operation: restore durable state to the identical path classes, regenerate all derived configuration from the target pins, and re-verify checksums.
9. Re-run the offline parity predicates (Nebula 4242 ingress, stateful return semantics, policy routes, QEMU NIC cardinality, Kea state locations, secret-reference preservation, host/container equivalence) against the regenerated artifact before declaring the migration attempt complete.
