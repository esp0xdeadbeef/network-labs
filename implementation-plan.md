# Implementation Plan

Goal: make `network-labs` the canonical S88 example corpus: intent stays semantic, inventory stays realization-specific, and platform-specific variants are explicit instead of implicit.

## Current S88 posture

The repo already has the right conceptual split:

- `intent.nix` defines network meaning
- `inventory.nix` defines realization

The main drift is that examples are starting to serve multiple downstream consumers with slightly different requirements, but the repository structure and docs do not yet make those differences explicit enough.

## Main gaps

1. Example structure is only partially platform-specific.
   - Some examples already have `inventory-clab.nix` and `inventory-nixos.nix`.
   - The README still reads as though plain `inventory.nix` is universally sufficient.

2. NixOS-specific host uplink requirements are not surfaced clearly.
   - Multi-WAN examples can be valid semantically, but still fail the NixOS renderer without explicit host WAN binding.

3. Example purpose is documented, but coverage categories are not.
   - The corpus should distinguish:
     - semantic compiler/forwarding examples
     - cross-renderer conformance examples
     - platform-specific binding examples
     - negative contract examples

4. Overlay examples are now important enough to deserve a consistent pattern.
   - Intent-side overlay semantics
   - generic inventory realization
   - optional per-renderer inventory refinements
   - optional provisioning metadata

## Work items

1. Update `README.md` and `examples/README.md`.
   - Document a recommended example layout:
     - `intent.nix`
     - `inventory.nix`
     - optional `inventory-clab.nix`
     - optional `inventory-nixos.nix`
   - State clearly when renderer-specific inventory wrappers are expected.

2. Classify examples by contract role.
   - Add tags/categories in `examples/README.md`, for example:
     - baseline
     - multi-wan
     - overlay
     - BGP
     - cross-renderer
     - renderer-specific binding

3. Make cross-renderer examples explicit.
   - Mark which examples are expected to pass both containerlab and NixOS renderers.
   - For those examples, keep both `inventory-clab.nix` and `inventory-nixos.nix`.

4. Add one canonical “S88 full path” example family.
   - A multi-enterprise, multi-uplink, overlay example should be maintained specifically as a pipeline conformance case.
   - The current `dual-wan-branch-overlay` family is the right starting point.

5. Document platform-specific realization requirements, not as semantic meaning, but as explicit inventory bindings.
   - Example: NixOS host WAN uplink mapping.

## Exit criteria

- A contributor can add a new example without guessing where semantic data ends and platform-specific realization begins.
- Cross-renderer examples are obvious.
- Overlay examples follow one repeatable pattern.
- The repo acts as the shared S88 contract corpus rather than a loose pile of labs.

## Test impact

- Keep examples consumable by compiler, CPM, and both renderers where intended.
- Add per-example notes for expected stage coverage.
- Keep one explicit dual-site overlay example as the main cross-repo conformance fixture.
