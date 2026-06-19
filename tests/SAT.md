# SAT Validation Stub Index

This file reserves the Site Acceptance Testing index for `network-labs`. It is
a stub, not acceptance evidence.

SAT rows belong here only after controlled execution consumes the locked source
under `GAMP/SAT/` and records live runtime evidence from the owning harness or
site context.

## Current Rows

| SAT ID | SOURCE | TEST SCRIPT | WHAT IT WILL PROVE | STATUS |
| --- | --- | --- | --- | --- |
| `LAB-SAT-STUB-001` | `GAMP/SAT` | not implemented | Controlled SAT evidence will be indexed here after live execution records command, locked source, runtime context, artifacts, and observed results. | Stub only; no SAT `OK` claim. |

## Live Evidence Rule

SAT may cite SMT, SIT, and HAT results as inputs, but no parser check, source
contract, renderer output, or fixture preparation row is SAT evidence by
itself.

For on-prem hosts, everything except Hetzner-hosted surfaces must have `eth0.2`
configured for DHCP on the host before live SAT execution.
