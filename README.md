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
| URS   | Controlled Evidence and Acceptance; Canonical Realization and Renderer Boundary | Controlled source, lock-root, canonical bundle, and renderer-chain evidence |
| FS    | FS-650 – FS-800 | Practical deployments, controlled lab baseline, s-router-test-clients, shared services, public ingress, provider-access fixtures |
| FS    | FS-770 | Common Intent for Containerlab/Linux and NixOS — same modeled meaning for both lab profiles |
| FS    | FS-780 | Containerlab/Linux and NixOS Equivalence Matrix |
| HDS   | Derived per FS item | Hardware design constraints for lab fixtures |

### Pipeline

```
network-labs (intent + inventory) → network-compiler → NFM → CPM → network-realization-model → renderers
```

`network-realization-schema` is the common pinned contract dependency for
canonical-bundle production, validation, fixtures, and renderer consumption.
It is not a transformation stage.

Required inputs: `intent.nix` (user intent), `inventory-clab.nix` / `inventory-nixos.nix` (realization inventory).
Output: deterministic model source consumed by network-compiler.

### Owning Repository

Construction tests: `network-labs/tests/`
Fixture source: `network-labs/GAMP/SAT/` (controlled SAT), `network-labs/GAMP/HAT/` (HAT preparation)

## Controlled Layer-Entry Boundary

`packages.<system>.validation-scheme` is the deterministic authority for small
controlled scenarios that do not need the full HAT/SAT deployment path. Each
source lives under its trace row; downstream repositories do not own or
reverse-engineer replacement artifacts.

The controlled layer-entry rule is:

- a scenario may declare only one contiguous upstream prefix before
  `network-realization-model` as skipped;
- the orchestrator still invokes every repository hop in order;
- a skipped stage executes only its controlled-skip interface, performs no
  semantic transformation, and emits a deterministic acknowledgement;
- the replacement artifact is injected only at the declared boundary;
- every semantic stage after that boundary executes normally, including
  `network-realization-model`, pinned schema validation, the selected renderer,
  and the requested evidence context;
- skipped stages remain outside evidence scope and are never reported as
  executed, tested, or passed.

The acknowledgement for each skipped stage records its repository identity,
pinned revision, execution mode, full trace-chain ID, specification reason,
normal input contract, expected replacement contract, declared replacement
boundary, and next stage. It acknowledges control flow only; it is not a
pass-through transformation of the replacement artifact.

The orchestrator verifies those acknowledgements against the common
`network-labs/flake.lock`. That lock remains the sole revision root for
controlled SMT, SIT, HAT, and SAT runs and pins compiler, NFM, CPM,
`network-realization-model`, `network-realization-schema`, and every selected
renderer, including skipped repositories.

The repository root exports `packages.<system>.validation-scheme` and owns
the common `flake.lock`. The package emits the scenario manifest, verifies the
three repository-owned skip acknowledgements, injects the replacement once at
the declared first active boundary, executes realization and schema validation,
validates one normalized platform-binding bundle, and invokes the selected
canonical renderer boundary. `network-codex-agent` may call this package, but
does not own or reimplement these predicates.

Valid replacement boundaries include:

- skip `network-compiler` and start from `forwarding-model-input`;
- skip `network-compiler` plus `network-forwarding-model` and start from
  `control-plane-input`;
- skip `network-compiler`, `network-forwarding-model`, and
  `network-control-plane-model`, then start normal semantic execution at
  `network-realization-model` with a valid replacement artifact.

A renderer is never the first active semantic boundary in a controlled run.
Direct raw CPM-to-renderer entry, a missing realization hop, a missing schema
validation, or a gap after the declared replacement boundary invalidates the
evidence.

For runtime SMT work, small does not mean dry-run only. Runtime evidence must
still use the real harness lifecycle, including the `s-router-nixos` shutdown
and rebuild path when that is the target. The input must be small: a mini SMT
should start only the runtime targets declared by that row. Do not point a
single-row SMT at the full active-lab/HAT/SAT fixture just because the runtime
host is `s-router-nixos`.

Do not use `vlan2` as test infrastructure. `vlan2` is the runtime
management/reachability network for the VM/host lifecycle, not a mini-SMT DHCP
uplink or dataplane path. If a mini POC needs DHCP uplinks, use `vlan4` or
`vlan5` and make that input explicit.

Keep the top-level `active-lab/` exposure minimal. `active-lab/default.nix`
exists only to import the selected `intent.nix` and expose `mkSource` for
row-local mini-lab intent stubs. `active-lab/intent.nix` points at the current
default mini runtime source, and `active-lab/inventory-nixos.nix` is an
explicit provenance stub. Do not add empty placeholders such as
`inventory.nix`, broad host inventory lookups, or catalog directories under
`active-lab/`. Runtime files that the NixOS harness imports directly, such as
`clients.nix`, `inventory-clab.nix`, `inventory-hetz.nix`, and
`sops-routing-*.nix`, must remain explicit stubs to the selected GAMP/runtime
source. `active-lab/` is a selector/import surface only: encrypted lab-runtime
SOPS payloads live in the owning HAT, SAT, SIT, or SMT row directory.
Host account and default-login secrets remain owned by the consuming host
repository's default SOPS source, not by `network-labs`.

