{ renderer ? "nixos" }:

if renderer == "clab" || renderer == "nixos" then
  import ./inventory.nix
else
  throw "lab-sigma getInventory: renderer must be 'nixos' or 'clab'"
