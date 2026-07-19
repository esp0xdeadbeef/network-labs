{ ... }:

{
  sops.secrets."fs230-lab-dmz-ipv6-prefix" = {
    key = "protected-prefix";
    mode = "0400";
    path = "/run/secrets/fs230-lab-dmz-ipv6-prefix";
    sopsFile = ./secrets/sops-fs230.json;
  };
}
