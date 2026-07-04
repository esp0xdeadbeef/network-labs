# FS-030-HDS-010-SDS-030-SMS-010 SMT

Row-local mini-SMT source for the compiler overlay-underlay separation module.

**Trace**: FS-030-HDS-010-SDS-030-SMS-010
**Purpose**: Enforce separation between overlay underlay/control traffic and overlay payload traffic as distinct policy relations with separate paths and p2pIsolationKey, preventing collapse into a single relation.

## Construction Evidence

The authoritative construction test lives in `network-compiler`:
`tests/test-FS-030-HDS-010-SDS-030-SMS-010.sh`

Per the SMS Construction Handoff (GAMP/SMS/FS-030-HDS-010-SDS-030-SMS-010-overlay-underlay-separation.md):
- Models each overlay leg as separate communication contract relation with own `p2pIsolationKey`
- Keeps Nebula/WireGuard underlay/control traffic distinct from payload traffic
- Requires explicit `transport.overlays[].underlayAccess` declarations
- Fails if selected underlay tenant lacks egress to underlay target external
- Emits `forbidsCoreToCoreP2P = true` on traffic paths
- Each overlay path carries overlay identity and explicit peer-site identity

## Active-Lab Source

Run:

```bash
MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-030-HDS-010-SDS-030-SMS-010
```

This row may start at most 6 runtime targets: client-edge,
downstream-selector, policy, upstream-selector, overlay-core, and testnet-edge.
Its row intent includes three explicit relation IDs: overlay payload,
overlay underlay/control, and client underlay-access egress to the testnet
external. The third relation is required so `underlayAccess` has modeled WAN
egress instead of borrowing authority from inventory or renderer behavior.

## Status

SMT row: OK - row-local mini-SMT source with compiler construction evidence,
overlay-real runtime source predicates, live NixOS and CLAB runtime
enumeration, and pinned `s-router-nixos` build evidence.

Current evidence, 2026-07-04:

- Direct live wrapper:
  `/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-030-SMS-010/20260704T051250Z`
- Mini-SMT runner wrapper log:
  `/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-030-SMS-010/20260704T051319Z`
- Mini-SMT run root:
  `/tmp/active-lab-mini-smt-runs/20260704T051312Z-2891933/FS-030-HDS-010-SDS-030-SMS-010`
- Offline verifier status: skipped by `MINI_SMT_OFFLINE_VERIFY=0`.
- Runtime targets: six on `s-router-nixos`, six on `s-router-clab`, zero on
  `s-router-test-clients`.

This is SMT construction evidence only and does not promote SIT/HAT/SAT.
