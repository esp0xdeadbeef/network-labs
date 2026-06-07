let
  inventoryFor = hostName: import ./inventories/${hostName}.nix;
  secretFileFor = hostName: ./secrets/sops-${hostName}.yaml;
in
{
  intent = import ./intent.nix;
  clients = import ./clients.nix;

  inherit inventoryFor secretFileFor;

  secretFiles = {
    shared = ./secrets/shared.yaml;
  };
}
