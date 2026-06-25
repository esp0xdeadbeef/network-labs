let
  inventoryFor = hostName: import ./inventories/${hostName}.nix;
  secretFileFor = hostName: ./secrets/sops-${hostName}.yaml;
  mkSource =
    {
      intent ? ./intent.nix,
      clients ? ./clients.nix,
    }:
    {
      intent = import intent;
      clients = import clients;

      inherit inventoryFor secretFileFor;

      secretFiles = {
        shared = ./secrets/shared.yaml;
      };

      sourcePaths = {
        inherit intent clients;
      };
    };
in
(mkSource { })
// {
  inherit mkSource;
}
