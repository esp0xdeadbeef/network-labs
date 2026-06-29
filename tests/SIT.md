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
| `FS-800-HDS-010-SDS-020-SMS-040` | `GAMP/SMT/FS-800-HDS-010-SDS-020-SMS-040/intent.nix` plus active `s-router-nixos` and `s-router-clab` provider-handoff containers | `tests/FS-800-HDS-010-SDS-020-SIT-live-provider-access-default-route.sh` | Provider-handoff PPPoE sessions must route default/public egress from the PPP session address through live `ppp0`, not through fabric `ens*`. | NOT OK live on 2026-06-29; all four active-lab provider-handoff targets have PPP session addresses, but default and `ip route get 1.1.1.1 from <ppp-address>` select `ens21` via `10.10.44.50/52` or `10.50.44.50/52` instead of `ppp0`. |
| `LAB-SIT-STUB-001` | `GAMP/SAT` and generated model artifacts | not implemented | Locked source-to-artifact integration evidence will be indexed here after a focused SIT command exists. | Stub only; no SIT `OK` claim. |

## Promotion Rule

Do not promote SMT examples, HAT fixture checks, or SAT source documents to SIT
evidence. A SIT row needs an executable integration command plus exact source
and artifact paths.
