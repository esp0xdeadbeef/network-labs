{
  selection = import ./metadata.nix;
  intent = import ./intent.nix;
  sourcePaths = {
    intent = ./intent.nix;
    intentSRouterNixos = ./intent-s-router-nixos.nix;
    intentSRouterClab = ./intent-s-router-clab.nix;
    intentSRouterTestClients = ./intent-s-router-test-clients.nix;
    inventoryNixos = ./inventory-nixos.nix;
    inventoryClab = ./inventory-clab.nix;
    inventoryHetz = ./inventory-hetz.nix;
    clients = ./clients.nix;
    clientsSRouterTestClients = ./clients-s-router-test-clients.nix;
    inventoryTestClients = ./inventory-test-clients.nix;
    inventorySRouterNixos = ./inventory-s-router-nixos.nix;
    inventorySRouterClab = ./inventory-s-router-clab.nix;
    inventorySRouterTestClients = ./inventory-s-router-test-clients.nix;
    sops = ./sops.nix;
  };
}
