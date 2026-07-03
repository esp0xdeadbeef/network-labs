# FS-380-HDS-020-SDS-010-SMS-120 SMT

Row-local source for prod-like IPv4 egress over the routed selector chain.

This row models the `s-router-prod` IPv4 shape without PPPoE:

`access-vlan2 -> downstream-selector -> policy -> upstream-selector -> core`

The client tenant uses lab-only `10.38.120.0/24`, the router access gateway is
`10.38.120.1`, the test endpoint is `10.38.120.10`, and `core` exits through
the emulated upstream `internet-vlan4` on VLAN4 with private NAT44.

`s-router-test-clients` is part of this row. It receives a real endpoint
container on the shared VLAN-backed `client` bridge so live checks can prove a
client-originated packet path instead of a router self-source probe.

Run:

```bash
tests/run-active-lab-mini-smt.sh FS-380-HDS-020-SDS-010-SMS-120
```
