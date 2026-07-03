# FS-540-HDS-010-SDS-010-SMS-045 SMT

Row-local source for prod-like recursive DNS over the routed selector chain.

This row models the `s-router-prod` IPv4 shape without PPPoE:

`access-vlan2 -> downstream-selector -> policy -> upstream-selector -> core`

The client tenant uses lab-only `10.54.45.0/24`, the router access gateway is
`10.54.45.1`, the NixOS test endpoint is `10.54.45.10`, and `core` exits
through the emulated upstream `internet-vlan4` on VLAN4 with private NAT44.

`s-router-test-clients` is part of this row. It receives a real endpoint
container on the VLAN-backed `dnsclient` bridge so live checks can prove a
client-originated DNS query instead of a router self-source probe. The CLAB
realization uses the separate `dnsclab` bridge on VLAN305 so both router
surfaces can run at the same time without duplicate ARP ownership for
`10.54.45.1` on one L2 segment.

Run:

```bash
tests/run-active-lab-mini-smt.sh FS-540-HDS-010-SDS-010-SMS-045
```

Executed evidence:

- 2026-07-03 locked active-lab full loop passed with
  `S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-540-HDS-010-SDS-010-SMS-045`.
- Evidence directory:
  `/tmp/s-router-live-smoke/FS-540-HDS-010-SDS-010-SMS-045/20260703T200952Z`.
- Manual enumeration proved both `prod-like-dns-client01` and
  `prod-like-dns-clab-client01` use `10.54.45.1` as gateway and resolver,
  resolve `cache.nixos.org`, and trace through
  `access-vlan2 -> downstream-selector -> policy -> upstream-selector -> core`.
