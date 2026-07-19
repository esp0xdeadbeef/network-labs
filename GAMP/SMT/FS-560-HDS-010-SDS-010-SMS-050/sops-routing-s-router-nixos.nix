{ ... }:

{
  sops.secrets."fs560-protected-reservations" = {
    key = "protected-reservations";
    mode = "0400";
    path = "/run/secrets/fs560-protected-reservations.json";
    sopsFile = ../FS-970-HDS-010-SDS-020-SMS-040/secrets/sops-s-router-nixos.json;
  };
}
