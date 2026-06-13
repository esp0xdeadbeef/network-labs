{ config, lib, pkgs, ... }:

{
  # Shared HAT lab sops module.
  #
  # PPPoE credentials: sops-nix decrypts from the host sops file (keys
  # "pppoe-username"/"pppoe-password") and places them at /run/secrets/hat-pppoe-*
  # via name-mediated path (secret name IS the runtime path).
  # The sops `key` option maps the secret name to the actual YAML key in the
  # encrypted file; sops-nix places the decrypted content at
  # /run/secrets/<secret-name> directly — no oneshot, no symlink.

  # Point sops-nix to the network-labs encrypted secrets file.
  # The parent host-config-routers-without-network sets sops.defaultSopsFile
  # to nixos/secrets/s-router-nixos.yaml, but that file is encrypted for
  # different age recipients (l-esp-root, l-esp-deadbeef, s-router-test).
  # The network-labs file is encrypted for s-router-nixos recipient
  # (age1uzapfs5d9x0vt7qpfq9tyqwg8c9yquc745p8qhxulhew30yshcds4n64km),
  # which the s-router-nixos host can decrypt.
  sops.defaultSopsFile = ../active-lab/secrets/sops-s-router-clab.yaml;

  # The parent sets sops.age.keyFile to /persist/root/.config/sops/age/keys.txt.
  # For HAT lab (nixos-shell VM), /persist may not be available. Use the
  # standard sops-nix age key path instead.
  sops.age.keyFile = "/var/lib/sops-nix/age/key.txt";

  sops.secrets."hat-pppoe-username" = {
    key = "pppoe-username";
    mode = "0400";
  };
  sops.secrets."hat-pppoe-password" = {
    key = "pppoe-password";
    mode = "0400";
  };
}
