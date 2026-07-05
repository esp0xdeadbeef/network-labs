# FS-030-HDS-010-SDS-040-SMS-010 SMT

Row-local mini-SMT source for the compiler platform independence contract module.

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

## Active-Lab Source

Run:

```bash
MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-030-HDS-010-SDS-040-SMS-010
```

This row may start at most 5 runtime targets: client-edge,
downstream-selector, policy, upstream-selector, and core-vlan4-client-dhcp-slaac. The runtime
checks prove that both NixOS and Containerlab can consume the same
platform-independent source without renderer-specific intent fields. The
compiler construction test remains the authority for platform-independence
predicates.

## Status

SMT row: OK - row-local mini-SMT source with compiler construction evidence,
live NixOS and CLAB runtime enumeration, and pinned `s-router-nixos` build
evidence.

Current evidence, 2026-07-04:

- Direct live wrapper:
  `/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-040-SMS-010/20260704T053321Z`
- Mini-SMT runner wrapper log:
  `/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-040-SMS-010/20260704T053649Z`
- Mini-SMT run root:
  `/tmp/active-lab-mini-smt-runs/20260704T053642Z-2913672/FS-030-HDS-010-SDS-040-SMS-010`
- Offline verifier status: skipped by `MINI_SMT_OFFLINE_VERIFY=0`.
- Runtime targets: five on `s-router-nixos`, five on `s-router-clab`, zero on
  `s-router-test-clients`.

This is SMT row evidence with live mini-SMT runtime enumeration. SIT evidence is
recorded under `GAMP/SIT/FS-030-HDS-010-SDS-040`; this row does not promote HAT
or SAT.
