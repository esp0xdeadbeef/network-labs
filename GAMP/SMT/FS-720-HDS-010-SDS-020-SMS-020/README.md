# FS-720-HDS-010-SDS-020-SMS-020 SMT

Row-local source for the mini endpoint harness consumption SMT.

Tests the s-router-test-clients harness consumption of endpoint fixtures from
source-classified CPM endpointAssignment contracts. Proves that endpoint
fixtures are consumed only from SMS-010 source-classified records, not from
scripts, renderer defaults, or runtime discovery.

Run:

```bash
tests/run-active-lab-mini-smt.sh --source endpoint-harness-consumption
tests/run-active-lab-mini-smt.sh endpoint-harness-consumption
```

This row starts `client-edge`, `printer-edge`, and `receiver-edge` runtime targets
representing test client endpoint fixtures with static and DHCP address assignment.
The parent SIT row `GAMP/SIT/FS-720-HDS-010-SDS-020/default.nix` consumes this SMS
input together with the sibling `FS-720-HDS-010-SDS-020-SMS-010` endpoint-inventory-source input.
