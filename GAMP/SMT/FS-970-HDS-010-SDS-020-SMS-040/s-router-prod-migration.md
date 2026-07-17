# s-router-prod Protected Reservation Migration

This note describes how to replace the local VLAN2 and VLAN3 Kea reservation
overrides in `s-router-prod` with the protected runtime-source contract proven
by `FS-970-HDS-010-SDS-020-SMS-040`. It is an operator migration record, not a
module specification and not production activation authorization.

## Privacy boundary

The complete reservation records remain protected. This includes each opaque
record handle, private hostname or serial-bearing name, MAC address, reserved
IPv4 address, and every mapping between those fields. Public inventory carries
only the served scope and these opaque runtime paths:

- `/run/secrets/s-router-prod-vlan2-reservations.json`
- `/run/secrets/s-router-prod-vlan3-reservations.json`

The corresponding repository files are SOPS binary envelopes:

- `secrets/s-router-prod-vlan2-reservations.json.age`
- `secrets/s-router-prod-vlan3-reservations.json.age`

No plaintext conversion file may be created in a repository or Nix store. Kea
must see the protected addresses and identities in its runtime-local config to
serve the reservations; the privacy guarantee is that this necessary service
input is delivered after evaluation inside the target runtime boundary, with
mode `0600`, and is not published through inventory, build output, diagnostics,
or logs.

## Required network stack

The migration requires at least these owning-layer revisions:

- `network-control-plane-model` `ad284acb58627f3bcb74d6ec423742c571651c57`
  for an opaque protected reservation-set source on the served advertisement;
- `network-renderer-nixos` `1ea9d7bad189b7a5db490cf44f81fc5cf45985f3`
  for read-only runtime delivery, redacted materialization, and mixed in-pool
  and out-of-pool Kea reservation allocation.

The `*-prod` flake inputs and lock nodes must resolve to those revisions or a
reviewed descendant containing the same contract. Do not migrate only one side
of the CPM-to-renderer interface.

## Source conversion

Perform conversion only on an authorized target or workstation that can read
the existing runtime secrets and write the new SOPS recipients. Use a private
mode-`0700` temporary directory with a cleanup trap.

1. Read the existing VLAN2 Kea reservation set and the existing VLAN3 protected
   MAC source without printing either value.
2. For each VLAN2 record, create one protected record containing an opaque ID,
   scope `vlan2`, the existing IPv4 address and MAC address, and the existing
   hostname when present.
3. Create the VLAN3 protected record with an opaque ID, scope `vlan3`, its
   existing modeled reservation address, the existing protected MAC address,
   and its private hostname.
4. Reject unknown fields, invalid MAC or address syntax, wrong scope, addresses
   outside the served subnet, and duplicate IDs, identities, addresses, or
   hostnames.
5. Encrypt each validated JSON list directly as a SOPS binary envelope for the
   repository recipients. Remove all plaintext temporary files before leaving
   the conversion boundary.
6. On `s-router-prod`, decrypt the candidate envelopes in a fresh private
   temporary directory and compare normalized protected records to the existing
   runtime sources. Emit only equality results and counts, never field values.

The 2026-07-17 conversion and non-activating preflight proved exact source
parity for 48 VLAN2 records and one VLAN3 record. Both candidate envelopes were
decryptable by the production host key; no plaintext values were emitted.

## NixOS profile change

The target profile must:

- declare both SOPS binary envelopes at the exact `/run/secrets/...` paths;
- set only `reservationSource.sourceFile` on the public VLAN2 and VLAN3 served
  advertisements;
- bind-mount each source read-only into its access container;
- use the renderer-owned runtime materializer as the sole Kea reservation
  writer;
- remove `vlan2-kea-reservations-override.nix` and
  `vlan3-kea-reservations-override.nix`; and
- retain private VLAN2 A/PTR parity through a separate runtime-only Unbound
  generator that consumes the same protected source, rather than coupling DNS
  parity to a Kea post-render hook.

The profile contract must fail evaluation if either protected source, renderer
materializer, read-only mount, or no-override invariant is absent.

## Preflight and promotion gates

Before activation:

1. Confirm both current production secret sources are readable, without
   displaying their contents.
2. Back up the active system profile, current encrypted sources, Kea lease
   state, and private DNS runtime data. Record checksums in protected operator
   evidence.
3. Evaluate `nixosConfigurations.s-router-prod` and require exactly two opaque
   reservation-source references, two renderer materializers, two read-only
   source mounts, and zero reservation post-render overrides.
4. Build the complete `s-router-prod` system closure.
5. In a temporary directory on the production host, decrypt and materialize
   both candidate sources with the built renderer. Require source-to-output
   parity, mode `0600`, explicit in-subnet lookup, derived out-of-pool lookup,
   and successful parsing by the production `kea-dhcp4 -t` executable.
6. Confirm that public source, evaluation output, Nix-store Kea templates,
   diagnostics, and logs contain none of the protected record values.
7. Obtain explicit production activation and reboot authorization. A successful
   preflight does not grant it.

The 2026-07-17 preflight passed profile evaluation, the full system build, exact
runtime materialization for both scopes, file-mode checks, and Kea 3.0.3 parser
validation. It did not activate or reboot `s-router-prod`.

## Post-activation acceptance

After authorized activation, run scopes independently before declaring the
migration complete:

- verify both generator units succeed and the Kea services remain active;
- compare runtime reservations to the protected sources using redacted equality
  predicates;
- renew representative VLAN2 and VLAN3 clients and require their predictable
  reserved IPv4 addresses;
- resolve representative private VLAN2 forward and reverse names locally;
- verify dynamic clients still lease from the modeled pools;
- verify no new public or Nix-store disclosure surface exists; and
- run the complete post-reboot `s-router` regression loop required by the
  production cutover process.

## Abort and rollback

Abort before activation if decryption, normalized parity, evaluation, build,
materialization, Kea parsing, redaction, backup, or authorization fails. Do not
repair a protected record by copying its values into public inventory or a
host-local Nix override.

If post-activation acceptance fails, roll back atomically to the backed-up
system profile and encrypted source set, restore lease and private DNS state
when their checksums changed, restart the former services, and re-run the
pre-migration client checks. Preserve only redacted failure classes in public
evidence; investigate protected values inside the authorized operator boundary.
