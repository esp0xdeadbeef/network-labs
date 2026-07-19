import ./inventory-router.nix {
  host = "s-router-nixos";
  wanBridge = "f230nwan";
  wanVlan = 401;
  dmzBridge = "f230ndmz";
  dmzVlan = 402;
}
