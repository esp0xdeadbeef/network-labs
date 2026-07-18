import ./inventory-common.nix {
  host = "s-router-clab";
  recursiveClientBridge = "dns530cr";
  localClientBridge = "dns530cl";
  recursiveClientVlan = 405;
  localClientVlan = 406;
}
