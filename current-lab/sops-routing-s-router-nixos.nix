import ../GAMP/HAT/sops.nix {
  sopsFile = ../GAMP/SMT/FS-470-HDS-010-SDS-010-SMS-010/secrets/sops-s-router-nixos.yaml;
  runtimeFactSecrets = [
    "wireguard-mini-provider-private-key"
  ];
}
