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

POC harnesses should run from `network-labs` and call the downstream APIs for
the layer under test. Downstream repos execute their normal behavior, but the
case source and synthetic boundary inputs remain here. A passing check in this
directory does not prove the skipped layers.
