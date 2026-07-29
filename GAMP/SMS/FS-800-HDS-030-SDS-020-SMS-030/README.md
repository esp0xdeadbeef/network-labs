# SMS Mirror: FS-800-HDS-030-SDS-020-SMS-030

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-800-HDS-030-SDS-020-SMS-030-delegated-prefix-lease-state-publication.md`

This network-labs row mirrors the canonical GAMP SMS trace so lab-source
coverage cannot silently omit it.

Status: Source stub only — not validation evidence.

The canonical SMS owns protected lease-state publication for DHCPv6-PD lease
transitions on the modeled PPP interface. It consumes the native acquisition
record from SMS-020 and publishes one active generation identity with opaque
prefix handle, preferred/valid lifetimes, and consumer notification. It treats
renew of the same prefix as a lifetime update, rebind to another prefix as a
new generation, and expiry/provider loss as withdrawal. The delegated prefix
value stays runtime-only; prefix/address values shall not appear in
evaluation, derivation text, logs, diagnostics, or unprotected evidence.

Seeded negatives:
1. Omit preferred or valid lifetime and require fail-closed publication.
2. Deliver renew, rebind, expiry, and provider-loss events out of order and
   require deterministic stale-event rejection.
3. Attempt to publish two active generations and require ambiguity failure.
4. Scan evaluation/store/log/evidence surfaces for the protected fixture value
   and require zero hits.

Construction handoff: CPM normalizes lifecycle authority. The protected
runtime generation record is an authorized realization fact consumed by
`network-realization-model`, which shall emit only its opaque reference and
scoped lifecycle meaning in the canonical bundle. The pinned schema contract
shall validate that record before NixOS and CLAB renderers bind their native
DHCPv6-PD client/event adapters. Host profiles may deliver protected state
through the validated platform binding but shall not run a parallel client or
event publisher.

Add row-specific lab source and focused validation evidence in the SMT/SIT
row before marking this trace OK.
