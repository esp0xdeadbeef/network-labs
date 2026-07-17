# SMT: FS-970-HDS-010-SDS-020-SMS-040

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-970-HDS-010-SDS-020-SMS-040-runtime-secret-reservation-materialization.md`

Status: OK - the same protected-reservation predicate passed live on NixOS and
CLAB after a controlled cold stage.

This row creates one opaque dual-stack DHCP client on `s-router-test-clients`
and connects it to the matching access scope on `s-router-nixos` through the
lab-only VLAN 397. The client identifiers were observed on that interface, the
complete record was delivered through SOPS, and the same client received its
reserved IPv4 and IPv6 addresses after a clean rebuild.

Enrollment recorded the real client interface identity and the complete record
is present only in the row-owned encrypted SOPS source. The final live run
proved that the enrolled MAC, link-layer DUID, IAID, and IID remained stable
across clean client rebuilds. It also proved one exact reserved IPv4 address
and one exact reserved IPv6 `/128` on `reservation-probe`, with no additional
global addresses.

The first post-enrollment rebuild was correctly rejected: the test client's
default vendor DUID changed with its ephemeral container machine identity.
IPv4 remained reserved by the stable MAC, while DHCPv6 could not match the old
DUID. The endpoint renderer now requests a link-layer DUID, and the protected
record was re-enrolled from that real client interface before the successful
rebuild comparison.

The final locked chain additionally reconciles CLAB Kea after Containerlab has
installed the definitive interface, requires real UDP 67/547 sockets, requests
stateful DHCPv6 with a link-layer DUID, and disables temporary IPv6 addresses
for the deterministic reservation probes.

The redacted live verifier proved:

- decrypted SOPS source equals the runtime record, with mode `0400` and a
  read-only container bind mount;
- one runtime DHCPv4 reservation and one runtime DHCPv6 reservation contain
  the protected hostname and enrolled identity only after secret delivery;
- current MAC, DUID, IAID, and IID equal the pre-rebuild enrollment evidence;
- exact predictable IPv4 and IPv6 leases are installed on the same client; and
- protected values are absent from public row/SMS source and both Nix-store
  Kea configuration templates.

The controlled verifier is
`network-codex-agent/scripts/smt-live-FS-970-HDS-010-SDS-020-SMS-040.sh`.
It requires the two protected pre-rebuild enrollment observations as explicit
inputs and fails closed with redacted check names when they are absent.

Public source intentionally contains no per-client reservation handle,
hostname, MAC, IID, DUID, IAID, or reserved address. Those values belong only
to the protected runtime source and redacted live evidence.

The production migration procedure derived from this row is documented in
[`s-router-prod-migration.md`](./s-router-prod-migration.md). It keeps all
reservation records encrypted at rest and materializes them only within the
target runtime boundary.

The row also defines `s-router-clab` on isolated VLAN 398 with a separate
`reservation-probe-clab` and encrypted source. Its real MAC, link-layer DUID,
IAID and IID were enrolled from that interface; after the cold rebuild it
passed the same exact IPv4/IPv6 lease and redaction predicates as the NixOS
branch on VLAN 397.

Title slug: `runtime-secret-reservation-materialization`
