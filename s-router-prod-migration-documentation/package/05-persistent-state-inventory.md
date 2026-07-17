# Persistent-State Inventory and State-Schema Migration Map

Trace: FS-950-HDS-010-SDS-010-SMS-050

Only durable modeled state that must survive is migrated, using
FS-860 and FS-880 contracts. Derived network/rendered configuration
(generated routes, nftables, networkd, renderer output, Nix store
paths, VM images, runtime process state) is regenerated from the
target pins and never migrated as authoritative data.

## kea-lease-state-per-vlan

- contentClass: `durable-modeled-state (DHCP lease database, memfile)`
- sourcePathClass: `/var/lib/kea/<vlan>.leases under systemd StateDirectory=kea`
- targetPathClass: `/var/lib/kea/<vlan>.leases under systemd StateDirectory=kea (retained; no schema conversion approved)`
- ownerMode: `kea:kea 0640 (directory 0750)`
- backupArtifact: `offline-export/kea-leases-<vlan>.tar (user-copied into the declared offline-export root by a separately authorized maintenance operation)`
- checksum: `sha256 recorded per exported lease file in the provenance manifest of the declared offline-export root`
- conversionProcedure: `none — retain memfile schema and StateDirectory=kea semantics per FS-860/FS-880; a schema conversion requires separate approval`
- validationPredicate: `each exported lease file parses as Kea memfile CSV and every lease belongs to the declared per-VLAN namespace (FS-880-HDS-010-SDS-010-SMS-010 lease namespace owner scope)`
- rollbackSource: `offline-export/kea-leases-<vlan>.tar restored to the identical path class`
- idempotenceKey: `kea-leases-per-vlan-memfile-v1`

## kea-reservation-overrides

- contentClass: `durable-modeled-state (reservation overrides binding runtime secret material)`
- sourcePathClass: `/persist/kea/reservation-overrides (protected reference store)`
- targetPathClass: `/persist/kea/reservation-overrides (retained as protected references)`
- ownerMode: `root:root 0600`
- backupArtifact: `offline-export/kea-reservation-overrides.redacted.json (references only; plaintext never exported)`
- checksum: `sha256 recorded for the redacted reference file in the provenance manifest`
- conversionProcedure: `none — reservation overrides remain protected references per SMS MR5; plaintext is never copied into the package`
- validationPredicate: `every reservation entry resolves to a secret:// reference and no plaintext secret material appears in the exported artifact`
- rollbackSource: `offline-export/kea-reservation-overrides.redacted.json plus the untouched protected reference store`
- idempotenceKey: `kea-reservation-overrides-refs-v1`

## nebula-secret-material

- contentClass: `durable-secret-references (Nebula CA/host credentials)`
- sourcePathClass: `/persist/nebula (protected secret store, referenced only)`
- targetPathClass: `/persist/nebula (retained; never migrated in plaintext)`
- ownerMode: `root:root 0600`
- backupArtifact: `offline-export/nebula-secret-references.json (references only)`
- checksum: `sha256 recorded for the reference file in the provenance manifest`
- conversionProcedure: `none — Nebula secret material remains a protected reference per SMS MR5`
- validationPredicate: `reference file contains only secret:// references and preserves the secret-reference set required by the Nebula public-ingress hotpatch`
- rollbackSource: `offline-export/nebula-secret-references.json plus the untouched protected secret store`
- idempotenceKey: `nebula-secret-references-v1`

## qemu-vm-contract-declaration

- contentClass: `regenerated-contract (recorded for parity only; not migrated as authoritative data)`
- sourcePathClass: `versioned nixos repo QEMU contract for s-router-prod (mkForce retained; single vmbr4 NIC, no default user networking)`
- targetPathClass: `regenerated from target pins with identical QEMU contract semantics (mkForce retained)`
- ownerMode: `not-applicable (declarative contract, regenerated from pins)`
- backupArtifact: `versioned repo history of the QEMU contract declaration`
- checksum: `git revision hash of the versioned QEMU contract declaration`
- conversionProcedure: `regenerate from target pins; never copy generated VM images or runtime process state`
- validationPredicate: `regenerated QEMU contract keeps NIC cardinality (exactly one vmbr4 NIC) and adds no default user networking`
- rollbackSource: `versioned repo history at the source pin revision`
- idempotenceKey: `qemu-contract-parity-v1`

