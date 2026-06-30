{
  sops.secrets."wireguard-mini-provider-private-key" = {
    key = "wireguard-mini-provider-private-key";
    mode = "0400";
    sopsFile = ../GAMP/SMT/FS-470-HDS-010-SDS-010-SMS-010/secrets/sops-s-router-nixos.yaml;
  };
}
