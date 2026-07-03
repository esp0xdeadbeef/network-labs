# FS-380-HDS-020-SDS-010-SMS-120

Template row for prod-like IPv4 client egress over VLAN4.

The SMT source is
`GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-120/`. It models the production-style
five-node router chain with a real `s-router-test-clients` endpoint and an
emulated VLAN4 upstream, avoiding PPPoE so IPv4 forwarding and NAT can be
tested when the real ISP handoff is unavailable.
