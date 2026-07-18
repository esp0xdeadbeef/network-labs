import ./inventory-router.nix {
  host = "s-router-clab";
  sourceBridge = "f270csrc";
  sourceVlan = 409;
  destinationBridge = "f270cdst";
  destinationVlan = 410;
  containerlab = true;
}
