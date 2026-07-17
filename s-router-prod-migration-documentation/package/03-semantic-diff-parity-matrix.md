# Semantic Diff and Parity Matrix

Trace: FS-950-HDS-010-SDS-010-SMS-050

## Recorded Semantic Deltas (user-supplied, each with owning reference)

- policy-broad-table-routes: candidate output loses some broad policy-table routes relative to the current production output (reference: audit-fact:2026-07-16-user-candidate-evaluation)
- stateful-return-rules: policy and upstream-selector gain correct stateful 'ct state established,related' return rules (reference: FS-950-HDS-010-SDS-010-SMS-050)
- host-container-equivalence: host networking, the QEMU contract, and the remaining containers stay equivalent within the supplied controlled snapshot (reference: audit-fact:2026-07-16-user-candidate-evaluation)

A byte-identical snapshot is not required; every allowed semantic
delta above carries an owning trace-chain or audit-fact reference.

## Parity Matrix

- [nebula-4242-dnat-snat-forward-return-routes] candidate output must carry all Nebula 4242 DNAT, SNAT and forward rules plus the required return routes that the public-ingress hotpatch provides today; these assertions were previously missing upstream and are asserted here explicitly (reference: FS-950-HDS-010-SDS-010-SMS-050)
- [stateful-return-semantics] policy and upstream-selector chains gain correct stateful 'ct state established,related' return rules; this is an approved semantic delta, not a regression (reference: FS-950-HDS-010-SDS-010-SMS-050)
- [policy-route-changes] candidate output loses some broad policy-table routes relative to the current production output; the delta is recorded and owned by the user candidate evaluation (reference: audit-fact:2026-07-16-user-candidate-evaluation)
- [qemu-nic-cardinality] candidate QEMU contract keeps exactly one vmbr4 NIC and adds no default user networking (qemu mkForce retained) (reference: audit-fact:2026-07-16-user-candidate-evaluation)
- [kea-state-locations] candidate retains StateDirectory=kea and /var/lib/kea/<vlan>.leases path-class semantics; no schema conversion is approved (reference: FS-880-HDS-010-SDS-010-SMS-010)
- [secret-reference-preservation] reservation overrides and Nebula secret material remain protected secret:// references in the candidate; no plaintext secret appears in any migrated or emitted artifact (reference: FS-950-HDS-010-SDS-010-SMS-050)
- [host-container-equivalence] host networking, the QEMU contract, and the remaining containers stay equivalent within the supplied controlled snapshot (reference: audit-fact:2026-07-16-user-candidate-evaluation)
