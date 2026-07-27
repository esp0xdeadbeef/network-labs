# SMS Mirror: FS-540-HDS-010-SDS-010-SMS-042

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-540-HDS-010-SDS-010-SMS-042-recursive-dns-projection-non-interference.md`

This network-labs row mirrors the canonical GAMP SMS trace so lab-source
coverage cannot silently omit it.

Status: Source stub only — not validation evidence.

The canonical SMS controls projection non-interference for recursive DNS
relations. The compiler and forwarding model shall not use a DNS relation as
an accidental retention switch for unrelated IPv6 policy routes,
runtime-prefix units, or non-DNS service paths. Every added, replaced, or
removed record shall attribute to the DNS relation, resolver service, and
selected path that authorize the change. Removing a DNS-to-WAN compatibility
relation shall not remove an IPv6 policy unit owned by another relation.
Input permutation shall not change the preserved record set or its
deterministic serialization.

Seeded negatives:
1. Start with independent VLAN 2, VLAN 7, delegated-prefix IPv6, and non-DNS
   service records. Replace only the temporary DNS-to-WAN relations with
   access-to-core and core-to-WAN DNS relations; every unrelated record shall
   remain byte-equivalent after stable ordering.
2. Seed a faulty retention branch that drops one unrelated IPv6 policy unit
   when the last DNS-to-WAN relation disappears; require a non-interference
   failure naming the lost modeled record ID and owning relation.
3. Permute DNS services and relations; the emitted DNS delta and preserved
   set shall remain byte-equivalent.

Construction handoff: `network-compiler` owns normalized relation retention
and `network-forwarding-model` owns route-atom projection. Each repository
shall provide a focused test for this full trace ID.

Add row-specific lab source and focused validation evidence in the SMT/SIT
row before marking this trace OK.
