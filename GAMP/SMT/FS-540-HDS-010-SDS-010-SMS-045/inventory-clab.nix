import ./inventory-common.nix {
  host = "s-router-clab";
  recursiveClientBridge = "dns545cr";
  localClientBridge = "dns545cl";
  recursiveClientVlan = 415;
  localClientVlan = 416;
}
