let
  inventory = import ./getInventory.nix;
  inventorySops = import ./getInventorySops.nix;
in
inventory // { runtime = inventorySops.runtimeFacts; }
