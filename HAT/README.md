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
