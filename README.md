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
LABS_DIR="$(pwd)"
(
  cd ../network-control-plane-model
  nix run .#compile-and-build-control-plane-model -- \
    "$LABS_DIR/examples/single-wan/intent.nix" \
    "$LABS_DIR/examples/single-wan/inventory.nix" \
    "$LABS_DIR/output-control-plane-model.json"
)
```

This produces a renderer-neutral control-plane JSON that downstream renderers consume.

### Render to Containerlab

```bash
(
  cd ../network-renderer-containerlab-linux-backend
  nix run .#generate-clab-config -- \
    "$LABS_DIR/output-control-plane-model.json" \
    "$LABS_DIR/fabric.clab.yml" \
    "$LABS_DIR/vm-bridges-generated.nix"
)
```

### Render to NixOS artifacts (S88-style renderer)

```bash
(
  cd ../network-renderer-nixos
  nix run .#render-dry-config -- --debug "$LABS_DIR/output-control-plane-model.json"
)
```

## Notes / limitations

- Most examples use a single transit segment per canonical stage adjacency.
- If you enable `transit.dedicatedLanes = true` (see `examples/multi-wan-dedicated-lanes`), policy intent can derive multiple parallel
  transit p2p links ("dedicated L2 lanes"). These lane link names must be bound explicitly in `inventory.nix`.
