# network-labs examples

Each example is a pair:

- `intent.nix`: the logical network intent
- `inventory.nix`: the realization inventory for a lab host

These examples are meant to be consumed by:

- `network-control-plane-model` (to build `output-control-plane-model.json`)
- renderers (e.g. `network-renderer-nixos`, `network-renderer-containerlab-linux-backend`)

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

- `single-wan-bgp`
  - Like `single-wan`, but inventory selects iBGP control-plane (`policy-rr`).

- `single-wan-vlan-trunk-lanes`
  - Like `single-wan`, but realizes lane links as VLANs on a single host trunk uplink.

- `single-wan-ipv6-pd`
  - Like `single-wan`, but inventory enables IPv6 prefix-delegation planning (PD) and per-tenant IPv6 modes.

- `multi-wan`
  - Two sites, each with multiple uplinks (demonstrates multi-uplink intent + policy constraints).

- `multi-wan-dedicated-lanes`
  - Focused example of policy-derived dedicated transit lanes (multiple parallel p2p links).

- `multi-enterprise`
  - Multiple enterprises and sites (demonstrates multi-enterprise scoping without changing layers).

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
provisioned + which overlay IP they should use), set:

- `inventory.controlPlane.sites.<enterprise>.<site>.overlays.<overlayName>.provider` (optional)
- `inventory.controlPlane.sites.<enterprise>.<site>.overlays.<overlayName>.addr4` / `.addr6` (optional)

Then CPM emits:

- `control_plane_model.data.<enterprise>.<site>.overlays.<overlayName>`
