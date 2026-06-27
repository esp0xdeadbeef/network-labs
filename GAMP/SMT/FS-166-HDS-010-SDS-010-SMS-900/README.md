# FS-166-HDS-010-SDS-010-SMS-900

Renderer-entry SMT row for the active-lab mini runtime sources.

This row owns the explicit CPM inputs used by the NixOS, NixOS clients,
Containerlab, WireGuard, and Nebula renderer mini-SMT checks. These are
renderer-input sources only; they do not claim HAT or SAT acceptance.

The active-lab shim points at `runtime-nixos-cpm.nix` for the global
`s-router-nixos` profile and at `renderer-input/minimal-clab-cpm.nix` and
`renderer-input/minimal-access-endpoint-cpm.nix` for the CLAB and client
renderer provenance stubs.
