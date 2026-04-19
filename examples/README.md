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

  `p2p-<nodeA>-<nodeB>` where `<nodeA>` and `<nodeB>` are lexicographically ordered.

  Inventories bind these link names to concrete L2 attachments (bridges/VLANs/subifs/etc).

## Examples

- `single-wan`
  - Minimal single-site, single-uplink topology.

- `multi-wan`
  - Two sites, each with multiple uplinks (demonstrates multi-uplink intent + policy constraints).

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

## Planned evolution

Policy-driven “dedicated transit lanes” (multiple p2p segments between the same two staged units) are intentionally not modeled yet,
because the upstream model chain currently assumes “one p2p per node pair”.

Once lane-aware transit exists upstream, these examples will grow additional explicit link bindings in `inventory.nix` (one per lane).

