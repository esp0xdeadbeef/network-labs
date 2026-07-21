import ./inventory-common.nix {
  host = "s-router-clab";
  clientBridge = "dns540c";
  clientVlan = 412;
  clab = true;
}
