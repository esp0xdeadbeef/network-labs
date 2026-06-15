# network-labs HAT Fixtures

This directory contains Host Acceptance Testing preparation fixtures. These
fixtures are controlled lab inputs for rendering and harness preparation, not
SAT evidence.

HAT fixtures may use one shared intent with renderer-specific inventories when
the semantic model is common and the host substrate differs. Runtime acceptance
still belongs to the owning harness that can start containers, bridges, network
namespaces, services, nftables rules, and packet probes.

## Fixtures

- `emulated-isp-residential-testnet`
  - Shared intent for residential-style emulated ISP paths using documentation
    test networks.
  - One path advertises IPv4 `203.0.113.0/30` with IPv6 `/48`; the constrained
    path advertises IPv4 `203.0.113.4/32` with IPv6 `/64`.
  - NAT64 probe behavior is explicit fixture metadata; provider names do not
    imply translation or overlay-provider behavior.
  - PPPoE preparation uses separate isolated Ethernet bridge surfaces per
    harness, not loopback IP interfaces or shared physical VLANs.

## Static and BGP Uplink Testing

Uplink testing at HAT and SAT layers SHALL cover both static and BGP
uplink types. Each type defines distinct CPM forwarding contracts and
renderer materialization paths; both must be proven.

### Static Uplink

- `single-wan` with `uplink.type = "static"` — explicit next-hop, prefix,
  and egress interface assignment.
- `dual-wan` with per-WAN static routes — verifying the NFM derives
  correct WAN-group egress and the CPM emits distinct next-hop records
  per uplink.
- HAT runtime evidence SHALL include `ip route show` verifying the static
  default route is installed with the correct next-hop, plus end-to-end
  reachability through the static path.
- SAT evidence SHALL include locked CPM output proving static route
  records match the intent's `uplink` configuration.

### BGP Uplink

- `single-wan` with `uplink.type = "bgp"` — eBGP peer to emulated ISP, ASN
  assignment, prefix advertisement, and route acceptance.
- `dual-wan` with mixed uplink types — one BGP, one static/DHCP — verifying
  the NFM correctly derives per-WAN egress paths and the CPM emits distinct
  next-hop and AS-path records.
- BGP-specific failure modes: ASN mismatch rejection, prefix filter deny,
  graceful restart behavior, and route withdrawal on link flap.
- HAT runtime evidence SHALL include `ip route show` and BGP session state
  from the emulated ISP container namespace, plus end-to-end reachability
  through the BGP-learned path.
- SAT evidence SHALL include locked CPM output proving the BGP-derived
  forwarding records match the intent's `communicationContract` and
  `uplink` configuration.
