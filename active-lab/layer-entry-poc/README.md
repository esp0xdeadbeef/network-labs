# active-lab layer-entry POC

This directory is a source-side POC for small, deterministic layer-entry checks.
It is not HAT or SAT evidence.

The intent is to let downstream repos start from a declared boundary without
inventing their own inputs:

- `intent-source`: use `../intent.nix` plus `../inventory-nixos.nix`;
- `compiler-output`: consume a network-labs-owned synthetic compiler-output
  fixture;
- `forwarding-model-input`: consume a network-labs-owned synthetic NFM-input
  fixture;
- `control-plane-input`: consume a network-labs-owned synthetic CPM-input
  fixture;
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

Renderer-entry POCs currently target `nixos`, `clab`, `wireguard`, and `nebula`.
The fixtures in `renderer-input/` are renderer inputs only. The renderer owns
materializing NixOS config, Containerlab topology, WireGuard provider runtime
modules, or Nebula runtime plans.

POC harnesses should run from `network-labs` and call the downstream APIs for
the layer under test. Downstream repos execute their normal behavior, but the
case source and synthetic boundary inputs remain here. A passing check in this
directory does not prove the skipped layers.
