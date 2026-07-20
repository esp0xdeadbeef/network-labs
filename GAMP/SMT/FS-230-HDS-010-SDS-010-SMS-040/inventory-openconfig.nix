import ./inventory-router.nix {
  host = "s-router-openconfig-construction";
  wanBridge = "f230owan";
  wanVlan = 405;
  dmzBridge = "f230odmz";
  dmzVlan = 406;
}
