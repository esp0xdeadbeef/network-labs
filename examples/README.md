# network-labs examples

Each example contains:

- `intent.nix`: the logical network intent — architecture and policy only
- `inventory-clab.nix`: the Containerlab realization inventory
- `inventory-nixos.nix`: the NixOS renderer realization inventory

Rules:

- Keep semantic meaning in `intent.nix`
- Keep renderer-specific realization in `inventory-<renderer>.nix`
- Uplink type is an inventory parameter, not an intent concern — the same `intent.nix`
  can produce static-routed or BGP-routed output depending on the inventory.

## Documentation test prefixes

Examples use IANA documentation prefixes:

- **TEST-NET-2**: `198.51.100.0/24` — uplink NAT addresses
- **TEST-NET-3**: `203.0.113.0/24` — BGP peer addresses

## Examples

### single-wan

Baseline single-site, single-uplink topology with static routing.
Three tenants (mgmt, admin, client), DNS service, and basic egress policy.
Same `intent.nix` used by `single-wan-bgp`.

### single-wan-bgp

Same intent as `single-wan`, but inventory selects BGP control-plane routing
(`bgp.asn`, `bgp.peerAddr4`, `bgp.peerAsn`). Demonstrates that uplink type
is a renderer-side parameter.

### dual-wan

Single site with two WAN uplinks: isp-a uses static egress routing,
isp-b uses DHCP-learned default route. Demonstrates per-WAN path selection
and multi-uplink intent.

### overlay-east-west

Two enterprises (enterprise-a, enterprise-b) connected via a Nebula overlay
that traverses policy. Demonstrates cross-site overlay with `mustTraverse`
and `underlayAccess`.

### policy-any-to-any-fw

Policy example with `communicationContract` relations. Demonstrates
allow/deny rules, `tenant-set` members, and `external` uplink targeting.

### multi-enterprise

Two isolated enterprises (esp0xdeadbeef, esp0xdeadbeef-2) with independent
routing. Demonstrates multi-enterprise scoping without changing model layers.

## Conventions

- Canonical stage order: `access → downstream-selector → policy → upstream-selector → core`
- Transit links: `p2p-<nodeA>-<nodeB>` (lexicographically ordered)
- Service providers and runtime addresses live in inventory, not intent
