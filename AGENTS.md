# AGENTS.md: example normalization rules

## Goal

Normalize every example under `examples/` into full standalone files:

* `intent.nix`
* `inventory-clab.nix`
* `inventory-nixos.nix`

Each example must be copyable and understandable without importing files from another example, local helper files, per-folder include files, or shared helper files.

## Current state before cleanup

There are currently 19 example directories under `examples/`.

Most examples are split across renderer-specific inventory files:

* `inventory-base.nix`
* `inventory-clab.nix`
* `inventory-nixos.nix`

Two examples currently only use `inventory-nixos.nix`:

* `tri-site-dual-wan-overlay-integration-static`
* `tri-site-dual-wan-overlay-integration-bgp`

A shared helper is imported by many examples:

* `examples/_shared-inventory-clab.nix`

Some examples also import files from other example directories:

* `examples/dual-wan-branch-overlay-bgp/inventory-base.nix` imports `examples/dual-wan-branch-overlay/inventory-base.nix`
* `examples/dual-wan-branch-overlay-bgp/inventory-nixos.nix` imports `examples/dual-wan-branch-overlay/inventory-nixos.nix`
* `examples/dual-wan-branch-overlay-bgp/intent.nix` imports `examples/dual-wan-branch-overlay/intent.nix`

The controlled SAT source is `GAMP/SAT/`, not an example. Do not treat it as an
example-normalization target. The root-level `sat/` path is legacy and must not
be used for new evidence or tests.

These example imports are the known sources of non-self-contained example behavior.

## Normalization rules

Before deleting or renaming anything:

1. Preserve existing case coverage, including:

   * single-WAN
   * dual-WAN / multi-WAN
   * BGP
   * VLAN trunking
   * overlays
   * dedicated transit lanes
   * renderer-specific inventory coverage
2. Inline shared helper content into the affected examples.
3. Inline cross-example imports into the importing example.
4. Keep renderer-specific inventory differences in full standalone renderer inventory files.
5. Ensure every example directory contains exactly the expected full files:

   * `intent.nix`
   * `inventory-clab.nix`
   * `inventory-nixos.nix`
6. Do not model BGP versus static routing as a single global example-wide switch. The routing choice must be expressible per relevant P2P link, because some links may need BGP while others remain static.
7. Keep core WAN-side behavior explicit in the example data. Do not hide core WAN-side routing behind normalization helpers or inferred defaults.

## Files that may be removed after inlining

These transitional helper files MUST be removed after their content has been folded into the final self-contained examples:

* `inventory-base.nix`
* `inventory.nix`
* `inventory-static.nix`
* `inventory-parts/`
* `profiles/`
* `examples/_shared-inventory-clab.nix`

Do not remove the required final files:

* `intent.nix`
* `inventory-clab.nix`
* `inventory-nixos.nix`

## Routing-mode requirements

BGP/static selection must remain granular enough to describe mixed routing modes inside one example.

Required behavior:

* A specific P2P link may use BGP.
* A different P2P link in the same example may use static routing.
* The example must not require choosing either “all BGP” or “all static” globally.
* Core WAN-side routing must stay hardcoded/explicit where required by the topology.

This prevents normalization from accidentally reducing coverage for mixed static/BGP cases.

## Expected end state

Each directory under `examples/` must be self-contained:

```text
examples/<case>/
├── intent.nix
├── inventory-clab.nix
└── inventory-nixos.nix
```

These must be full files, not thin wrappers around per-folder references or helper imports.

No example may import:

* another example directory
* `_shared-inventory-clab.nix`
* `inventory-base.nix`
* `inventory-static.nix`
* `inventory.nix`
* local helper files or directories such as `inventory-parts/`, `profiles/`
* local per-folder reference files used only to assemble the expected full files

Generated examples must still be readable Nix attrsets. Do not use `builtins.fromJSON`
payloads to compress example or lab files; compact ordinary Nix formatting is fine.

## Commit message

Normalize examples into standalone intent and inventory files
