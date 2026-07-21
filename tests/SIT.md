# SIT Validation Stub Index

This file reserves the System Integration Testing index for `network-labs`.
It is a stub, not validation evidence.

SIT rows belong here when a locked source and artifact chain can be checked
across integration boundaries, for example:

- controlled SAT source import from `GAMP/SAT/`;
- compiler output consumed by NFM;
- NFM output consumed by CPM;
- CPM output consumed by renderer artifacts;
- artifact provenance that binds the generated output back to the source paths.

## Current Rows

| SIT ID | SOURCE | TEST SCRIPT | WHAT IT WILL PROVE | STATUS |
| --- | --- | --- | --- | --- |
| `FS-800-HDS-010-SDS-020-SMS-040` | `GAMP/SMT/FS-800-HDS-010-SDS-020-SMS-040/intent.nix` plus the staged `s-router-nixos` and `s-router-clab` provider-handoff containers | `../network-codex-agent/scripts/live-FS-800-HDS-010-SDS-020-SMS-040.sh --live` | The provider-handoff default route stays on the modeled fabric path, while the separate PPPoE-side core keeps its default route on its uplink. | `OK` for the recorded isolated-lab stage; rerun the canonical live entrypoint after any source or lock change. |
| `LAB-SIT-STUB-001` | `GAMP/SAT` and generated model artifacts | not implemented | Locked source-to-artifact integration evidence will be indexed here after a focused SIT command exists. | Stub only; no SIT `OK` claim. |

## Promotion Rule

Do not promote SMT examples, HAT fixture checks, or SAT source documents to SIT
evidence. A SIT row needs an executable integration command plus exact source
and artifact paths.
