{ ... }:

let
  sharedSopsFile = ./secrets/shared.yaml;
  hostSopsFile = ./secrets/sops-s-router-test-clients.yaml;
in
{
  # Do not set sops.defaultSopsFile here.
  # The base host profile owns generic/default SOPS behavior.
  #
  # This module should only declare lab-bound routing/runtime secrets.

  sops.secrets = {
    # Client identity needed by routing/runtime.
    "clients/client-01/identity/mac" = {
      sopsFile = sharedSopsFile;
    };

    "clients/client-01/identity/pppoeUsername" = {
      sopsFile = sharedSopsFile;
    };

    # Client credential needed by PPPoE/runtime.
    "clients/client-01/credentials/pppoePassword" = {
      sopsFile = sharedSopsFile;
    };

    # Keep host/backend secrets here only if routing/runtime actually needs them.
    #
    # "clab/registryToken" = {
    #   sopsFile = hostSopsFile;
    # };
  };
}
