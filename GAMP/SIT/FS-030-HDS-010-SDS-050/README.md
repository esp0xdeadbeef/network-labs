# FS-030-HDS-010-SDS-050 SIT

Status: PENDING LIVE REVALIDATION.

This SDS-scoped SIT row consumes the child SMS
`FS-030-HDS-010-SDS-050-SMS-010`. The child row is registered as an
`intent-source` mini-SMT and has current compiler construction evidence.

The remaining SIT evidence is integrated active-lab proof from the shutdown
loop: pinned NixOS and CLAB artifacts must contain the full trace ID and the
five expected runtime targets, while `s-router-test-clients` must contain zero
runtime targets for this row.
