# FS-030-HDS-010-SDS-050 SIT

Status: OK.

This SDS-scoped SIT row consumes the child SMS
`FS-030-HDS-010-SDS-050-SMS-010`. The child row is registered as an
`intent-source` mini-SMT and has current compiler construction evidence.

Integrated active-lab evidence from the shutdown loop passed on 2026-07-04:
pinned NixOS and CLAB artifacts contain the full trace ID and the five expected
runtime targets, while `s-router-test-clients` contains zero runtime targets for
this row.

Evidence directories:
- `/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-050-SMS-010/20260703T230438Z`
- `/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-050-SMS-010/20260703T230541Z`
