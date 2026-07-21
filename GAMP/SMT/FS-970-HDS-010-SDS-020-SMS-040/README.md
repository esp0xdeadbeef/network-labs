# SMT: FS-970-HDS-010-SDS-020-SMS-040

Canonical SMS:
`network-codex-agent/GAMP/SMS/FS-970-HDS-010-SDS-020-SMS-040-runtime-secret-reservation-materialization.md`

Status: OK at the isolated SMT/SIT boundary.

This row supplies one real NixOS reservation probe on lab VLAN397 and one real
CLAB reservation probe on lab VLAN398. Both run on
`s-router-test-clients`. Public inventory declares only the served scope and an
opaque protected-source reference. Each complete record—including private
hostname, MAC, stable IPv6 IID, DUID/IAID, and reserved addresses—remains in the
row-owned encrypted SOPS source.

The accepted protocol had two distinct boots:

1. Start the real clients, privately observe their MAC, DUID, IAID, stable
   non-temporary IPv6 address, and IID, and write only mode-`0600` enrollment
   files with the redacted capture helper.
2. Push every owning `network-*` revision, shut down all three lab guests
   together, observe all three offline, and start them from the exact staged
   source. Accept only new boot IDs, new guest closures, exact pins and hashes,
   zero failed units, and an active declarative CLAB render.
3. Compare the protected SOPS/runtime record and current client observations
   internally. Emit only redacted predicates.

The accepted 2026-07-21 run returned:

```text
FS970_STAGING=PASS hosts=3 cold_start=yes guest_system=changed source_hashes=exact pins=exact
FS970_INTEGRATION=PASS substrates=nixos,clab client=s-router-test-clients
OK FS-970-HDS-010-SDS-020
```

The final restage selected `network-labs` revision `465123b4b5fc` and common
`network-renderer-nebula` revision `94f2d80a908d` from the pushed root lock.

Both substrates exposed real UDP 67/547 services, delivered the secret
read-only with mode `0400`, materialized equivalent Kea reservations only at
runtime, and gave the same clients exactly one predictable IPv4 and one
predictable IPv6 address. The enrolled MAC, DUID, IAID, and IID remained stable
across the clean stage. Public source, diagnostics, and build templates did not
contain protected record values, and no host-profile overwrite modified the
renderer output.

The construction negative also proves that a node with an unrelated protected
routed-prefix bind and no served DHCP scope receives neither a Kea lifecycle
label nor a reconciliation attempt. The live run used the corrected pushed
renderer and did not add a runtime repair.

This is SMT/SIT evidence for isolated lab clients only. It is not HAT, SAT, or
production evidence, and it does not authorize testing on VLAN2 or a production
network.

Title slug: `runtime-secret-reservation-materialization`
