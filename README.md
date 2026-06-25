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

For the same pinned intent, inventory, and runtime fact inputs, lab model output
must be deterministic. Any nondeterministic runtime value must enter through an
explicit inventory/SOPS/runtime source and remain visible as provenance.

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

## Spec Chain

The network-labs repository is owned by the following GAMP trace chain. All fixture data
requirements originate from the URS, flow through FS, and are refined by HDS → SDS → SMS
before reaching this repository.

### Primary Chain: Controlled Lab Baseline

| Layer | ID | Description |
|-------|----|-------------|
| URS   | L196-235 | Controlled Lab Baseline — acceptance fixture root, site naming, tenant matrix, public ingress, equivalence |
| FS    | FS-650 – FS-800 | Practical deployments, controlled lab baseline, s-router-test-clients, shared services, public ingress, provider-access fixtures |
| FS    | FS-770 | Common Intent for Containerlab/Linux and NixOS — same modeled meaning for both lab profiles |
| FS    | FS-780 | Containerlab/Linux and NixOS Equivalence Matrix |
| HDS   | Derived per FS item | Hardware design constraints for lab fixtures |

### Pipeline

```
network-labs (intent + inventory) → network-compiler → NFM → CPM → renderers
```

Required inputs: `intent.nix` (user intent), `inventory-clab.nix` / `inventory-nixos.nix` (realization inventory).
Output: deterministic model source consumed by network-compiler.

### Owning Repository

Construction tests: `network-labs/tests/`
Fixture source: `network-labs/sat/` (controlled SAT), `network-labs/HAT/` (HAT preparation)

## Layer-Entry POC Boundary

`active-lab/layer-entry-poc/` is the source-side boundary and orchestrator for
small deterministic POCs that do not need the full HAT/SAT deployment path.
These checks exist so downstream agents can test one FS/SMS/SMT point at a time
from a declared input boundary instead of reverse-engineering fixtures inside a
downstream repo.

The default layer-entry rule is:

- skip `network-compiler` when the FS item is about NFM behavior and provide a
  synthetic compiler-output/NFM-input fixture from `network-labs`;
- optionally skip NFM when the FS item is about CPM behavior and provide a
  synthetic forwarding-model/CPM-input fixture from `network-labs`;
- optionally skip CPM when the FS item is about renderer behavior and provide a
  synthetic CPM renderer-input fixture from `network-labs`;
- feed the renderer/NixOS materialization path directly only when the test is
  explicitly scoped to renderer projection or NixOS config materialization, for
  example "can normal router runtime surfaces become NixOS container config?";
- keep HAT and SAT out of this skip model. HAT/SAT approval must still run the
  complete chain and collect runtime evidence from the correct harness.

Examples of intended use:

- NFM FS item: start from network-labs-owned synthetic compiler output, skip the
  compiler, and prove NFM can handle the relevant network shape.
- CPM FS item: start from network-labs-owned synthetic NFM/control-plane input,
  skip compiler and optionally NFM, and prove CPM handles topology that the
  ordinary compiler/NFM path might not emit, such as non-following p2p links.
- Renderer/NixOS materialization FS item: start from network-labs-owned CPM
  renderer input, skip compiler, NFM, and CPM, and prove the downstream
  renderer plus NixOS materializer can project container start shape, PPPoE
  server/client surfaces, p2p links, routes, firewall, DNS, or other runtime
  surfaces without inventing upstream semantics.

These POCs may support SMT or SIT construction evidence. They are not HAT/SAT
approval evidence and must not be promoted as runtime proof without the owning
harness running live probes.

## Examples

See `examples/README.md` for what each example is trying to demonstrate.

Examples-only SMT traceability lives in `tests/SMT.md`. It maps stable
`LAB-SMT-*` identifiers to the exact distributed repo tests that prove compiler,
NFM, CPM, CLAB renderer, NixOS renderer, and Nebula renderer module contracts
from `network-labs/examples`. It is not SAT evidence and must not reference
disposable lab paths or live lab loops.

## HAT Fixtures

Host Acceptance Testing preparation fixtures live under `HAT/`. These inputs
may render through model and renderer stages, but they are not SAT evidence by
themselves. HAT rows remain blocked until the owning CLAB or NixOS harness runs
the rendered substrate and records bounded runtime probes.

The emulated-ISP residential testnet fixture is:

`HAT/emulated-isp-residential-testnet`

It uses one shared intent plus separate CLAB and NixOS inventories. The fixture
models a routed documentation-range provider path with IPv4 `203.0.113.0/30`
and IPv6 `/48`, plus a constrained provider path with IPv4 `203.0.113.4/32`
and IPv6 `/64`. NAT64 probe behavior is explicit fixture metadata, not provider
naming. PPPoE handoff preparation uses split per-harness isolated Ethernet
bridge surfaces; loopback IP interfaces are not a valid PPPoE substitute, and
physical VLAN handoffs require an exclusive-run guard.

## Controlled SAT Source

The controlled SAT source is:

`sat`

Its `intent.nix`, inventory files, provider-access fixture table, runtime fact
joiners, and `SAT-SOURCE-CONTRACT.md` are the source provenance for controlled
SAT acceptance for the current GAMP network baseline. SAT still requires locked
runtime evidence from the owning harness contexts; passing examples or
examples-only compile sweeps is lower-layer evidence only.

`SAT-SOURCE-CONTRACT.md` is not SAT evidence. It names the controlled source
channels for WireGuard provider scenarios: `sat/intent.nix` owns the service,
traffic, overlay, and policy tuples, while `sat/inventory.nix` owns the
WireGuard provider-profile realization contract, including prefix authority,
NAT, public endpoint, public-ingress or port-forward, runtime paths, and return
routes. NixOS/CLAB emulated-ISP PPPoE fixture rows are present in
`sat/provider-access-fixture-table.nix`, with normal site behavior remaining in
`sat/intent.nix` and harness realization bindings in `sat/inventory.nix`, but
WireGuard, PPPoE, and other SAT rows still require harness-owned HAT/SAT runtime
proof before acceptance.

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
