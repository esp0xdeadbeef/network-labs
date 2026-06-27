{
  selection = import ./metadata.nix;
  intent = import ./intent.nix;
  sourcePaths = {
    intent = ./intent.nix;
    inventoryNixos = ./inventory-nixos.nix;
    inventoryClab = ./inventory-clab.nix;
    inventoryHetz = ./inventory-hetz.nix;
    clients = ./clients.nix;
    inventoryTestClients = ./inventory-test-clients.nix;
  };
}
