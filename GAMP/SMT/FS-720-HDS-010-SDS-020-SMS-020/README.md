# FS-720-HDS-010-SDS-020-SMS-020 SMT

Row-local source for the mini endpoint harness consumption SMT.

Tests the s-router-test-clients harness consumption of endpoint fixtures from
source-classified CPM endpointAssignment contracts. Proves that endpoint
fixtures are consumed only from SMS-010 source-classified records, not from
scripts, renderer defaults, or runtime discovery.

Status: NOT OK - prepared source only. The `endpoint-harness-consumption` ID is
not registered in `GAMP/SMT/mini-smt/tests.nix`, and no executable focused
mini-SMT script exists for it yet.

This row starts `client-edge`, `printer-edge`, and `receiver-edge` runtime targets
representing test client endpoint fixtures with static and DHCP address assignment.
The parent SIT row `GAMP/SIT/FS-720-HDS-010-SDS-020/default.nix` keeps this SMS
input visible as prepared source material until a manifest entry and focused
runner are added.
