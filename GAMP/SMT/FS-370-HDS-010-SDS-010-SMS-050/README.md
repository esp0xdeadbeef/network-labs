# FS-370-HDS-010-SDS-010-SMS-050 SMT

Row-local source for the mini lane egress binding SMT.

Tests CPM forwardingIntent lane emission with correct uplink annotations:
tenant client → external testnet uplink path with `lane.kind: "access-uplink"` and non-null `lane.uplink`.

Run:

```bash
tests/run-active-lab-mini-smt.sh FS-370-HDS-010-SDS-010-SMS-050
```

This row declares the five-target lane path that the active-lab selector must
realize: `client-edge`, `downstream-selector`, `policy`, `upstream-selector`,
and `core-vlan4-client-dhcp-slaac`.
