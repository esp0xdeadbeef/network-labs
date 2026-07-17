# SMT: FS-970-HDS-010-SDS-020-SMS-040

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-970-HDS-010-SDS-020-SMS-040-runtime-secret-reservation-materialization.md`

Status: NOT OK - live proof pending.

This row creates one opaque dual-stack DHCP client on `s-router-test-clients`
and connects it to the matching access scope on `s-router-nixos` through the
lab-only VLAN 397. It remains NOT OK until the client identifiers have been
observed on that interface, the complete record has been delivered through
SOPS, and the same client has received the reserved IPv4 and IPv6 addresses.

Public source intentionally contains no per-client reservation handle,
hostname, MAC, IID, DUID, IAID, or reserved address. Those values belong only
to the protected runtime source and redacted live evidence.

Title slug: `runtime-secret-reservation-materialization`
