import ./sops.nix {
  sopsFile = ./../../../active-lab/secrets/sops-s-router-nixos.yaml;
  runtimeFactSecrets = [
    "access-node-ipv6-prefix-esp0xdeadbeef-hetz-c-router-access-client"
    "access-node-ipv6-prefix-esp-clab-router-access-client"
    "access-node-ipv6-prefix-esp-clab-router-access-hostile"
    "access-node-ipv6-prefix-esp-hetz-router-access-client"
    "access-node-ipv6-prefix-esp-nixos-router-access-hostile"
    "access-node-ipv6-prefix-espbranch-clab-b-router-access-hostile"
    "hetzner-lighthouse-public-ipv4"
    "hetzner-public-ipv4"
    "hetzner-public-ipv6"
  ];
}
