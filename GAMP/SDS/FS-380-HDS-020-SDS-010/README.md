# FS-380-HDS-020-SDS-010

SDS template row for the mini internet mode verification POC.

This row currently maps:

- `FS-380-HDS-020-SDS-010-SMS-050` for SMT/SIT-only internet mode verification
  through an emulated PPPoE provider with VLAN4/VLAN5 DHCP upstreams.
- `FS-380-HDS-020-SDS-010-SMS-120` for prod-like IPv4 client egress through the
  five-node selector chain with a real `s-router-test-clients` endpoint and a
  VLAN4 NAT upstream, using lab-only client prefixes instead of prod CIDRs.
