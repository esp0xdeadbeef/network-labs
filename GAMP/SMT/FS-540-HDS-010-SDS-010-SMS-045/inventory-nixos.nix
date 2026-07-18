import ./inventory-common.nix {
  host = "s-router-nixos";
  recursiveClientBridge = "dns545nr";
  localClientBridge = "dns545nl";
  recursiveClientVlan = 413;
  localClientVlan = 414;
}