Controlled replacement artifacts remain declared per renderer target. The current
targets are `nixos`, `nixos-clients`
(`network-renderer-access-endpoint-nixos`), `clab`, `wireguard`, `nebula`, and
`openconfig`.
`network-labs` owns controlled artifacts, the root lock, expected evidence, and
deterministic orchestration; the realization model owns canonical-bundle
production and each renderer owns only its output surface. The FS-162 peer
comparison uses one bundle identity for NixOS, CLAB, and OpenConfig and records
OpenConfig model limitations separately from CPM portability.

Direct-CPM harnesses and non-conformant boundary sources are removed rather
than retained as compatibility paths. Git history preserves prior work. The
FS-166 construction entrypoint is `tests/<full-trace-id>.sh`; its path is
derived from the selected trace and it invokes the locked validation scheme.

Row-level mini-SMT evidence must not depend on that aggregate renderer script.
Use `GAMP/SMT/mini-smt/tests.nix` plus
`tests/run-active-lab-mini-smt.sh <FS-...-SMS-... trace-id>` so one SMT can be tested
independently. Current renderer mini-SMT IDs are full trace IDs:
`FS-166-HDS-010-SDS-010-SMS-901`, `FS-166-HDS-010-SDS-010-SMS-902`,
`FS-166-HDS-010-SDS-010-SMS-903`, `FS-166-HDS-010-SDS-010-SMS-904`,
`FS-166-HDS-010-SDS-010-SMS-905`, `FS-166-HDS-010-SDS-010-SMS-906`, and
`FS-470-HDS-010-SDS-010-SMS-010`.

Preferred small row examples are already wired:

- `tests/run-active-lab-mini-smt.sh FS-800-HDS-030-SDS-030-SMS-010` for
  `FS-800-HDS-030-SDS-030-SMS-010`, capped to the five-node
  pppoe-client/downstream-selector/policy/upstream-selector/pppoe-provider path,
  proving PPPoE provider/customer pairing, fallback rejection, transport
  classification, and selectable current-lab runtime shape without full HAT/SAT.
- `tests/run-active-lab-mini-smt.sh FS-800-HDS-010-SDS-020-SMS-040` for
  `FS-800-HDS-010-SDS-020-SMS-040`, capped to the canonical six-node
  provider-access path, proving provider-handoff default selection without
  promoting the PPPoE side core into default reachability.
- `tests/run-active-lab-mini-smt.sh FS-500-HDS-010-SDS-010-SMS-010` for
  `FS-500-HDS-010-SDS-010-SMS-010`, capped to the five-node
  client/downstream-selector/policy/upstream-selector/testnet path required by
  current NFM, proving only structured reachability decision classification.
- `tests/run-active-lab-mini-smt.sh FS-500-HDS-010-SDS-010-SMS-040` for
  `FS-500-HDS-010-SDS-010-SMS-040`, capped to `router-a` and `router-b`,
  proving only one p2p link, two router endpoints, and one next-hop route atom.

Inspect the selected row input with
`tests/run-active-lab-mini-smt.sh --source <FS-...-SMS-... trace-id>` before running it.
Do not use `all`, full active-lab, HAT/SAT, or aggregate renderer-entry scripts
as proof for one SMT row.

SMT rows that need intent-source coverage must use row-specific directories
under `GAMP/SMT/<FS-XXX-HDS-XXX-SDS-XXX-SMS-XXX>/`. Put the row's selected
`intent.nix`, source notes, and SMT metadata there. SIT rows use the SDS-level
directory `GAMP/SIT/<FS-XXX-HDS-XXX-SDS-XXX>/` and define one or more SMS
inputs in that row's `default.nix`.

Every mini input in `GAMP/SMT/mini-smt/tests.nix` must also map to template
inputs under `GAMP/SDS/<FS-XXX-HDS-XXX-SDS-XXX>/` and
`GAMP/SMS/<FS-XXX-HDS-XXX-SDS-XXX-SMS-XXX>/`. Those SDS/SMS rows are source
templates for deterministic POC work. SMT/SIT rows remain the evidence-facing
construction/integration layers.

Select row-local sources with `active-lab.mkSource { intent = ...; }` or
inspect the manifest source with
`tests/run-active-lab-mini-smt.sh --source <FS-...-SMS-... trace-id>`. Do not rewrite the
global `active-lab/intent.nix` to run a specific row.

Examples of intended use:

- NFM FS item: start from network-labs-owned synthetic compiler output, skip the
  compiler, and prove NFM can handle the relevant network shape.
- CPM FS item: start from network-labs-owned synthetic NFM/control-plane input,
  skip compiler and optionally NFM, and prove CPM handles topology that the
  ordinary compiler/NFM path might not emit, such as non-following p2p links.
