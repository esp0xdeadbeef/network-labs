# FS-030-HDS-010-SDS-010-SMS-010 SMT

Row-local construction-only documentation anchor for the compiler intent-authority boundary module.

**Trace**: FS-030-HDS-010-SDS-010-SMS-010
**Purpose**: Reject non-intent source material (realization-only provider metadata, technology selectors like DHCP/PPP/PPPoE) before it enters the compiler behavior model.

## Construction Evidence

The authoritative construction test lives in `network-compiler`:
`tests/test_intent_authority_boundary.py`

Per the SMS Construction Handoff (GAMP/SMS/FS-030-HDS-010-SDS-010-SMS-010-intent-authority-boundary.md):
1. Feeds intent input containing downstream side-channel keys and proves rejection
2. Feeds intent input containing realization technology selectors and proves rejection with diagnostics
3. Feeds clean intent-only input and proves behavior model is accepted

## SMS Predicates

- **MR**: Consume declared user-intent input, reject non-intent payload fields, permit only intent-classified fields
- **FC**: Intent input contains downstream side-channel keys, realization technology selectors, or behavior-model field emitted from rejected material
- **SN**: Intent payload with `realizationProvider: "pppoe"` and `accessMetadata: {vlan: 100}` → rejected before behavior-model emission; clean re-parse with intent-only fields succeeds

## Evidence Boundary

Construction-only — all predicates are provable via unit tests in the compiler repo. No live host or runtime surface needed.

## Status

SMT row: NOT OK (evidence accepted but status not yet flipped; test exists and passes at HEAD per SMT evidence column).

This is SMT construction evidence only and does not promote SIT/HAT/SAT.
