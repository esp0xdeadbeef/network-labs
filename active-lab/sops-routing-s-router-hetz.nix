# active-lab/sops-routing-s-router-hetz.nix
{ ... }:

let
  sharedSopsFile = ./secrets/shared.yaml;
  hostSopsFile = ./secrets/sops-s-router-hetz.yaml;
in
{
  # Do NOT set sops.defaultSopsFile here if the host already has one.

  sops.secrets = {
    # Only routing/runtime secrets required by this router profile.

    "clients/client-01/identity/mac" = {
      sopsFile = sharedSopsFile;
    };

    "clients/client-01/identity/pppoeUsername" = {
      sopsFile = sharedSopsFile;
    };

    "clients/client-01/credentials/pppoePassword" = {
      sopsFile = sharedSopsFile;
    };

    # Example router-specific runtime secret.
    # Only keep this if the NixOS routing renderer actually needs it.
    # "router/pppoe/accessConcentratorPassword" = {
    #   sopsFile = hostSopsFile;
    # };
  };
}
