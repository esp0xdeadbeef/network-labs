# FS-370-HDS-010-SDS-010-SMS-050 SMT

Row-local source for the mini lane egress binding SMT.

Tests CPM forwardingIntent lane emission with correct uplink annotations:
tenant client → external testnet uplink path with `lane.kind: "access-uplink"` and non-null `lane.uplink`.

Run:

```bash
tests/run-active-lab-mini-smt.sh lane-egress-binding
```

This row starts `client-edge` and `testnet-edge` runtime targets.
