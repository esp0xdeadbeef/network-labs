import ./inventory-router.nix {
  host = "s-router-nixos";
  sourceBridge = "f260nsrc";
  sourceVlan = 393;
  destinationBridge = "f260ndst";
  destinationVlan = 394;
}
