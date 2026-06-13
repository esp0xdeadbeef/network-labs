{ config, lib, pkgs, ... }:

{
  # SAT lab sops module — emulated PPPoE ISP credentials.
  # sops-nix decrypts from the host sops file and places at
  # /run/secrets/<secret-name> via name-mediated path.

  sops.secrets."sat-pppoe-nixos-username" = {
    key = "sat-pppoe-nixos-username";
    mode = "0400";
  };
  sops.secrets."sat-pppoe-nixos-password" = {
    key = "sat-pppoe-nixos-password";
    mode = "0400";
  };
  sops.secrets."sat-pppoe-clab-username" = {
    key = "sat-pppoe-clab-username";
    mode = "0400";
  };
  sops.secrets."sat-pppoe-clab-password" = {
    key = "sat-pppoe-clab-password";
    mode = "0400";
  };
}
