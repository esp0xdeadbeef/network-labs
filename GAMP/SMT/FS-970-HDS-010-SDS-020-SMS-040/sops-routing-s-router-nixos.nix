{ ... }:

{
  sops.secrets."fs970-protected-reservations" = {
    key = "protected-reservations";
    mode = "0400";
    path = "/run/secrets/fs970-protected-reservations.json";
    sopsFile = ./secrets/sops-s-router-nixos.json;
  };
}