- Renderer/NixOS materialization FS item: supply a valid CPM replacement
  artifact after controlled acknowledgements for compiler, NFM, and CPM; run
  `network-realization-model`, schema validation, and the selected renderer;
  then prove the renderer plus NixOS materializer can project container start
  shape, PPPoE server/client surfaces, p2p links, routes, firewall, DNS, or
  other runtime surfaces without inventing upstream semantics.

These POCs may support SMT or SIT construction evidence. They are not HAT/SAT
approval evidence and must not be promoted as runtime proof without the owning
harness running live probes.

Mini runtime profiles live under `GAMP/SMT/mini-smt/`. The current
`active-lab` default is a one-container NixOS renderer-input POC
(`GAMP/SMT/mini-smt/runtime-nixos-cpm.nix`) so the downstream NixOS runtime
can be reboot-tested without also deploying every full-lab router container.

## Examples

See `examples/README.md` for what each example is trying to demonstrate.

Examples-only SMT traceability lives in `tests/SMT.md`. It maps stable
`LAB-SMT-*` identifiers to distributed repository tests for compiler, NFM, CPM,
canonical realization, schema validation, and selected renderer module
contracts from `network-labs/examples`. It is not SAT evidence and must not
reference disposable lab paths or live lab loops.

## HAT Fixtures

Host Acceptance Testing preparation fixtures live under `GAMP/HAT/`. These inputs
may render through model and renderer stages, but they are not SAT evidence by
themselves. HAT rows remain blocked until the owning CLAB or NixOS harness runs
the rendered substrate and records bounded runtime probes.

The emulated-ISP residential testnet fixture is:

`GAMP/HAT/emulated-isp-residential-testnet`

It uses one shared intent plus separate CLAB and NixOS inventories. The fixture
models a routed documentation-range provider path with IPv4 `203.0.113.0/30`
and IPv6 `/48`, plus a constrained provider path with IPv4 `203.0.113.4/32`
and IPv6 `/64`. NAT64 probe behavior is explicit fixture metadata, not provider
naming. PPPoE handoff preparation uses split per-harness isolated Ethernet
bridge surfaces; loopback IP interfaces are not a valid PPPoE substitute, and
physical VLAN handoffs require an exclusive-run guard.

## Controlled SAT Source

The controlled SAT source is:

`GAMP/SAT`

Its `intent.nix`, inventory files, provider-access fixture table, runtime fact
joiners, and `SAT-SOURCE-CONTRACT.md` are the source provenance for controlled
SAT acceptance for the current GAMP network baseline. SAT still requires locked
runtime evidence from the owning harness contexts; passing examples or
examples-only compile sweeps is lower-layer evidence only.

`GAMP/SAT/SAT-SOURCE-CONTRACT.md` is not SAT evidence. It names the controlled
source channels for WireGuard provider scenarios: `GAMP/SAT/intent.nix` owns
the service, traffic, overlay, and policy tuples, while `GAMP/SAT/inventory.nix` owns the
WireGuard provider-profile realization contract, including prefix authority,
NAT, public endpoint, public-ingress or port-forward, runtime paths, and return
routes. NixOS/CLAB emulated-ISP PPPoE fixture rows are present in
`GAMP/SAT/provider-access-fixture-table.nix`, with normal site behavior remaining in
`GAMP/SAT/intent.nix` and harness realization bindings in `GAMP/SAT/inventory.nix`, but
WireGuard, PPPoE, and other SAT rows still require harness-owned HAT/SAT runtime
proof before acceptance.

## Pipeline use

### Build an upstream CPM artifact

From `network-labs/`:

```bash
LABS_DIR="$(pwd)"
nix run github:esp0xdeadbeef/network-control-plane-model#compile-and-build-control-plane-model -- \
  "$LABS_DIR/examples/single-wan/intent.nix" \
  "$LABS_DIR/examples/single-wan/inventory-nixos.nix" \
  "$LABS_DIR/output-control-plane-model.json"
```

This produces a renderer-neutral control-plane artifact. It is an upstream
diagnostic artifact, not a renderer input.

### Produce renderer input

```text
CPM artifact
  -> network-realization-model
  -> validation against network-realization-schema
  -> validated canonical realization bundle
  -> selected network-renderer-*
```

The root flake and its lock must pin `network-realization-model`,
`network-realization-schema`, and the selected renderer before that path may
produce controlled GAMP evidence. A direct CPM-to-renderer command is a legacy
diagnostic or repository-local compatibility path only; it is not the
controlled renderer boundary.

A focused renderer repository test may instead begin with a fixture bundle
that has been validated against the pinned schema contract. Such a test proves
only renderer functionality and does not become controlled SMT, SIT, HAT, or
SAT evidence without the complete controlled repository-hop flow.

## Notes / limitations

- Policy intent can derive multiple parallel transit p2p links ("dedicated lanes") between:
  - downstream-selector <-> policy (one lane per access unit)
  - policy <-> upstream-selector (one lane per access unit and allowed uplink)
  These lane link names must be bound explicitly in `inventory-<renderer>.nix`.

- Cross-renderer examples keep `intent.nix` shared and carry full standalone renderer inventory files
  instead of forking the semantic intent.
