let
  base = import ./inventory-base.nix;
  nixosBase = import ../dual-wan-branch-overlay/inventory-nixos.nix;
in
base
// {
  deployment = nixosBase.deployment;
}
