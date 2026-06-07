{
  site-a = {
    nebula-egress = {
      nodes.nixos-core-nebula = {
        addr4 = "100.96.44.1/32";
        addr6 = "fd42:dead:beef:9644::1/128";
      };
      provider = "nebula";
      runtimeNodes.nixos-core-nebula = {
        groups = [
          "hat"
          "nixos"
          "overlay"
        ];
        service = {
          interface = "nebula1";
          name = "nebula-runtime";
        };
      };
    };
    wireguard-egress = {
      nodes.nixos-core-wireguard-remote-egress = {
        addr4 = "10.66.44.1/32";
        addr6 = "fd42:dead:beef:6644::1/128";
      };
      provider = "wireguard";
      runtimeNodes.nixos-core-wireguard-remote-egress = {
        groups = [
          "hat"
          "nixos"
          "vpn"
        ];
        service = {
          interface = "wg-egress";
          name = "wireguard-runtime";
        };
      };
    };
    wireguard-host128 = {
      nodes.nixos-core-wireguard-host128 = {
        addr4 = "10.66.128.1/32";
        addr6 = "2001:db8:128::1/128";
      };
      provider = "wireguard";
      runtimeNodes.nixos-core-wireguard-host128 = {
        groups = [
          "hat"
          "nixos"
          "vpn"
        ];
        service = {
          interface = "wg-host128";
          name = "wireguard-runtime";
        };
      };
    };
  };

  site-b = {
    nebula-egress = {
      nodes.clab-core-nebula = {
        addr4 = "100.97.44.1/32";
        addr6 = "fd42:dead:feed:9744::1/128";
      };
      provider = "nebula";
      runtimeNodes.clab-core-nebula = {
        groups = [
          "hat"
          "clab"
          "overlay"
        ];
        service = {
          interface = "nebula1";
          name = "nebula-runtime";
        };
      };
    };
    wireguard-egress = {
      nodes.clab-core-wireguard-remote-egress = {
        addr4 = "10.67.44.1/32";
        addr6 = "fd42:dead:feed:6744::1/128";
      };
      provider = "wireguard";
      runtimeNodes.clab-core-wireguard-remote-egress = {
        groups = [
          "hat"
          "clab"
          "vpn"
        ];
        service = {
          interface = "wg-egress";
          name = "wireguard-runtime";
        };
      };
    };
    wireguard-host128 = {
      nodes.clab-core-wireguard-host128 = {
        addr4 = "10.66.128.2/32";
        addr6 = "2001:db8:128::2/128";
      };
      provider = "wireguard";
      runtimeNodes.clab-core-wireguard-host128 = {
        groups = [
          "hat"
          "clab"
          "vpn"
        ];
        service = {
          interface = "wg-host128";
          name = "wireguard-runtime";
        };
      };
    };
  };
}
