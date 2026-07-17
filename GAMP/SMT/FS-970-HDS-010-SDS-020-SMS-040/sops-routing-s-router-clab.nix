{ ... }:

{
  sops.secrets."fs970-clab-protected-reservations" = {
    key = "protected-reservations";
    mode = "0400";
    path = "/run/secrets/fs970-clab-protected-reservations.json";
    sopsFile = ./secrets/sops-s-router-clab.json;
  };
}
