import ../GAMP/HAT/sops.nix {
  sopsFile = ../active-lab/secrets/sops-s-router-nixos.yaml;
  runtimeFactSecrets = [
    "wireguard-mini-provider-private-key"
  ];
}
