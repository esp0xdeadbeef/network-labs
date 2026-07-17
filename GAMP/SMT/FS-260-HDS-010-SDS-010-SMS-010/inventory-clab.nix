import ./inventory-router.nix {
  host = "s-router-clab";
  sourceBridge = "f260csrc";
  sourceVlan = 395;
  destinationBridge = "f260cdst";
  destinationVlan = 396;
  containerlab = true;
}
