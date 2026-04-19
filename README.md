# network-labs

This repository contains runnable lab inputs for the network toolchain.

Each example directory contains:

- `intent.nix` - logical network intent (architecture, policy, overlays, uplinks)
- `inventory.nix` - realization inventory (hosts, ports, bridges/VLANs/subifs, runtime targets)

The core contract is separation:

`intent.nix` defines *what the network means*.
`inventory.nix` defines *how that meaning is realized on a specific platform*.

## Examples

See `examples/README.md` for what each example is trying to demonstrate.

## Typical pipelines

### Build a control-plane model (compiler -> forwarding-model -> control-plane-model)

From `network-labs/`:

```bash
nix run ../network-control-plane-model#compile-and-build-control-plane-model -- \
  ./examples/single-wan/intent.nix \
  ./examples/single-wan/inventory.nix \
  ./output-control-plane-model.json
```

This produces a renderer-neutral control-plane JSON that downstream renderers consume.

### Render to Containerlab

```bash
nix run ../network-renderer-containerlab-linux-backend#generate-clab-config -- \
  ./output-control-plane-model.json \
  ./fabric.clab.yml \
  ./vm-bridges-generated.nix
```

### Render to NixOS artifacts (S88-style renderer)

```bash
nix run ../network-renderer-nixos#render-dry-config -- --debug ./output-control-plane-model.json
```

## Notes / limitations

- Most examples use a single transit segment per canonical stage adjacency.
- If you enable `transit.dedicatedLanes = true` (see `examples/multi-wan-dedicated-lanes`), policy intent can derive multiple parallel
  transit p2p links ("dedicated L2 lanes"). These lane link names must be bound explicitly in `inventory.nix`.
