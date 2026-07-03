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
tests/run-active-lab-mini-smt.sh --source FS-030-HDS-010-SDS-030-SMS-010
```

This row may start at most 5 runtime targets.

## Status

SMT row: OK - row-local mini-SMT source with compiler construction evidence.

This is SMT construction evidence only and does not promote SIT/HAT/SAT.
