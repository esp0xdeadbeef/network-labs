{ renderer ? "nixos" }:

if renderer == "clab" then
  import ./inventory-clab.nix
else if renderer == "nixos" then
  import ./inventory-nixos.nix
else
  throw "lab-sigma getInventory: renderer must be 'nixos' or 'clab'"
