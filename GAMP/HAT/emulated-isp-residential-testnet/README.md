# HAT: Residential Emulated ISP Testnet

This HAT preparation fixture models the first residential provider-access test
path with documentation test ranges. The first NixOS HAT path must prove:

```text
core internet uplink on VLAN 4, with no clients on that network
  -> upstream selector
  -> policy
  -> downstream selector
  -> fake ISP PPP service on an access network
  -> core emulated ISP
  -> upstream selector
  -> policy
  -> downstream selector
  -> client that uses the emulated ISP as upstream
```

The fake ISP service is not a special CPM topology feature. It is an access-side
provider service using a selected distribution technology. This fixture uses
PPPoE for endpoint-specific distribution, but the source contract is not limited
to DHCP versus PPPoE; another explicit technology such as PPP or xVLAN must
still be modeled as provider-access distribution, not as a renderer-local
topology invention.

The shared intent has two provider shapes:

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
uses `s-router-nixos` as its fixture selector, exposes VLAN 4 as the core internet
uplink substrate, and separately exposes management uplinks for `s-router-nixos`
and `s-router-test-clients`.
