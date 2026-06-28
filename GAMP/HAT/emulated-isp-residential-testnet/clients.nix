let
  inventory = import ./inventory-nixos.nix;
  host = inventory.deployment.hosts.s-router-test-clients;
in
{
  activeLabClientStub = {
    kind = "hat-client-source";
    source = ./inventory-nixos.nix;
    scope = "s-router-test-clients HAT endpoint fixture source";
    traceIds = [
      "FS-720"
      "FS-725"
      "FS-730"
      "FS-740"
      "FS-750"
      "FS-760"
    ];
  };

  requiredEndpointClients = host.hat.requiredEndpointClients;
  clients = host.hat.endpointClients;
}
