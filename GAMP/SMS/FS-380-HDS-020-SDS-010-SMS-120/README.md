# FS-380-HDS-020-SDS-010-SMS-120

Template row for prod-like IPv4 client egress and access DNS recursion over VLAN4.

The SMT source is
`GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-120/`. It models the production-style
five-node router chain with a real `s-router-test-clients` endpoint and an
emulated VLAN4 upstream, avoiding PPPoE so IPv4 forwarding and NAT can be
tested when the real ISP handoff is unavailable. The row also models access DNS
as an explicit service-origin flow from the lab-only tenant gateway address so
recursive resolver traffic does not rely on an unscoped default-route source.
The CLAB realization is bound to a separate `client-clab`/VLAN303 test-client
bridge so it cannot answer ARP for the NixOS router's VLAN302 gateway while both
surfaces are online.
