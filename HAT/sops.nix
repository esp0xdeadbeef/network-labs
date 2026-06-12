# Shared HAT lab sops module.
# Imported into NixOS configs via sops-routing-<host>.nix → sops-for-renderers.
# Defines sops-nix secret declarations that wire encrypted credentials from
# the host sops file to runtime paths the renderer expects.
{ config, lib, pkgs, ... }:

{
  # PPPoE credentials — encrypted keys already exist in every s-router sops file
  # (secrets/s-router-*.yaml). sops-nix decrypts them at activation and places
  # them at /run/secrets/pppoe-*. The renderer expects /run/secrets/hat-pppoe-*
  # (CPM secret-source-contract mediates bare runtimePath names with /run/secrets
  # prefix and the inventory uses the hat-prefixed abstract names).
  # A symlink service bridges the naming gap so the renderer finds the files.
  sops.secrets."pppoe-username" = {
    mode = "0400";
  };
  sops.secrets."pppoe-password" = {
    mode = "0400";
  };

  systemd.services.hat-pppoe-secrets-symlink = {
    description = "Symlink sops-decrypted PPPoE credentials to CPM-mediated paths";
    wantedBy = [ "multi-user.target" ];
    before = [ "multi-user.target" ];
    after = [ "local-fs.target" ];
    unitConfig.DefaultDependencies = false;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "hat-pppoe-symlink-sops" ''
        set -eu
        ln -sf "${config.sops.secrets."pppoe-username".path}" /run/secrets/hat-pppoe-username
        ln -sf "${config.sops.secrets."pppoe-password".path}" /run/secrets/hat-pppoe-password
      '';
    };
  };
}
