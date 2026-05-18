# network-labs

This repository contains runnable lab inputs for the network toolchain.

Each example directory contains:

- `intent.nix` - logical network intent (architecture, policy, overlays, uplinks)
- `inventory-clab.nix` - Containerlab realization inventory
- `inventory-nixos.nix` - NixOS-renderer realization inventory

The core contract is separation:

`intent.nix` defines *what the network means*.
`inventory-<renderer>.nix` defines *how that meaning is realized on a specific platform*.

Renderer-specific realization files exist because the semantic lab is shared while each renderer may
need different consumer-side bindings. That binding must stay in inventory space, not intent space.

## Modeling Contract

The compiler and forwarding model own the canonical staged fabric:

```text
access -> downstream-selector -> policy -> upstream-selector -> core
```

Do not draw that chain by hand in new lab `intent.nix` files. Intent should
describe the network meaning:

- sites, tenants, services, traffic types, and communication relations
- uplink and overlay domains as semantic external domains
- route ownership/export authority
- policy exceptions, such as which access class may use an overlay path
- stage cardinality only when the default shape is not enough

The pipeline derives the staged topology, dedicated lanes, and p2p link names
from that semantic input. Inventory still has to bind those derived p2p links
to concrete realization facts such as bridges, VLANs, direct links, container
interfaces, or host attachments. That is not duplication: intent declares
meaning, while inventory declares how the derived links are realized.

Model a roaming overlay client as overlay membership plus policy/service
reachability. Do not model it as a fake fabric p2p node unless it exports routes
or owns prefixes. If it exports routes, model the route ownership explicitly so
the forwarding and control-plane stages can validate the authority.

Concrete runtime values such as real public addresses, deployment MACs, and
private overlay client addresses belong in SOPS/runtime inventory for prod-like
labs, not in plain intent. The semantic routed-prefix contract still belongs in
intent: which tenant receives a runtime public prefix, its delegated and
per-tenant prefix lengths, slot, postfix, NAT/public-egress meaning, and the
runtime source file that downstream renderers watch. Inventory may provide the
runtime value behind that source file, but it must not decide the routed prefix
or route shape.

## Examples

See `examples/README.md` for what each example is trying to demonstrate.

## Typical pipelines

### Build a control-plane model (compiler -> forwarding-model -> control-plane-model)

From `network-labs/`:

```bash
LABS_DIR="$(pwd)"
nix run github:esp0xdeadbeef/network-control-plane-model#compile-and-build-control-plane-model -- \
  "$LABS_DIR/examples/single-wan/intent.nix" \
  "$LABS_DIR/examples/single-wan/inventory-nixos.nix" \
  "$LABS_DIR/output-control-plane-model.json"
```

This produces a renderer-neutral control-plane JSON that downstream renderers consume.

### Render to Containerlab

```bash
nix run github:esp0xdeadbeef/network-renderer-containerlab-linux-backend#generate-clab-config -- \
  "$LABS_DIR/output-control-plane-model.json" \
  "$LABS_DIR/fabric.clab.yml" \
  "$LABS_DIR/vm-bridges-generated.nix"
```

### Render to NixOS artifacts (S88-style renderer)

```bash
nix run github:esp0xdeadbeef/network-renderer-nixos#render-dry-config -- --debug "$LABS_DIR/output-control-plane-model.json"
```

## Notes / limitations

- Policy intent can derive multiple parallel transit p2p links ("dedicated lanes") between:
  - downstream-selector <-> policy (one lane per access unit)
  - policy <-> upstream-selector (one lane per access unit and allowed uplink)
  These lane link names must be bound explicitly in `inventory-<renderer>.nix`.

- Cross-renderer examples keep `intent.nix` shared and carry full standalone renderer inventory files
  instead of forking the semantic intent.
