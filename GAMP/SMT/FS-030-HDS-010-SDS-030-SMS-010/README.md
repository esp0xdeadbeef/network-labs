# FS-030-HDS-010-SDS-030-SMS-010 SMT

Row-local construction-only documentation anchor for the compiler overlay-underlay separation module.

**Trace**: FS-030-HDS-010-SDS-030-SMS-010
**Purpose**: Enforce separation between overlay underlay/control traffic and overlay payload traffic as distinct policy relations with separate paths and p2pIsolationKey, preventing collapse into a single relation.

## Construction Evidence

The authoritative construction test lives in `network-compiler`:
`tests/test-fs030-hds010-sds030-sms010-compiler-boundary.sh`

Per the SMS Construction Handoff (GAMP/SMS/FS-030-HDS-010-SDS-030-SMS-010-overlay-underlay-separation.md):
- Models each overlay leg as separate communication contract relation with own `p2pIsolationKey`
- Keeps Nebula/WireGuard underlay/control traffic distinct from payload traffic
- Requires explicit `transport.overlays[].underlayAccess` declarations
- Fails if selected underlay tenant lacks egress to underlay target external
- Emits `forbidsCoreToCoreP2P = true` on traffic paths
- Each overlay path carries overlay identity and explicit peer-site identity

## Evidence Boundary

Construction-only — all predicates are provable via unit tests in the compiler repo. No live host or runtime surface needed.

## Status

SMT row: NOT OK (construction test exists and passes at HEAD per SMT evidence column; status not yet flipped).

This is SMT construction evidence only and does not promote SIT/HAT/SAT.
