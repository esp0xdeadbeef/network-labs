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
| `LAB-SIT-STUB-001` | `GAMP/SAT` and generated model artifacts | not implemented | Locked source-to-artifact integration evidence will be indexed here after a focused SIT command exists. | Stub only; no SIT `OK` claim. |

## Promotion Rule

Do not promote SMT examples, HAT fixture checks, or SAT source documents to SIT
evidence. A SIT row needs an executable integration command plus exact source
and artifact paths.
