# network-labs S88 Boundary

`network-labs` owns model input sources, not rendered runtime behavior.

## Enterprise

Enterprises and sites are declared by `intent.nix` files under `examples/` and
`labs/`.

## Site

Site intent defines tenants, services, overlays, uplinks, routing style, prefix
authority, and communication relations.

## Unit

Renderer inventories such as `inventory-nixos.nix`, `inventory-clab.nix`, and
FAT lab `inventory.nix` bind site intent to concrete hosts, interfaces,
bridges, VLANs, endpoints, secrets, and runtime fact sources.

## ControlModule

The lab repository has no renderer ControlModules. Its tests validate source
shape and model contracts before compiler, NFM, CPM, or renderer code consumes
the sources.

