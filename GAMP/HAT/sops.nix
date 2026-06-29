{ config ? {}, lib ? {}, pkgs ? null
, sopsFile ? ./../../active-lab/secrets/sops-s-router-clab.yaml
, runtimeFactSecrets ? []
, ... }:

let
  runtimeFactSecretDeclarations =
    builtins.listToAttrs (map
      (name: {
        inherit name;
        value = {
          key = name;
          mode = "0400";
          inherit sopsFile;
        };
      })
      runtimeFactSecrets);
in
{
  # Shared HAT lab sops module.
  #
  # PPPoE credentials: sops-nix decrypts from the host sops file (keys
  # "pppoe-username"/"pppoe-password") and places them at /run/secrets/hat-pppoe-*
  # via name-mediated path (secret name IS the runtime path).
  # The sops `key` option maps the secret name to the actual YAML key in the
  # encrypted file; sops-nix places the decrypted content at
  # /run/secrets/<secret-name> directly — no oneshot, no symlink.

  sops.secrets = runtimeFactSecretDeclarations // {
    "hat-pppoe-username" = {
      key = "pppoe-username";
      mode = "0400";
      inherit sopsFile;
    };
    "hat-pppoe-password" = {
      key = "pppoe-password";
      mode = "0400";
      inherit sopsFile;
    };
  };
}
