# GAMP SMT layer-entry POC

This directory is a source-side POC for small, deterministic layer-entry checks.
It is not HAT or SAT evidence.

The intent is to let downstream repos start from a declared boundary without
inventing their own inputs:

- `intent-source`: use `../../../active-lab/intent.nix` plus the explicit
  `../../../active-lab/inventory-nixos.nix` mini-SMT provenance stub;
- `compiler-output`: consume a network-labs-owned synthetic compiler-output
  fixture;
- `forwarding-model-input`: consume a network-labs-owned synthetic NFM-input
  fixture that is shaped like compiler output and can be consumed by NFM without
  running `network-compiler`;
- `control-plane-input`: consume a network-labs-owned synthetic CPM-input
  fixture containing precomputed forwarding-model output plus explicit
  realization inventory, so CPM can run without invoking compiler or NFM;
- `renderer-input`: consume a network-labs-owned CPM input/contract and pass
  that object directly to the downstream renderer/NixOS materialization path.

"Skipped" repositories are still in the POC path. They must emit their own
warning and pass through the received value, or normalize it to a Nix attrset,
without claiming the skipped semantic work:

- `network-compiler`: `WARN_LAYER_ENTRY_SKIPS_NETWORK_COMPILER`;
- `network-forwarding-model`: `WARN_LAYER_ENTRY_SKIPS_NFM`;
- `network-control-plane-model`: `WARN_LAYER_ENTRY_SKIPS_CPM`.

The explicit skip decisions are:

- `skip-network-compiler`: start at `forwarding-model-input`;
- `skip-network-compiler-and-nfm`: start at `control-plane-input`;
- `skip-network-compiler-nfm-and-cpm`: start at `renderer-input`.

Renderer-entry POCs currently target `nixos`, `nixos-clients`, `clab`,
`wireguard`, and `nebula`. The fixtures in `renderer-input/` are renderer
inputs only. The renderer owns materializing NixOS config, NixOS client endpoint
containers, Containerlab topology, WireGuard provider runtime modules, or
Nebula runtime plans.

POC harnesses should run from `network-labs` and call the downstream APIs for
the layer under test. Downstream repos execute their normal behavior, but the
case source and synthetic boundary inputs remain here. A passing check in this
directory does not prove the skipped layers. `tests/test-active-lab-layer-entry-construction-cycles.sh`
keeps the non-renderer boundaries honest by proving:

- compiler skip: compiler warns/pass-through, NFM consumes the synthetic input,
  CPM builds, and the NixOS renderer materializes containers;
- compiler+NFM skip: compiler and NFM warn/pass-through, CPM consumes the
  synthetic forwarding+realization input, and the NixOS renderer materializes
  containers;
- compiler+NFM+CPM skip: covered by the renderer-entry harness, which passes
  network-labs-owned renderer inputs directly to the renderers.

For runtime SMT evidence, use a mini runtime profile rather than these aggregate
layer-entry harnesses. The aggregate scripts prove wiring across boundaries; a
row-level SMT should prove one small runtime surface and then run the real
target lifecycle for that surface. Renderer mini-SMT rows are declared in
`../mini-smt/tests.nix` and are run independently with
`../../tests/run-active-lab-mini-smt.sh <mini-smt-id>`.

For row-specific SMT/SIT intent-source checks, use
`../mini-smt/intents/<mini-smt-id>/intent.nix` through `active-lab.mkSource`
rather than editing the global `../intent.nix`.
