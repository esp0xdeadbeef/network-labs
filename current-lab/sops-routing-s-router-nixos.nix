{
  sops.secrets."wireguard-mini-provider-private-key" = {
    key = "wireguard-mini-provider-private-key";
    mode = "0400";
    sopsFile = ../GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-905/secrets/sops-s-router-nixos.yaml;
  };
}
