# SMT: FS-970-HDS-010-SDS-020-SMS-040

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-970-HDS-010-SDS-020-SMS-040-runtime-secret-reservation-materialization.md`

Status: NOT OK - final post-SOPS live proof pending.

This row creates one opaque dual-stack DHCP client on `s-router-test-clients`
and connects it to the matching access scope on `s-router-nixos` through the
lab-only VLAN 397. It remains NOT OK until the client identifiers have been
observed on that interface, the complete record has been delivered through
SOPS, and the same client has received the reserved IPv4 and IPv6 addresses.

Enrollment has recorded the real client interface identity and the complete
record is now present only in the row-owned encrypted SOPS source. The row is
not promoted until a clean rebuild proves both reservations on that same
client and the public/build-time redaction checks pass.

The first post-enrollment rebuild was correctly rejected: the test client's
default vendor DUID changed with its ephemeral container machine identity.
IPv4 remained reserved by the stable MAC, while DHCPv6 could not match the old
DUID. The client renderer now requests a link-layer DUID, and the protected
record has been re-enrolled from that real client interface. A second clean
rebuild and dual-stack lease comparison remain required before promotion.

Public source intentionally contains no per-client reservation handle,
hostname, MAC, IID, DUID, IAID, or reserved address. Those values belong only
to the protected runtime source and redacted live evidence.

Title slug: `runtime-secret-reservation-materialization`
