# HAT: Residential Emulated ISP Testnet

This HAT preparation fixture models residential ISP handoffs with documentation
test ranges so CLAB and NixOS renderers can be checked without depending on a
physical upstream VLAN or live provider.

The shared intent has two emulated ISP shapes:

- `testnet-routed-isp`: DHCP-like provider path advertising IPv4
  `203.0.113.0/30` and delegated IPv6 `2001:db8:113::/48`.
- `testnet-host-isp`: constrained PPPoE-like provider path advertising IPv4
  `203.0.113.4/32` and delegated IPv6 `2001:db8:113:64::/64`.

Both inventories carry explicit NAT64 probe metadata for IPv6-to-IPv4 test
reachability through `64:ff9b::/96`. NAT44, NAT66, and NAT64 are fixture data,
not provider identity. Provider names intentionally avoid translation-implying
or overlay-provider naming.

CLAB and NixOS use separate isolated PPPoE Ethernet bridges (`br-c-pppoe` and
`br-n-pppoe`) so both harnesses can be prepared at the same time without sharing
VLAN 11/12 or a loopback PPPoE substitute.

The CLAB inventory uses the real hardware deployment host `s-router-clab`, so
the hardware deploy command can render the HAT topology from the locked
`network-labs` input without NixOS-side local overrides. The NixOS inventory
uses `lab-host` as its fixture selector and separately exposes management
uplinks for `s-router-nixos` and `s-router-test-clients`.
