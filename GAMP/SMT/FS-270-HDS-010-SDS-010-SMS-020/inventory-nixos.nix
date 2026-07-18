import ./inventory-router.nix {
  host = "s-router-nixos";
  sourceBridge = "f270nsrc";
  sourceVlan = 407;
  destinationBridge = "f270ndst";
  destinationVlan = 408;
}
