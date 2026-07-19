# FS-560-HDS-010-SDS-010 SIT Integration

SIT integration container for FS-560-HDS-010-SDS-010 SMS-040, SMS-050 and sibling traces.

**Evidence Boundary:** SMS-040 construction-only; SMS-050 isolated live
NixOS/CLAB protected-name publication after a three-host cold stage.

Integrates SMS-040 and SMS-050 with sibling SMS atom traces.

SMS-050 stays `NOT OK` until
`network-codex-agent/tests/test-sit-FS-560-HDS-010-SDS-010-protected-name-publication-live.sh`
accepts new boot IDs and guest closures, exact staged source hashes and pushed
pins on all three isolated hosts, zero failed units, and both NixOS and CLAB
runtime predicates. Directly activating a closure or changing a running
namespace does not satisfy this boundary.
