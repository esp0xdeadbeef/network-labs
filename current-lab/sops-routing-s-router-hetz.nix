{ ... }:

let
  sharedSopsFile = ../GAMP/HAT/emulated-isp-residential-testnet/secrets/shared.yaml;
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
  };
}
