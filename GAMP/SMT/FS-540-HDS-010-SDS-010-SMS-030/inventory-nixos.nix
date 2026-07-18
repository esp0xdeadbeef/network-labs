import ./inventory-common.nix {
  host = "s-router-nixos";
  recursiveClientBridge = "dns530nr";
  localClientBridge = "dns530nl";
  recursiveClientVlan = 403;
  localClientVlan = 404;
}
