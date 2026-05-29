# network-labs

This repository contains runnable lab inputs for the network toolchain.

Each example directory contains:

- `intent.nix` - logical network intent (architecture, policy, overlays, uplinks)
- `inventory-clab.nix` - Containerlab realization inventory
- `inventory-nixos.nix` - NixOS-renderer realization inventory

The core contract is separation:

`intent.nix` defines *what the network means*.
`inventory-<renderer>.nix` defines *which concrete platform facts realize it*.

Renderer-specific realization files exist because the semantic lab is shared while
each renderer may need different consumer-side bindings. Those bindings must stay
in inventory space, not intent space.

## Modeling Contract

The compiler and forwarding model own the canonical staged fabric:

```text
access -> downstream-selector -> policy -> upstream-selector -> core
```

Do not draw that chain by hand in new lab `intent.nix` files. Intent should
describe the network meaning:

- sites, tenants, services, traffic types, and communication relations
- uplink and overlay domains as semantic external domains
- WAN/public-egress meaning, including when host IPv4 reachability implies NAT
- route ownership/export authority
- policy exceptions, such as which access class may use an overlay path
- stage cardinality only when the default shape is not enough

The pipeline derives the staged topology, dedicated lanes, and p2p link names
from that semantic input. Inventory still has to bind those derived p2p links
to concrete realization facts such as bridge names, VLAN tags, MTUs, direct
links, container interfaces, host attachments, endpoint bindings, and SOPS-backed
credentials or runtime values. That is not duplication: intent declares meaning,
while inventory declares how the derived links are realized.

WAN inventory must not decide whether a router performs NAT or public egress.
If a router only has host IPv4 reachability, the need to NAT is forwarding
intent and belongs in the model pipeline. Inventory may provide the concrete WAN
interface, address source, gateway, bridge, VLAN, MTU, and credential/secret
bindings that let the renderer realize that modeled behavior.

Model a roaming overlay client as overlay membership plus policy/service
reachability. Do not model it as a fake fabric p2p node unless it exports routes
or owns prefixes. If it exports routes, model the route ownership explicitly so
the forwarding and control-plane stages can validate the authority.

Overlay daemon underlay is separate from overlay payload policy. A site Nebula
core that needs WAN/bootstrap reachability must not be wired directly to a WAN
bridge or selector and must not borrow the tenant that uses the overlay payload
path. Model a dedicated access router and tenant subnet for that WAN-side client
attachment, for example:

```text
overlay payload:
  hostile/client tenant -> access-hostile/client -> downstream -> policy -> core-nebula -> overlay

overlay daemon underlay:
  core-nebula -> access-client (/24 client subnet) -> downstream -> policy -> upstream -> WAN core
```

In the s-sigma lab this rule applies to every runtime surface: `esp.nixos`,
`esp.hetz`, and `esp.clab` each select a real non-overlay-payload access tenant,
currently `transport.overlays[].underlayAccess = { kind = "tenant"; name = "client"; }`.
The overlay core may still keep its normal core-to-upstream fabric adjacency for
modeled overlay payload routes; `underlayAccess` is what selects the daemon
bootstrap/WAN-side client path and prevents that route from borrowing the
hostile/overlay payload tenant or a hidden WAN port. The selected access tenant
does not need to be a special IoT tenant; it just needs to be a normal modeled
access path that can reach the required WAN external without routing back
through the overlay being bootstrapped.
Changing a renderer or a NixOS host file to recover that access path is a layer
violation; the compiler and forwarding model must derive it from intent.

Concrete runtime values such as real public addresses, deployment MACs, device
login material, and private overlay client addresses belong in SOPS/runtime
inventory for prod-like labs, not in plain intent. The semantic routed-prefix
contract still belongs in intent: which tenant receives a runtime public prefix,
its delegated and per-tenant prefix lengths, slot, postfix, public-egress
meaning, and the runtime source file that downstream renderers watch. Inventory
may provide the runtime value behind that source file, but it must not decide
the routed prefix, NAT requirement, or route shape.

## Examples

See `examples/README.md` for what each example is trying to demonstrate.

Examples-only SMT traceability lives in `tests/SMT.md`. It maps stable
`LAB-SMT-*` identifiers to the exact distributed repo tests that prove compiler,
NFM, CPM, CLAB renderer, NixOS renderer, and Nebula renderer module contracts
from `network-labs/examples`. It is not FAT evidence and must not reference
disposable lab paths or live lab loops.

## Controlled FAT lab source

The controlled s-router FAT source is:

`labs/lab-s-sigma/s-router-test-three-site`

Its `intent.nix`, inventory files, runtime fact joiners, and
`FAT-SOURCE-CONTRACT.md` are the source provenance for disposable FAT lab
acceptance. FAT still requires locked full-lab runtime evidence; passing
examples or examples-only compile sweeps is lower-layer evidence only.

`FAT-SOURCE-CONTRACT.md` is not FAT evidence. It also names current source gaps
that block complete FAT promotion, including missing controlled WireGuard
provider scenarios and missing NixOS/CLAB fake-provider or PPPoE-like source
scenarios.

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
