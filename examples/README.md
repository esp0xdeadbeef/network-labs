# TL;DR

  intent.nix

  - architecture and policy only
  - sites, tenants, services, relations, overlays, terminateOn

  inventory-clab.nix
  inventory-nixos.nix

  - renderer realization only
  - where runtime nodes live
  - provider-specific provisioning inputs
  - host/container placement
  - static vs BGP specifics

# network-labs examples

Each example contains:

- `intent.nix`: the logical network intent
- `inventory-clab.nix`: the Containerlab realization inventory
- `inventory-nixos.nix`: the NixOS-renderer realization inventory

The rule is:

- keep semantic meaning in `intent.nix`
- keep renderer-specific realization in `inventory-<renderer>.nix`
- keep renderer-consumer bindings out of semantic intent

These examples are meant to be consumed by:

- `network-control-plane-model` (to build `output-control-plane-model.json`)
- renderers (e.g. `network-renderer-nixos`, `network-renderer-containerlab-linux-backend`)

Examples-only SMT traceability is indexed at `../tests/SMT.md`. Each `LAB-SMT-*`
row identifies the exact repo-local test script that uses these examples as
module evidence before FAT.

## Conventions used here

- Canonical stage order is always:

  `access -> downstream-selector -> policy -> upstream-selector -> core`

- Transit link names are stable and normalized:

  - Base: `p2p-<nodeA>-<nodeB>` where `<nodeA>` and `<nodeB>` are lexicographically ordered.
  - Dedicated lane variants (always enabled):
    - `p2p-<nodeA>-<nodeB>--access-<accessUnit>`
    - `p2p-<nodeA>-<nodeB>--access-<accessUnit>--uplink-<uplinkName>`

  Inventories bind these link names to concrete L2 attachments (bridges/VLANs/subifs/etc).

## Examples

- `single-wan`
  - Minimal single-site, single-uplink topology.
  - Includes explicit WAN service ingress for TCP/8443 to `web01` as a public port-forward example.

- `single-wan-bgp`
  - Like `single-wan`, but inventory selects iBGP control-plane (`policy-rr`).

- `single-wan-uplink-ebgp`
  - Like `single-wan-bgp`, but inventory also declares an explicit eBGP uplink peer.

- `single-wan-uplink-static-egress`
  - Like `single-wan`, but inventory declares explicit static uplink egress routes.

- `single-wan-vlan-trunk-lanes`
  - Like `single-wan`, but realizes lane links as VLANs on a single host trunk uplink.

- `single-wan-direct-transit`
  - Like `single-wan`, but realizes transit links via `attach.kind = "direct"` (no explicit host bridges).

- `single-wan-ipv6-pd`
  - Like `single-wan`, but inventory enables IPv6 prefix-delegation planning (PD) and per-tenant IPv6 modes.

- `multi-wan`
  - Two sites, each with multiple uplinks (demonstrates multi-uplink intent + policy constraints).

- `multi-wan-dedicated-lanes`
  - Focused example of policy-derived dedicated transit lanes (multiple parallel p2p links).

- `multi-enterprise`
  - Multiple enterprises and sites (demonstrates multi-enterprise scoping without changing layers).

- `dual-wan-branch-overlay`
  - Two enterprises with asymmetric WANs: HQ has dual uplinks plus a DMZ Nebula lighthouse, branch has one WAN plus policy-controlled east-west overlay reachability.
  - Cross-renderer conformance example.
  - `inventory-nixos.nix` adds the explicit host WAN-group binding required by the strict NixOS renderer.

- `dual-wan-branch-overlay-bgp`
  - Same topology as `dual-wan-branch-overlay`, but both sites enable iBGP control-plane (`policy-rr`).
  - Cross-renderer conformance example.

- `s-router-public-overlay-service`
  - Focused prod-like fixture for public ingress to an overlay-facing DMZ service.
  - Keeps the service provider, overlay lighthouse, and runtime addresses in inventory.

- `s-router-overlay-dns-lane-policy`
  - Focused prod-like fixture for DNS lane preservation, hostile east-west DNS, and overlay return-route checks.
  - Keeps runtime/SOPS-like realization facts in inventory; intent only declares policy and ownership.

- `tri-site-s-router-overlay-egress`
  - Full three-site `s-router-test` policy copied into examples with example-scoped router names.
  - Models hostile egress over east-west toward the hosted edge site, plus runtime IPv6 routed-prefix requests and public service entries.

- `priority-stability`
  - Focused on relation ordering / priority determinism.

- `overlay-east-west`
  - Two sites connected via an overlay that must traverse policy.

- `single-wan-with-nebula`
  - Overlay termination on core with policy traversal requirements.

- `single-wan-any-to-any-fw`, `single-wan-with-nebula-any-to-any-fw`
  - More permissive policy variants for lab iteration.

## Dedicated transit lanes

The forwarding model replaces the single downstream-selector<->policy and policy<->upstream-selector transit
segments with multiple p2p links ("lanes") derived from policy.

The control-plane model then requires inventory bindings for every derived lane link name (missing bindings hard-fail).

## Overlay provisioning (Nebula, etc.)

Overlays are defined in `intent.nix` under `transport.overlays` (semantic overlay names like `"nebula"` or `"east-west"`).

If you want the control-plane output to include explicit overlay provisioning hints (which termination nodes must be
provisioned + which overlay IP(s) they should use), set one of:

- Deterministic per-site IPAM (best for single-site overlays):
  - `inventory.controlPlane.sites.<enterprise>.<site>.overlays.<overlayName>.ipam.ipv4.prefix = "<cidr>"`
  - optional: `.ipam.ipv4.offsetStart` (default: 10)
  - optional: `.ipam.ipv4.perNodePrefixLength` (default: 32)
  - and/or `.ipam.ipv6.*` equivalents

- Explicit per-node addresses (best for multi-site overlays where a per-site allocator would collide):
  - `inventory.controlPlane.sites.<enterprise>.<site>.overlays.<overlayName>.nodes.<nodeName>.addr4 = "<cidr>"`
  - `inventory.controlPlane.sites.<enterprise>.<site>.overlays.<overlayName>.nodes.<nodeName>.addr6 = "<cidr>"`

Optional overlay metadata:

- `inventory.controlPlane.sites.<enterprise>.<site>.overlays.<overlayName>.provider` (optional)
- `inventory.controlPlane.sites.<enterprise>.<site>.overlays.<overlayName>.nebula = { ... }` (optional; opaque)

Then CPM emits (renderer-consumable):

- `control_plane_model.data.<enterprise>.<site>.overlays.<overlayName>.terminateOn`
- `control_plane_model.data.<enterprise>.<site>.overlays.<overlayName>.nodes.<nodeName>.addr4/addr6`

## Cross-renderer rule

If a lab should pass both renderers:

- `intent.nix` must stay shared
- each renderer must have its own full standalone `inventory-<renderer>.nix`
- renderer-only requirements such as host uplink selection must live in that renderer inventory
