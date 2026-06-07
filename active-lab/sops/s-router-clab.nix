{ ... }:

let
  sharedSopsFile = ../secrets/shared.yaml;
  hostSopsFile = ../secrets/sops-s-router-clab.yaml;
in
{
  sops.secrets = {
    "clients/client-01/identity/mac" = {
      sopsFile = sharedSopsFile;
    };

    "clients/client-01/identity/pppoeUsername" = {
      sopsFile = sharedSopsFile;
    };

    "clients/client-01/credentials/pppoePassword" = {
      sopsFile = sharedSopsFile;
    };

    "clab/registryToken" = {
      sopsFile = hostSopsFile;
    };
  };
}
