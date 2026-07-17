# SMT: FS-970-HDS-010-SDS-020-SMS-040

Canonical SMS: `network-codex-agent/GAMP/SMS/FS-970-HDS-010-SDS-020-SMS-040-runtime-secret-reservation-materialization.md`

Status: OK - SOPS-backed dual-stack reservation proven after clean rebuild.

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

The live recovery also exposed four independent NixOS renderer defects before
the row could pass: Kea startup raced interface readiness, modeled DHCP ingress
was absent from the container firewall, out-of-pool protected reservations were
not enabled, and the DHCPv6 subnet was not bound to its link-local-only access
interface. The final locked renderer commit `7e7758e2` includes those
recoveries; the endpoint identity fix is `2e144e5d`, the protected model
contract is `ad284acb`, and this protected enrollment source is `05df957a`.

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

Title slug: `runtime-secret-reservation-materialization`
