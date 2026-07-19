import ./inventory-router.nix {
  host = "s-router-clab";
  wanBridge = "f230cwan";
  wanVlan = 403;
  dmzBridge = "f230cdmz";
  dmzVlan = 404;
  containerlab = true;
}
