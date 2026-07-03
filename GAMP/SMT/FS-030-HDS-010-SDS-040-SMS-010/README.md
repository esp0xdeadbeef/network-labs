# FS-030-HDS-010-SDS-040-SMS-010 SMT

Row-local construction-only documentation anchor for the compiler platform independence contract module.

**Trace**: FS-030-HDS-010-SDS-040-SMS-010
**Purpose**: Guarantee compiled output is platform-independent — refuse renderer-specific, deployment-platform-specific, or vendor-specific concepts in compiler output; reject intent fields selecting specific renderers or technologies.

## Construction Evidence

The authoritative construction test lives in `network-compiler`:
`tests/test-FS-030-HDS-010-SDS-040-SMS-010.sh`

Per the SMS Construction Handoff (GAMP/SMS/FS-030-HDS-010-SDS-040-SMS-010-platform-independence-contract.md):
- Refuses intent payload fields carrying downstream side-channel material or realization technology selectors
- Rejects intent fields selecting specific renderers or deployment platforms
- Keeps compiler output free of host uplink assignments, bridge names, VLAN IDs, container runtime names, renderer-specific syntax
- Diagnoses and rejects any compiler output field leaking platform-specific identifiers

## Evidence Boundary

Construction-only — all predicates are provable via unit tests in the compiler repo. Live
host checks may confirm pinned artifact trace presence, but they are not the evidence
authority for the platform-independence predicate.

## Status

SMT row: OK.

2026-07-03 evidence:
- `network-compiler` commit `2096e1a` implements the platform-independence gate.
- `NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-FS-030-HDS-010-SDS-040-SMS-010.sh` PASS.
- `NETWORK_REPO_DIRECT_TEST_OK=1 TEST_ASYNC_JOBS=4 bash run-all-tests.sh` PASS, 50/50 tests.
- Shutdown-loop live artifact sanity evidence:
  `/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-040-SMS-010/20260703T222816Z`
  and `/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-040-SMS-010/20260703T222918Z`
  PASS. Both NixOS and CLAB artifacts contained the full trace ID and five
  expected runtime targets; test-clients contained zero runtime targets.

This is SMT construction evidence only and does not promote SIT/HAT/SAT.
