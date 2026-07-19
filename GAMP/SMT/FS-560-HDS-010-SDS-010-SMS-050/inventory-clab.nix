let
  nixos = import ./inventory-nixos.nix;
in
nixos
// {
  meta = nixos.meta // {
    renderer = "clab";
  };
}
