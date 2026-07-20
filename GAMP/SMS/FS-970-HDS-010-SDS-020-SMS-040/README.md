# SMS Mirror: FS-970-HDS-010-SDS-020-SMS-040

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-970-HDS-010-SDS-020-SMS-040-runtime-secret-reservation-materialization.md`

This network-labs row mirrors the canonical GAMP SMS trace so lab-source
coverage cannot silently omit it. The specification requires the lab to create
an actual test client in the served access scope before enrolling a reservation.
The MAC address and stable IPv6 interface identifier (IID) must be observed on
that client's served interface. When DHCPv6 matches protocol identity, the DUID
and IAID must be observed on the same interface as separate identifiers; an IID
must not be substituted for a DUID/IAID.

The same client interface must reproduce its MAC, IID, DUID, and IAID after a
clean restart or rebuild before those identifiers are accepted as stable. The
verified identifiers, reserved IPv4 and IPv6 addresses, optional private
hostname, and opaque client handle form one complete protected record. Public
lab inventory contains only the served-scope contract and the opaque runtime
source reference; it does not enumerate reservation records.

Runtime consumers must fail closed when the protected record is missing,
inconsistent with the served prefix or interface, unstable across the rebuild
boundary, or disclosed through a public or build-time surface. Host-specific
post-render overrides must not replace the runtime-materialized set.

A protected bind is not by itself a reservation-service capability. The CLAB
Kea lifecycle label is valid only on a target that emits renderer-owned Kea
reconciliation scripts for an explicitly served scope. A routed-prefix-only
target must retain its protected bind without receiving a Kea label or
reconciliation attempt.

Status: source mirror only; implementation and validation status belong to the
corresponding SMT/SIT records.

Title slug: `runtime-secret-reservation-materialization`
