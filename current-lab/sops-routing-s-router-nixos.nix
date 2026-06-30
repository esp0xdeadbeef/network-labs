{ ... }:

let
  sopsFile = ../active-lab/secrets/sops-s-router-nixos.yaml;
  mkProfileSecret = nodeName: fileName: {
    inherit sopsFile;
    owner = "root";
    mode = "0400";
    path = "/persist/nebula-runtime/profiles/${nodeName}/${fileName}";
  };
in
{
  sops.secrets = {
    "nebula-profile-lab-lighthouse-ca-crt" = mkProfileSecret "lab-lighthouse" "ca.crt";
    "nebula-profile-lab-lighthouse-crt" = mkProfileSecret "lab-lighthouse" "lab-lighthouse.crt";
    "nebula-profile-lab-lighthouse-key" = mkProfileSecret "lab-lighthouse" "lab-lighthouse.key";
    "nebula-profile-lab-client-nebula-ca-crt" = mkProfileSecret "lab-client-nebula" "ca.crt";
    "nebula-profile-lab-client-nebula-crt" = mkProfileSecret "lab-client-nebula" "lab-client-nebula.crt";
    "nebula-profile-lab-client-nebula-key" = mkProfileSecret "lab-client-nebula" "lab-client-nebula.key";
  };
}
