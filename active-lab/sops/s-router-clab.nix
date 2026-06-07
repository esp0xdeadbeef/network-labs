{ ... }:

let
  sharedSopsFile = ../secrets/shared.yaml;
  hostSopsFile = ../secrets/sops-s-router-clab.yaml;
in
{
  sops.defaultSopsFile = hostSopsFile;

  sops.secrets = {
    "clab/nodePassword" = {
      sopsFile = hostSopsFile;
    };

    "clab/registryToken" = {
      sopsFile = hostSopsFile;
    };

    "clients/client-01/identity/mac" = {
      sopsFile = sharedSopsFile;
    };

    "clients/client-01/identity/circuitId" = {
      sopsFile = sharedSopsFile;
    };

    "clients/client-01/identity/pppoeUsername" = {
      sopsFile = sharedSopsFile;
    };

    "clients/client-01/credentials/pppoePassword" = {
      sopsFile = sharedSopsFile;
    };
  };
}
