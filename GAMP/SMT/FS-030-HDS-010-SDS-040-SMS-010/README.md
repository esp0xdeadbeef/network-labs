# FS-030-HDS-010-SDS-040-SMS-010 SMT

Row-local construction-only documentation anchor for the compiler platform independence contract module.

**Trace**: FS-030-HDS-010-SDS-040-SMS-010
**Purpose**: Guarantee compiled output is platform-independent — refuse renderer-specific, deployment-platform-specific, or vendor-specific concepts in compiler output; reject intent fields selecting specific renderers or technologies.

## Construction Evidence

The authoritative construction test lives in `network-compiler`:
`tests/test-fs030-hds010-sds040-sms010-compiler-boundary.sh`

Per the SMS Construction Handoff (GAMP/SMS/FS-030-HDS-010-SDS-040-SMS-010-platform-independence-contract.md):
- Refuses intent payload fields carrying downstream side-channel material or realization technology selectors
- Rejects intent fields selecting specific renderers or deployment platforms
- Keeps compiler output free of host uplink assignments, bridge names, VLAN IDs, container runtime names, renderer-specific syntax
- Diagnoses and rejects any compiler output field leaking platform-specific identifiers

## Evidence Boundary

Construction-only — all predicates are provable via unit tests in the compiler repo. No live host or runtime surface needed.

## Status

SMT row: NOT OK (construction test exists and passes at HEAD per SMT evidence column; status not yet flipped).

This is SMT construction evidence only and does not promote SIT/HAT/SAT.
