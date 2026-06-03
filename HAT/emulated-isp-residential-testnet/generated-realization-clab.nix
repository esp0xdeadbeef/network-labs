# Generated HAT fixture realization skeleton.
# Source: network-forwarding-model output for HAT/emulated-isp-residential-testnet/intent.nix.
# Inventory files may overlay fixture-specific uplinks, advertisements, and endpoint metadata.
{
  bridgeNetworks = {
    "br-site-a-p2p-nixos-access-client-nixos-downstream-selector" = { };
    "br-site-a-p2p-nixos-access-dmz-nixos-downstream-selector" = { };
    "br-site-a-p2p-nixos-access-guest-nixos-downstream-selector" = { };
    "br-site-a-p2p-nixos-access-iot-nixos-core-nebula" = { };
    "br-site-a-p2p-nixos-access-iot-nixos-core-wireguard-host128" = { };
    "br-site-a-p2p-nixos-access-iot-nixos-core-wireguard-remote-egress" = { };
    "br-site-a-p2p-nixos-access-iot-nixos-downstream-selector" = { };
    "br-site-a-p2p-nixos-access-management-nixos-downstream-selector" = { };
    "br-site-a-p2p-nixos-access-trusted-nixos-downstream-selector" = { };
    "br-site-a-p2p-nixos-access-work-nixos-downstream-selector" = { };
    "br-site-a-p2p-nixos-core-commercial-vpn-nixos-upstream-selector" = { };
    "br-site-a-p2p-nixos-core-nebula-nixos-upstream-selector" = { };
    "br-site-a-p2p-nixos-core-route-import-nixos-upstream-selector" = { };
    "br-site-a-p2p-nixos-core-testnet-host-isp-nixos-provider-handoff-access-a" = { };
    "br-site-a-p2p-nixos-core-testnet-host-isp-nixos-upstream-selector" = { };
    "br-site-a-p2p-nixos-core-testnet-routed-isp-nixos-provider-handoff-access-b" = { };
    "br-site-a-p2p-nixos-core-testnet-routed-isp-nixos-upstream-selector" = { };
    "br-site-a-p2p-nixos-core-upstream-vlan4-nixos-upstream-selector" = { };
    "br-site-a-p2p-nixos-core-wireguard-host128-nixos-upstream-selector" = { };
    "br-site-a-p2p-nixos-core-wireguard-remote-egress-nixos-upstream-selector" = { };
    "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-client" = { };
    "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-dmz" = { };
    "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-guest" = { };
    "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-iot" = { };
    "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-management" = { };
    "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-trusted" = { };
    "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-work" = { };
    "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-a" = { };
    "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-b" = { };
    "br-site-a-p2p-nixos-downstream-selector-nixos-provider-handoff-access-a" = { };
    "br-site-a-p2p-nixos-downstream-selector-nixos-provider-handoff-access-b" = { };
    "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-host-isp" = { };
    "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-routed-isp" = { };
    "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-guest--uplink-isp-a" = { };
    "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-nebula-egress" = { };
    "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-wireguard-egress" = { };
    "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-work--uplink-isp-a" = { };
    "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-isp-a" = { };
    "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-a" = { };
    "br-site-b-p2p-clab-access-client-clab-downstream-selector" = { };
    "br-site-b-p2p-clab-access-dmz-clab-downstream-selector" = { };
    "br-site-b-p2p-clab-access-guest-clab-downstream-selector" = { };
    "br-site-b-p2p-clab-access-iot-clab-core-nebula" = { };
    "br-site-b-p2p-clab-access-iot-clab-core-wireguard-host128" = { };
    "br-site-b-p2p-clab-access-iot-clab-core-wireguard-remote-egress" = { };
    "br-site-b-p2p-clab-access-iot-clab-downstream-selector" = { };
    "br-site-b-p2p-clab-access-management-clab-downstream-selector" = { };
    "br-site-b-p2p-clab-access-trusted-clab-downstream-selector" = { };
    "br-site-b-p2p-clab-access-work-clab-downstream-selector" = { };
    "br-site-b-p2p-clab-core-commercial-vpn-clab-upstream-selector" = { };
    "br-site-b-p2p-clab-core-nebula-clab-upstream-selector" = { };
    "br-site-b-p2p-clab-core-route-import-clab-upstream-selector" = { };
    "br-site-b-p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a" = { };
    "br-site-b-p2p-clab-core-testnet-host-isp-clab-upstream-selector" = { };
    "br-site-b-p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b" = { };
    "br-site-b-p2p-clab-core-testnet-routed-isp-clab-upstream-selector" = { };
    "br-site-b-p2p-clab-core-upstream-vlan4-clab-upstream-selector" = { };
    "br-site-b-p2p-clab-core-wireguard-host128-clab-upstream-selector" = { };
    "br-site-b-p2p-clab-core-wireguard-remote-egress-clab-upstream-selector" = { };
    "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-client" = { };
    "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-dmz" = { };
    "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-guest" = { };
    "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-iot" = { };
    "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-management" = { };
    "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-trusted" = { };
    "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-work" = { };
    "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-a" = { };
    "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-b" = { };
    "br-site-b-p2p-clab-downstream-selector-clab-provider-handoff-access-a" = { };
    "br-site-b-p2p-clab-downstream-selector-clab-provider-handoff-access-b" = { };
    "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-host-isp" = { };
    "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-routed-isp" = { };
    "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-guest--uplink-isp-a" = { };
    "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-nebula-egress" = { };
    "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-wireguard-egress" = { };
    "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-work--uplink-isp-a" = { };
    "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-isp-a" = { };
    "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-a" = { };
  };
  nodes = {
    "esp0xdeadbeef-site-a-nixos-access-client" = {
      "advertisements" = {
        "dhcp4" = { };
        "dhcpv6" = { };
        "ipv6Ra" = { };
      };
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "nixos-access-client";
        "site" = "site-a";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-nixos-access-client-nixos-downstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-access-client-p2p-nixos-access-client-nixos-downstream-selector";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-access-client-nixos-downstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-nixos-access-client-nixos-downstream-selector";
        };
      };
    };
    "esp0xdeadbeef-site-a-nixos-access-dmz" = {
      "advertisements" = {
        "dhcp4" = { };
        "dhcpv6" = { };
        "ipv6Ra" = { };
      };
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "nixos-access-dmz";
        "site" = "site-a";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-nixos-access-dmz-nixos-downstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-access-dmz-p2p-nixos-access-dmz-nixos-downstream-selector";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-access-dmz-nixos-downstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-nixos-access-dmz-nixos-downstream-selector";
        };
      };
    };
    "esp0xdeadbeef-site-a-nixos-access-guest" = {
      "advertisements" = {
        "dhcp4" = { };
        "dhcpv6" = { };
        "ipv6Ra" = { };
      };
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "nixos-access-guest";
        "site" = "site-a";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-nixos-access-guest-nixos-downstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-access-guest-p2p-nixos-access-guest-nixos-downstream-selector";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-access-guest-nixos-downstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-nixos-access-guest-nixos-downstream-selector";
        };
      };
    };
    "esp0xdeadbeef-site-a-nixos-access-iot" = {
      "advertisements" = {
        "dhcp4" = { };
        "dhcpv6" = { };
        "ipv6Ra" = { };
      };
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "nixos-access-iot";
        "site" = "site-a";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-nixos-access-iot-nixos-core-nebula" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-access-iot-p2p-nixos-access-iot-nixos-core-nebula";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-access-iot-nixos-core-nebula";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-nixos-access-iot-nixos-core-nebula";
        };
        "p2p-nixos-access-iot-nixos-core-wireguard-host128" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-access-iot-p2p-nixos-access-iot-nixos-core-wireguard-host128";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-access-iot-nixos-core-wireguard-host128";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens21";
          };
          "link" = "p2p-nixos-access-iot-nixos-core-wireguard-host128";
        };
        "p2p-nixos-access-iot-nixos-core-wireguard-remote-egress" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-access-iot-p2p-nixos-access-iot-nixos-core-wireguard-remote-egress";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-access-iot-nixos-core-wireguard-remote-egress";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens22";
          };
          "link" = "p2p-nixos-access-iot-nixos-core-wireguard-remote-egress";
        };
        "p2p-nixos-access-iot-nixos-downstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-access-iot-p2p-nixos-access-iot-nixos-downstream-selector";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-access-iot-nixos-downstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens23";
          };
          "link" = "p2p-nixos-access-iot-nixos-downstream-selector";
        };
      };
    };
    "esp0xdeadbeef-site-a-nixos-access-management" = {
      "advertisements" = {
        "dhcp4" = { };
        "dhcpv6" = { };
        "ipv6Ra" = { };
      };
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "nixos-access-management";
        "site" = "site-a";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-nixos-access-management-nixos-downstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-access-management-p2p-nixos-access-management-nixos-downstream-selector";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-access-management-nixos-downstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-nixos-access-management-nixos-downstream-selector";
        };
      };
    };
    "esp0xdeadbeef-site-a-nixos-access-trusted" = {
      "advertisements" = {
        "dhcp4" = { };
        "dhcpv6" = { };
        "ipv6Ra" = { };
      };
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "nixos-access-trusted";
        "site" = "site-a";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-nixos-access-trusted-nixos-downstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-access-trusted-p2p-nixos-access-trusted-nixos-downstream-selector";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-access-trusted-nixos-downstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-nixos-access-trusted-nixos-downstream-selector";
        };
      };
    };
    "esp0xdeadbeef-site-a-nixos-access-work" = {
      "advertisements" = {
        "dhcp4" = { };
        "dhcpv6" = { };
        "ipv6Ra" = { };
      };
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "nixos-access-work";
        "site" = "site-a";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-nixos-access-work-nixos-downstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-access-work-p2p-nixos-access-work-nixos-downstream-selector";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-access-work-nixos-downstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-nixos-access-work-nixos-downstream-selector";
        };
      };
    };
    "esp0xdeadbeef-site-a-nixos-core-commercial-vpn" = {
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "nixos-core-commercial-vpn";
        "site" = "site-a";
      };
      "platform" = "linux";
      "ports" = {
        "commercial-vpn" = {
          "attach" = {
            "bridge" = "br-clab-uplink-commercial-vpn";
            "kind" = "bridge";
          };
          "external" = true;
          "interface" = {
            "name" = "ens80";
          };
          "uplink" = "commercial-vpn";
        };
        "p2p-nixos-core-commercial-vpn-nixos-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-core-commercial-vpn-p2p-nixos-core-commercial-vpn-nixos-upstream-selector";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-core-commercial-vpn-nixos-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-nixos-core-commercial-vpn-nixos-upstream-selector";
        };
      };
    };
    "esp0xdeadbeef-site-a-nixos-core-nebula" = {
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "nixos-core-nebula";
        "site" = "site-a";
      };
      "platform" = "linux";
      "ports" = {
        "nebula-egress" = {
          "attach" = {
            "bridge" = "br-clab-uplink-nebula-egress";
            "kind" = "bridge";
          };
          "external" = true;
          "interface" = {
            "name" = "ens80";
          };
          "uplink" = "nebula-egress";
        };
        "p2p-nixos-access-iot-nixos-core-nebula" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-core-nebula-p2p-nixos-access-iot-nixos-core-nebula";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-access-iot-nixos-core-nebula";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-nixos-access-iot-nixos-core-nebula";
        };
        "p2p-nixos-core-nebula-nixos-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-core-nebula-p2p-nixos-core-nebula-nixos-upstream-selector";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-core-nebula-nixos-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens21";
          };
          "link" = "p2p-nixos-core-nebula-nixos-upstream-selector";
        };
      };
    };
    "esp0xdeadbeef-site-a-nixos-core-route-import" = {
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "nixos-core-route-import";
        "site" = "site-a";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-nixos-core-route-import-nixos-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-core-route-import-p2p-nixos-core-route-import-nixos-upstream-selector";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-core-route-import-nixos-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-nixos-core-route-import-nixos-upstream-selector";
        };
        "route-import" = {
          "attach" = {
            "bridge" = "br-clab-uplink-route-import";
            "kind" = "bridge";
          };
          "external" = true;
          "interface" = {
            "name" = "ens80";
          };
          "uplink" = "route-import";
        };
      };
    };
    "esp0xdeadbeef-site-a-nixos-core-testnet-host-isp" = {
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "nixos-core-testnet-host-isp";
        "site" = "site-a";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-nixos-core-testnet-host-isp-nixos-provider-handoff-access-a" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-core-testnet-host-isp-p2p-nixos-core-testnet-host-isp-nixos-provider-handoff-access-a";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-core-testnet-host-isp-nixos-provider-handoff-access-a";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-nixos-core-testnet-host-isp-nixos-provider-handoff-access-a";
        };
        "p2p-nixos-core-testnet-host-isp-nixos-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-core-testnet-host-isp-p2p-nixos-core-testnet-host-isp-nixos-upstream-selector";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-core-testnet-host-isp-nixos-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens21";
          };
          "link" = "p2p-nixos-core-testnet-host-isp-nixos-upstream-selector";
        };
        "testnet-host-isp" = {
          "attach" = {
            "bridge" = "br-t-host";
            "kind" = "bridge";
          };
          "external" = true;
          "interface" = {
            "name" = "ens80";
          };
          "uplink" = "testnet-host-isp";
        };
      };
    };
    "esp0xdeadbeef-site-a-nixos-core-testnet-routed-isp" = {
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "nixos-core-testnet-routed-isp";
        "site" = "site-a";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-nixos-core-testnet-routed-isp-nixos-provider-handoff-access-b" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-core-testnet-routed-isp-p2p-nixos-core-testnet-routed-isp-nixos-provider-handoff-access-b";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-core-testnet-routed-isp-nixos-provider-handoff-access-b";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-nixos-core-testnet-routed-isp-nixos-provider-handoff-access-b";
        };
        "p2p-nixos-core-testnet-routed-isp-nixos-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-core-testnet-routed-isp-p2p-nixos-core-testnet-routed-isp-nixos-upstream-selector";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-core-testnet-routed-isp-nixos-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens21";
          };
          "link" = "p2p-nixos-core-testnet-routed-isp-nixos-upstream-selector";
        };
        "testnet-routed-isp" = {
          "attach" = {
            "bridge" = "br-t-routed";
            "kind" = "bridge";
          };
          "external" = true;
          "interface" = {
            "name" = "ens80";
          };
          "uplink" = "testnet-routed-isp";
        };
      };
    };
    "esp0xdeadbeef-site-a-nixos-core-upstream-vlan4" = {
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "nixos-core-upstream-vlan4";
        "site" = "site-a";
      };
      "platform" = "linux";
      "ports" = {
        "isp-a" = {
          "attach" = {
            "bridge" = "br-uplink0";
            "kind" = "bridge";
            "parentUplink" = "uplink-isp-a";
          };
          "external" = true;
          "interface" = {
            "name" = "ens80";
          };
          "uplink" = "isp-a";
        };
        "p2p-nixos-core-upstream-vlan4-nixos-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-core-upstream-vlan4-p2p-nixos-core-upstream-vlan4-nixos-upstream-selector";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-core-upstream-vlan4-nixos-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-nixos-core-upstream-vlan4-nixos-upstream-selector";
        };
      };
    };
    "esp0xdeadbeef-site-a-nixos-core-wireguard-host128" = {
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "nixos-core-wireguard-host128";
        "site" = "site-a";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-nixos-access-iot-nixos-core-wireguard-host128" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-core-wireguard-host128-p2p-nixos-access-iot-nixos-core-wireguard-host128";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-access-iot-nixos-core-wireguard-host128";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-nixos-access-iot-nixos-core-wireguard-host128";
        };
        "p2p-nixos-core-wireguard-host128-nixos-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-core-wireguard-host128-p2p-nixos-core-wireguard-host128-nixos-upstream-selector";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-core-wireguard-host128-nixos-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens21";
          };
          "link" = "p2p-nixos-core-wireguard-host128-nixos-upstream-selector";
        };
        "wireguard-host128" = {
          "attach" = {
            "bridge" = "br-clab-uplink-wireguard-host128";
            "kind" = "bridge";
          };
          "external" = true;
          "interface" = {
            "name" = "ens80";
          };
          "uplink" = "wireguard-host128";
        };
      };
    };
    "esp0xdeadbeef-site-a-nixos-core-wireguard-remote-egress" = {
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "nixos-core-wireguard-remote-egress";
        "site" = "site-a";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-nixos-access-iot-nixos-core-wireguard-remote-egress" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-core-wireguard-remote-egress-p2p-nixos-access-iot-nixos-core-wireguard-remote-egress";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-access-iot-nixos-core-wireguard-remote-egress";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-nixos-access-iot-nixos-core-wireguard-remote-egress";
        };
        "p2p-nixos-core-wireguard-remote-egress-nixos-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-core-wireguard-remote-egress-p2p-nixos-core-wireguard-remote-egress-nixos-upstream-selector";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-core-wireguard-remote-egress-nixos-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens21";
          };
          "link" = "p2p-nixos-core-wireguard-remote-egress-nixos-upstream-selector";
        };
        "wireguard-egress" = {
          "attach" = {
            "bridge" = "br-clab-uplink-wireguard-egress";
            "kind" = "bridge";
          };
          "external" = true;
          "interface" = {
            "name" = "ens80";
          };
          "uplink" = "wireguard-egress";
        };
      };
    };
    "esp0xdeadbeef-site-a-nixos-downstream-selector" = {
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "nixos-downstream-selector";
        "site" = "site-a";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-nixos-access-client-nixos-downstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-access-client-nixos-downstream-selector";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-access-client-nixos-downstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-nixos-access-client-nixos-downstream-selector";
        };
        "p2p-nixos-access-dmz-nixos-downstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-access-dmz-nixos-downstream-selector";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-access-dmz-nixos-downstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens21";
          };
          "link" = "p2p-nixos-access-dmz-nixos-downstream-selector";
        };
        "p2p-nixos-access-guest-nixos-downstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-access-guest-nixos-downstream-selector";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-access-guest-nixos-downstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens22";
          };
          "link" = "p2p-nixos-access-guest-nixos-downstream-selector";
        };
        "p2p-nixos-access-iot-nixos-downstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-access-iot-nixos-downstream-selector";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-access-iot-nixos-downstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens23";
          };
          "link" = "p2p-nixos-access-iot-nixos-downstream-selector";
        };
        "p2p-nixos-access-management-nixos-downstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-access-management-nixos-downstream-selector";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-access-management-nixos-downstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens24";
          };
          "link" = "p2p-nixos-access-management-nixos-downstream-selector";
        };
        "p2p-nixos-access-trusted-nixos-downstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-access-trusted-nixos-downstream-selector";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-access-trusted-nixos-downstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens25";
          };
          "link" = "p2p-nixos-access-trusted-nixos-downstream-selector";
        };
        "p2p-nixos-access-work-nixos-downstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-access-work-nixos-downstream-selector";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-access-work-nixos-downstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens26";
          };
          "link" = "p2p-nixos-access-work-nixos-downstream-selector";
        };
        "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-client" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-client";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-client";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens27";
          };
          "link" = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-client";
        };
        "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-dmz" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-dmz";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-dmz";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens28";
          };
          "link" = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-dmz";
        };
        "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-guest" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-guest";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-guest";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens29";
          };
          "link" = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-guest";
        };
        "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-iot" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-iot";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-iot";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens30";
          };
          "link" = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-iot";
        };
        "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-management" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-management";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-management";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens31";
          };
          "link" = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-management";
        };
        "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-trusted" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-trusted";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-trusted";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens32";
          };
          "link" = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-trusted";
        };
        "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-work" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-work";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-work";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens33";
          };
          "link" = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-work";
        };
        "p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-a" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-a";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-a";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens34";
          };
          "link" = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-a";
        };
        "p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-b" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-b";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-b";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens35";
          };
          "link" = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-b";
        };
        "p2p-nixos-downstream-selector-nixos-provider-handoff-access-a" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-downstream-selector-nixos-provider-handoff-access-a";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-downstream-selector-nixos-provider-handoff-access-a";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens36";
          };
          "link" = "p2p-nixos-downstream-selector-nixos-provider-handoff-access-a";
        };
        "p2p-nixos-downstream-selector-nixos-provider-handoff-access-b" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-downstream-selector-nixos-provider-handoff-access-b";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-downstream-selector-nixos-provider-handoff-access-b";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens37";
          };
          "link" = "p2p-nixos-downstream-selector-nixos-provider-handoff-access-b";
        };
      };
    };
    "esp0xdeadbeef-site-a-nixos-policy" = {
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "nixos-policy";
        "site" = "site-a";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-client" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-client";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-client";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-client";
        };
        "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-dmz" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-dmz";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-dmz";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens21";
          };
          "link" = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-dmz";
        };
        "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-guest" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-guest";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-guest";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens22";
          };
          "link" = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-guest";
        };
        "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-iot" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-iot";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-iot";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens23";
          };
          "link" = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-iot";
        };
        "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-management" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-management";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-management";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens24";
          };
          "link" = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-management";
        };
        "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-trusted" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-trusted";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-trusted";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens25";
          };
          "link" = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-trusted";
        };
        "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-work" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-work";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-work";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens26";
          };
          "link" = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-work";
        };
        "p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-a" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-a";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-a";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens27";
          };
          "link" = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-a";
        };
        "p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-b" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-b";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-b";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens28";
          };
          "link" = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-b";
        };
        "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-host-isp" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-host-isp";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-host-isp";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens29";
          };
          "link" = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-host-isp";
        };
        "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-routed-isp" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-routed-isp";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-routed-isp";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens30";
          };
          "link" = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-routed-isp";
        };
        "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-guest--uplink-isp-a" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-guest--uplink-isp-a";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-guest--uplink-isp-a";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens31";
          };
          "link" = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-guest--uplink-isp-a";
        };
        "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-nebula-egress" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-nebula-egress";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-nebula-egress";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens32";
          };
          "link" = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-nebula-egress";
        };
        "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-wireguard-egress" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-wireguard-egress";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-wireguard-egress";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens33";
          };
          "link" = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-wireguard-egress";
        };
        "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-work--uplink-isp-a" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-work--uplink-isp-a";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-work--uplink-isp-a";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens34";
          };
          "link" = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-work--uplink-isp-a";
        };
        "p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-isp-a" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-isp-a";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-isp-a";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens35";
          };
          "link" = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-isp-a";
        };
        "p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-a" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-a";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-a";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens36";
          };
          "link" = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-a";
        };
      };
    };
    "esp0xdeadbeef-site-a-nixos-provider-handoff-access-a" = {
      "advertisements" = {
        "dhcp4" = { };
        "dhcpv6" = { };
        "ipv6Ra" = { };
      };
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "nixos-provider-handoff-access-a";
        "site" = "site-a";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-nixos-core-testnet-host-isp-nixos-provider-handoff-access-a" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-provider-handoff-access-a-p2p-nixos-core-testnet-host-isp-nixos-provider-handoff-access-a";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-core-testnet-host-isp-nixos-provider-handoff-access-a";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-nixos-core-testnet-host-isp-nixos-provider-handoff-access-a";
        };
        "p2p-nixos-downstream-selector-nixos-provider-handoff-access-a" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-provider-handoff-access-a-p2p-nixos-downstream-selector-nixos-provider-handoff-access-a";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-downstream-selector-nixos-provider-handoff-access-a";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens21";
          };
          "link" = "p2p-nixos-downstream-selector-nixos-provider-handoff-access-a";
        };
      };
    };
    "esp0xdeadbeef-site-a-nixos-provider-handoff-access-b" = {
      "advertisements" = {
        "dhcp4" = { };
        "dhcpv6" = { };
        "ipv6Ra" = { };
      };
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "nixos-provider-handoff-access-b";
        "site" = "site-a";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-nixos-core-testnet-routed-isp-nixos-provider-handoff-access-b" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-provider-handoff-access-b-p2p-nixos-core-testnet-routed-isp-nixos-provider-handoff-access-b";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-core-testnet-routed-isp-nixos-provider-handoff-access-b";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-nixos-core-testnet-routed-isp-nixos-provider-handoff-access-b";
        };
        "p2p-nixos-downstream-selector-nixos-provider-handoff-access-b" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-provider-handoff-access-b-p2p-nixos-downstream-selector-nixos-provider-handoff-access-b";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-downstream-selector-nixos-provider-handoff-access-b";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens21";
          };
          "link" = "p2p-nixos-downstream-selector-nixos-provider-handoff-access-b";
        };
      };
    };
    "esp0xdeadbeef-site-a-nixos-upstream-selector" = {
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "nixos-upstream-selector";
        "site" = "site-a";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-nixos-core-commercial-vpn-nixos-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-core-commercial-vpn-nixos-upstream-selector";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-core-commercial-vpn-nixos-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-nixos-core-commercial-vpn-nixos-upstream-selector";
        };
        "p2p-nixos-core-nebula-nixos-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-core-nebula-nixos-upstream-selector";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-core-nebula-nixos-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens21";
          };
          "link" = "p2p-nixos-core-nebula-nixos-upstream-selector";
        };
        "p2p-nixos-core-route-import-nixos-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-core-route-import-nixos-upstream-selector";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-core-route-import-nixos-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens22";
          };
          "link" = "p2p-nixos-core-route-import-nixos-upstream-selector";
        };
        "p2p-nixos-core-testnet-host-isp-nixos-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-core-testnet-host-isp-nixos-upstream-selector";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-core-testnet-host-isp-nixos-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens23";
          };
          "link" = "p2p-nixos-core-testnet-host-isp-nixos-upstream-selector";
        };
        "p2p-nixos-core-testnet-routed-isp-nixos-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-core-testnet-routed-isp-nixos-upstream-selector";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-core-testnet-routed-isp-nixos-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens24";
          };
          "link" = "p2p-nixos-core-testnet-routed-isp-nixos-upstream-selector";
        };
        "p2p-nixos-core-upstream-vlan4-nixos-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-core-upstream-vlan4-nixos-upstream-selector";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-core-upstream-vlan4-nixos-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens25";
          };
          "link" = "p2p-nixos-core-upstream-vlan4-nixos-upstream-selector";
        };
        "p2p-nixos-core-wireguard-host128-nixos-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-core-wireguard-host128-nixos-upstream-selector";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-core-wireguard-host128-nixos-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens26";
          };
          "link" = "p2p-nixos-core-wireguard-host128-nixos-upstream-selector";
        };
        "p2p-nixos-core-wireguard-remote-egress-nixos-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-core-wireguard-remote-egress-nixos-upstream-selector";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-core-wireguard-remote-egress-nixos-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens27";
          };
          "link" = "p2p-nixos-core-wireguard-remote-egress-nixos-upstream-selector";
        };
        "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-host-isp" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-host-isp";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-host-isp";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens28";
          };
          "link" = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-host-isp";
        };
        "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-routed-isp" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-routed-isp";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-routed-isp";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens29";
          };
          "link" = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-routed-isp";
        };
        "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-guest--uplink-isp-a" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-guest--uplink-isp-a";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-guest--uplink-isp-a";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens30";
          };
          "link" = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-guest--uplink-isp-a";
        };
        "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-nebula-egress" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-nebula-egress";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-nebula-egress";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens31";
          };
          "link" = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-nebula-egress";
        };
        "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-wireguard-egress" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-wireguard-egress";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-wireguard-egress";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens32";
          };
          "link" = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-wireguard-egress";
        };
        "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-work--uplink-isp-a" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-work--uplink-isp-a";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-work--uplink-isp-a";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens33";
          };
          "link" = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-work--uplink-isp-a";
        };
        "p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-isp-a" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-isp-a";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-isp-a";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens34";
          };
          "link" = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-isp-a";
        };
        "p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-a" = {
          "adapterName" = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-a";
          "attach" = {
            "bridge" = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-a";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens35";
          };
          "link" = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-a";
        };
      };
    };
    "esp0xdeadbeef-site-b-clab-access-client" = {
      "advertisements" = {
        "dhcp4" = { };
        "dhcpv6" = { };
        "ipv6Ra" = { };
      };
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "clab-access-client";
        "site" = "site-b";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-clab-access-client-clab-downstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-access-client-p2p-clab-access-client-clab-downstream-selector";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-access-client-clab-downstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-clab-access-client-clab-downstream-selector";
        };
      };
    };
    "esp0xdeadbeef-site-b-clab-access-dmz" = {
      "advertisements" = {
        "dhcp4" = { };
        "dhcpv6" = { };
        "ipv6Ra" = { };
      };
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "clab-access-dmz";
        "site" = "site-b";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-clab-access-dmz-clab-downstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-access-dmz-p2p-clab-access-dmz-clab-downstream-selector";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-access-dmz-clab-downstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-clab-access-dmz-clab-downstream-selector";
        };
      };
    };
    "esp0xdeadbeef-site-b-clab-access-guest" = {
      "advertisements" = {
        "dhcp4" = { };
        "dhcpv6" = { };
        "ipv6Ra" = { };
      };
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "clab-access-guest";
        "site" = "site-b";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-clab-access-guest-clab-downstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-access-guest-p2p-clab-access-guest-clab-downstream-selector";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-access-guest-clab-downstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-clab-access-guest-clab-downstream-selector";
        };
      };
    };
    "esp0xdeadbeef-site-b-clab-access-iot" = {
      "advertisements" = {
        "dhcp4" = { };
        "dhcpv6" = { };
        "ipv6Ra" = { };
      };
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "clab-access-iot";
        "site" = "site-b";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-clab-access-iot-clab-core-nebula" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-access-iot-p2p-clab-access-iot-clab-core-nebula";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-access-iot-clab-core-nebula";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-clab-access-iot-clab-core-nebula";
        };
        "p2p-clab-access-iot-clab-core-wireguard-host128" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-access-iot-p2p-clab-access-iot-clab-core-wireguard-host128";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-access-iot-clab-core-wireguard-host128";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens21";
          };
          "link" = "p2p-clab-access-iot-clab-core-wireguard-host128";
        };
        "p2p-clab-access-iot-clab-core-wireguard-remote-egress" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-access-iot-p2p-clab-access-iot-clab-core-wireguard-remote-egress";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-access-iot-clab-core-wireguard-remote-egress";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens22";
          };
          "link" = "p2p-clab-access-iot-clab-core-wireguard-remote-egress";
        };
        "p2p-clab-access-iot-clab-downstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-access-iot-p2p-clab-access-iot-clab-downstream-selector";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-access-iot-clab-downstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens23";
          };
          "link" = "p2p-clab-access-iot-clab-downstream-selector";
        };
      };
    };
    "esp0xdeadbeef-site-b-clab-access-management" = {
      "advertisements" = {
        "dhcp4" = { };
        "dhcpv6" = { };
        "ipv6Ra" = { };
      };
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "clab-access-management";
        "site" = "site-b";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-clab-access-management-clab-downstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-access-management-p2p-clab-access-management-clab-downstream-selector";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-access-management-clab-downstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-clab-access-management-clab-downstream-selector";
        };
      };
    };
    "esp0xdeadbeef-site-b-clab-access-trusted" = {
      "advertisements" = {
        "dhcp4" = { };
        "dhcpv6" = { };
        "ipv6Ra" = { };
      };
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "clab-access-trusted";
        "site" = "site-b";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-clab-access-trusted-clab-downstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-access-trusted-p2p-clab-access-trusted-clab-downstream-selector";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-access-trusted-clab-downstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-clab-access-trusted-clab-downstream-selector";
        };
      };
    };
    "esp0xdeadbeef-site-b-clab-access-work" = {
      "advertisements" = {
        "dhcp4" = { };
        "dhcpv6" = { };
        "ipv6Ra" = { };
      };
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "clab-access-work";
        "site" = "site-b";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-clab-access-work-clab-downstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-access-work-p2p-clab-access-work-clab-downstream-selector";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-access-work-clab-downstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-clab-access-work-clab-downstream-selector";
        };
      };
    };
    "esp0xdeadbeef-site-b-clab-core-commercial-vpn" = {
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "clab-core-commercial-vpn";
        "site" = "site-b";
      };
      "platform" = "linux";
      "ports" = {
        "commercial-vpn" = {
          "attach" = {
            "bridge" = "br-clab-uplink-commercial-vpn";
            "kind" = "bridge";
          };
          "external" = true;
          "interface" = {
            "name" = "ens80";
          };
          "uplink" = "commercial-vpn";
        };
        "p2p-clab-core-commercial-vpn-clab-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-core-commercial-vpn-p2p-clab-core-commercial-vpn-clab-upstream-selector";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-core-commercial-vpn-clab-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-clab-core-commercial-vpn-clab-upstream-selector";
        };
      };
    };
    "esp0xdeadbeef-site-b-clab-core-nebula" = {
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "clab-core-nebula";
        "site" = "site-b";
      };
      "platform" = "linux";
      "ports" = {
        "nebula-egress" = {
          "attach" = {
            "bridge" = "br-clab-uplink-nebula-egress";
            "kind" = "bridge";
          };
          "external" = true;
          "interface" = {
            "name" = "ens80";
          };
          "uplink" = "nebula-egress";
        };
        "p2p-clab-access-iot-clab-core-nebula" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-core-nebula-p2p-clab-access-iot-clab-core-nebula";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-access-iot-clab-core-nebula";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-clab-access-iot-clab-core-nebula";
        };
        "p2p-clab-core-nebula-clab-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-core-nebula-p2p-clab-core-nebula-clab-upstream-selector";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-core-nebula-clab-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens21";
          };
          "link" = "p2p-clab-core-nebula-clab-upstream-selector";
        };
      };
    };
    "esp0xdeadbeef-site-b-clab-core-route-import" = {
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "clab-core-route-import";
        "site" = "site-b";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-clab-core-route-import-clab-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-core-route-import-p2p-clab-core-route-import-clab-upstream-selector";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-core-route-import-clab-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-clab-core-route-import-clab-upstream-selector";
        };
        "route-import" = {
          "attach" = {
            "bridge" = "br-clab-uplink-route-import";
            "kind" = "bridge";
          };
          "external" = true;
          "interface" = {
            "name" = "ens80";
          };
          "uplink" = "route-import";
        };
      };
    };
    "esp0xdeadbeef-site-b-clab-core-testnet-host-isp" = {
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "clab-core-testnet-host-isp";
        "site" = "site-b";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-core-testnet-host-isp-p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a";
        };
        "p2p-clab-core-testnet-host-isp-clab-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-core-testnet-host-isp-p2p-clab-core-testnet-host-isp-clab-upstream-selector";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-core-testnet-host-isp-clab-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens21";
          };
          "link" = "p2p-clab-core-testnet-host-isp-clab-upstream-selector";
        };
        "testnet-host-isp" = {
          "attach" = {
            "bridge" = "br-t-host";
            "kind" = "bridge";
          };
          "external" = true;
          "interface" = {
            "name" = "ens80";
          };
          "uplink" = "testnet-host-isp";
        };
      };
    };
    "esp0xdeadbeef-site-b-clab-core-testnet-routed-isp" = {
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "clab-core-testnet-routed-isp";
        "site" = "site-b";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-core-testnet-routed-isp-p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b";
        };
        "p2p-clab-core-testnet-routed-isp-clab-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-core-testnet-routed-isp-p2p-clab-core-testnet-routed-isp-clab-upstream-selector";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-core-testnet-routed-isp-clab-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens21";
          };
          "link" = "p2p-clab-core-testnet-routed-isp-clab-upstream-selector";
        };
        "testnet-routed-isp" = {
          "attach" = {
            "bridge" = "br-t-routed";
            "kind" = "bridge";
          };
          "external" = true;
          "interface" = {
            "name" = "ens80";
          };
          "uplink" = "testnet-routed-isp";
        };
      };
    };
    "esp0xdeadbeef-site-b-clab-core-upstream-vlan4" = {
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "clab-core-upstream-vlan4";
        "site" = "site-b";
      };
      "platform" = "linux";
      "ports" = {
        "isp-a" = {
          "attach" = {
            "bridge" = "br-uplink0";
            "kind" = "bridge";
            "parentUplink" = "uplink-isp-a";
          };
          "external" = true;
          "interface" = {
            "name" = "ens80";
          };
          "uplink" = "isp-a";
        };
        "p2p-clab-core-upstream-vlan4-clab-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-core-upstream-vlan4-p2p-clab-core-upstream-vlan4-clab-upstream-selector";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-core-upstream-vlan4-clab-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-clab-core-upstream-vlan4-clab-upstream-selector";
        };
      };
    };
    "esp0xdeadbeef-site-b-clab-core-wireguard-host128" = {
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "clab-core-wireguard-host128";
        "site" = "site-b";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-clab-access-iot-clab-core-wireguard-host128" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-core-wireguard-host128-p2p-clab-access-iot-clab-core-wireguard-host128";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-access-iot-clab-core-wireguard-host128";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-clab-access-iot-clab-core-wireguard-host128";
        };
        "p2p-clab-core-wireguard-host128-clab-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-core-wireguard-host128-p2p-clab-core-wireguard-host128-clab-upstream-selector";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-core-wireguard-host128-clab-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens21";
          };
          "link" = "p2p-clab-core-wireguard-host128-clab-upstream-selector";
        };
        "wireguard-host128" = {
          "attach" = {
            "bridge" = "br-clab-uplink-wireguard-host128";
            "kind" = "bridge";
          };
          "external" = true;
          "interface" = {
            "name" = "ens80";
          };
          "uplink" = "wireguard-host128";
        };
      };
    };
    "esp0xdeadbeef-site-b-clab-core-wireguard-remote-egress" = {
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "clab-core-wireguard-remote-egress";
        "site" = "site-b";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-clab-access-iot-clab-core-wireguard-remote-egress" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-core-wireguard-remote-egress-p2p-clab-access-iot-clab-core-wireguard-remote-egress";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-access-iot-clab-core-wireguard-remote-egress";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-clab-access-iot-clab-core-wireguard-remote-egress";
        };
        "p2p-clab-core-wireguard-remote-egress-clab-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-core-wireguard-remote-egress-p2p-clab-core-wireguard-remote-egress-clab-upstream-selector";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-core-wireguard-remote-egress-clab-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens21";
          };
          "link" = "p2p-clab-core-wireguard-remote-egress-clab-upstream-selector";
        };
        "wireguard-egress" = {
          "attach" = {
            "bridge" = "br-clab-uplink-wireguard-egress";
            "kind" = "bridge";
          };
          "external" = true;
          "interface" = {
            "name" = "ens80";
          };
          "uplink" = "wireguard-egress";
        };
      };
    };
    "esp0xdeadbeef-site-b-clab-downstream-selector" = {
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "clab-downstream-selector";
        "site" = "site-b";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-clab-access-client-clab-downstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-access-client-clab-downstream-selector";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-access-client-clab-downstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-clab-access-client-clab-downstream-selector";
        };
        "p2p-clab-access-dmz-clab-downstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-access-dmz-clab-downstream-selector";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-access-dmz-clab-downstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens21";
          };
          "link" = "p2p-clab-access-dmz-clab-downstream-selector";
        };
        "p2p-clab-access-guest-clab-downstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-access-guest-clab-downstream-selector";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-access-guest-clab-downstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens22";
          };
          "link" = "p2p-clab-access-guest-clab-downstream-selector";
        };
        "p2p-clab-access-iot-clab-downstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-access-iot-clab-downstream-selector";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-access-iot-clab-downstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens23";
          };
          "link" = "p2p-clab-access-iot-clab-downstream-selector";
        };
        "p2p-clab-access-management-clab-downstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-access-management-clab-downstream-selector";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-access-management-clab-downstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens24";
          };
          "link" = "p2p-clab-access-management-clab-downstream-selector";
        };
        "p2p-clab-access-trusted-clab-downstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-access-trusted-clab-downstream-selector";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-access-trusted-clab-downstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens25";
          };
          "link" = "p2p-clab-access-trusted-clab-downstream-selector";
        };
        "p2p-clab-access-work-clab-downstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-access-work-clab-downstream-selector";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-access-work-clab-downstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens26";
          };
          "link" = "p2p-clab-access-work-clab-downstream-selector";
        };
        "p2p-clab-downstream-selector-clab-policy--access-clab-access-client" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-downstream-selector-clab-policy--access-clab-access-client";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-client";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens27";
          };
          "link" = "p2p-clab-downstream-selector-clab-policy--access-clab-access-client";
        };
        "p2p-clab-downstream-selector-clab-policy--access-clab-access-dmz" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-downstream-selector-clab-policy--access-clab-access-dmz";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-dmz";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens28";
          };
          "link" = "p2p-clab-downstream-selector-clab-policy--access-clab-access-dmz";
        };
        "p2p-clab-downstream-selector-clab-policy--access-clab-access-guest" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-downstream-selector-clab-policy--access-clab-access-guest";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-guest";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens29";
          };
          "link" = "p2p-clab-downstream-selector-clab-policy--access-clab-access-guest";
        };
        "p2p-clab-downstream-selector-clab-policy--access-clab-access-iot" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-downstream-selector-clab-policy--access-clab-access-iot";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-iot";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens30";
          };
          "link" = "p2p-clab-downstream-selector-clab-policy--access-clab-access-iot";
        };
        "p2p-clab-downstream-selector-clab-policy--access-clab-access-management" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-downstream-selector-clab-policy--access-clab-access-management";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-management";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens31";
          };
          "link" = "p2p-clab-downstream-selector-clab-policy--access-clab-access-management";
        };
        "p2p-clab-downstream-selector-clab-policy--access-clab-access-trusted" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-downstream-selector-clab-policy--access-clab-access-trusted";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-trusted";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens32";
          };
          "link" = "p2p-clab-downstream-selector-clab-policy--access-clab-access-trusted";
        };
        "p2p-clab-downstream-selector-clab-policy--access-clab-access-work" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-downstream-selector-clab-policy--access-clab-access-work";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-work";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens33";
          };
          "link" = "p2p-clab-downstream-selector-clab-policy--access-clab-access-work";
        };
        "p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-a" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-a";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-a";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens34";
          };
          "link" = "p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-a";
        };
        "p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-b" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-b";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-b";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens35";
          };
          "link" = "p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-b";
        };
        "p2p-clab-downstream-selector-clab-provider-handoff-access-a" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-downstream-selector-clab-provider-handoff-access-a";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-downstream-selector-clab-provider-handoff-access-a";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens36";
          };
          "link" = "p2p-clab-downstream-selector-clab-provider-handoff-access-a";
        };
        "p2p-clab-downstream-selector-clab-provider-handoff-access-b" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-downstream-selector-clab-provider-handoff-access-b";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-downstream-selector-clab-provider-handoff-access-b";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens37";
          };
          "link" = "p2p-clab-downstream-selector-clab-provider-handoff-access-b";
        };
      };
    };
    "esp0xdeadbeef-site-b-clab-policy" = {
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "clab-policy";
        "site" = "site-b";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-clab-downstream-selector-clab-policy--access-clab-access-client" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-downstream-selector-clab-policy--access-clab-access-client";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-client";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-clab-downstream-selector-clab-policy--access-clab-access-client";
        };
        "p2p-clab-downstream-selector-clab-policy--access-clab-access-dmz" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-downstream-selector-clab-policy--access-clab-access-dmz";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-dmz";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens21";
          };
          "link" = "p2p-clab-downstream-selector-clab-policy--access-clab-access-dmz";
        };
        "p2p-clab-downstream-selector-clab-policy--access-clab-access-guest" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-downstream-selector-clab-policy--access-clab-access-guest";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-guest";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens22";
          };
          "link" = "p2p-clab-downstream-selector-clab-policy--access-clab-access-guest";
        };
        "p2p-clab-downstream-selector-clab-policy--access-clab-access-iot" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-downstream-selector-clab-policy--access-clab-access-iot";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-iot";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens23";
          };
          "link" = "p2p-clab-downstream-selector-clab-policy--access-clab-access-iot";
        };
        "p2p-clab-downstream-selector-clab-policy--access-clab-access-management" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-downstream-selector-clab-policy--access-clab-access-management";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-management";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens24";
          };
          "link" = "p2p-clab-downstream-selector-clab-policy--access-clab-access-management";
        };
        "p2p-clab-downstream-selector-clab-policy--access-clab-access-trusted" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-downstream-selector-clab-policy--access-clab-access-trusted";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-trusted";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens25";
          };
          "link" = "p2p-clab-downstream-selector-clab-policy--access-clab-access-trusted";
        };
        "p2p-clab-downstream-selector-clab-policy--access-clab-access-work" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-downstream-selector-clab-policy--access-clab-access-work";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-work";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens26";
          };
          "link" = "p2p-clab-downstream-selector-clab-policy--access-clab-access-work";
        };
        "p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-a" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-a";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-a";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens27";
          };
          "link" = "p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-a";
        };
        "p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-b" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-b";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-b";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens28";
          };
          "link" = "p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-b";
        };
        "p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-host-isp" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-host-isp";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-host-isp";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens29";
          };
          "link" = "p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-host-isp";
        };
        "p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-routed-isp" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-routed-isp";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-routed-isp";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens30";
          };
          "link" = "p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-routed-isp";
        };
        "p2p-clab-policy-clab-upstream-selector--access-clab-access-guest--uplink-isp-a" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-policy-clab-upstream-selector--access-clab-access-guest--uplink-isp-a";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-guest--uplink-isp-a";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens31";
          };
          "link" = "p2p-clab-policy-clab-upstream-selector--access-clab-access-guest--uplink-isp-a";
        };
        "p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-nebula-egress" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-nebula-egress";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-nebula-egress";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens32";
          };
          "link" = "p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-nebula-egress";
        };
        "p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-wireguard-egress" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-wireguard-egress";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-wireguard-egress";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens33";
          };
          "link" = "p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-wireguard-egress";
        };
        "p2p-clab-policy-clab-upstream-selector--access-clab-access-work--uplink-isp-a" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-policy-clab-upstream-selector--access-clab-access-work--uplink-isp-a";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-work--uplink-isp-a";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens34";
          };
          "link" = "p2p-clab-policy-clab-upstream-selector--access-clab-access-work--uplink-isp-a";
        };
        "p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-isp-a" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-isp-a";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-isp-a";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens35";
          };
          "link" = "p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-isp-a";
        };
        "p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-a" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-a";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-a";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens36";
          };
          "link" = "p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-a";
        };
      };
    };
    "esp0xdeadbeef-site-b-clab-provider-handoff-access-a" = {
      "advertisements" = {
        "dhcp4" = { };
        "dhcpv6" = { };
        "ipv6Ra" = { };
      };
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "clab-provider-handoff-access-a";
        "site" = "site-b";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-provider-handoff-access-a-p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a";
        };
        "p2p-clab-downstream-selector-clab-provider-handoff-access-a" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-provider-handoff-access-a-p2p-clab-downstream-selector-clab-provider-handoff-access-a";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-downstream-selector-clab-provider-handoff-access-a";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens21";
          };
          "link" = "p2p-clab-downstream-selector-clab-provider-handoff-access-a";
        };
      };
    };
    "esp0xdeadbeef-site-b-clab-provider-handoff-access-b" = {
      "advertisements" = {
        "dhcp4" = { };
        "dhcpv6" = { };
        "ipv6Ra" = { };
      };
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "clab-provider-handoff-access-b";
        "site" = "site-b";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-provider-handoff-access-b-p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b";
        };
        "p2p-clab-downstream-selector-clab-provider-handoff-access-b" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-provider-handoff-access-b-p2p-clab-downstream-selector-clab-provider-handoff-access-b";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-downstream-selector-clab-provider-handoff-access-b";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens21";
          };
          "link" = "p2p-clab-downstream-selector-clab-provider-handoff-access-b";
        };
      };
    };
    "esp0xdeadbeef-site-b-clab-upstream-selector" = {
      "host" = "s-router-clab";
      "logicalNode" = {
        "enterprise" = "esp0xdeadbeef";
        "name" = "clab-upstream-selector";
        "site" = "site-b";
      };
      "platform" = "linux";
      "ports" = {
        "p2p-clab-core-commercial-vpn-clab-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-core-commercial-vpn-clab-upstream-selector";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-core-commercial-vpn-clab-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens20";
          };
          "link" = "p2p-clab-core-commercial-vpn-clab-upstream-selector";
        };
        "p2p-clab-core-nebula-clab-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-core-nebula-clab-upstream-selector";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-core-nebula-clab-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens21";
          };
          "link" = "p2p-clab-core-nebula-clab-upstream-selector";
        };
        "p2p-clab-core-route-import-clab-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-core-route-import-clab-upstream-selector";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-core-route-import-clab-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens22";
          };
          "link" = "p2p-clab-core-route-import-clab-upstream-selector";
        };
        "p2p-clab-core-testnet-host-isp-clab-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-core-testnet-host-isp-clab-upstream-selector";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-core-testnet-host-isp-clab-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens23";
          };
          "link" = "p2p-clab-core-testnet-host-isp-clab-upstream-selector";
        };
        "p2p-clab-core-testnet-routed-isp-clab-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-core-testnet-routed-isp-clab-upstream-selector";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-core-testnet-routed-isp-clab-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens24";
          };
          "link" = "p2p-clab-core-testnet-routed-isp-clab-upstream-selector";
        };
        "p2p-clab-core-upstream-vlan4-clab-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-core-upstream-vlan4-clab-upstream-selector";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-core-upstream-vlan4-clab-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens25";
          };
          "link" = "p2p-clab-core-upstream-vlan4-clab-upstream-selector";
        };
        "p2p-clab-core-wireguard-host128-clab-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-core-wireguard-host128-clab-upstream-selector";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-core-wireguard-host128-clab-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens26";
          };
          "link" = "p2p-clab-core-wireguard-host128-clab-upstream-selector";
        };
        "p2p-clab-core-wireguard-remote-egress-clab-upstream-selector" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-core-wireguard-remote-egress-clab-upstream-selector";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-core-wireguard-remote-egress-clab-upstream-selector";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens27";
          };
          "link" = "p2p-clab-core-wireguard-remote-egress-clab-upstream-selector";
        };
        "p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-host-isp" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-host-isp";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-host-isp";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens28";
          };
          "link" = "p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-host-isp";
        };
        "p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-routed-isp" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-routed-isp";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-routed-isp";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens29";
          };
          "link" = "p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-routed-isp";
        };
        "p2p-clab-policy-clab-upstream-selector--access-clab-access-guest--uplink-isp-a" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-policy-clab-upstream-selector--access-clab-access-guest--uplink-isp-a";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-guest--uplink-isp-a";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens30";
          };
          "link" = "p2p-clab-policy-clab-upstream-selector--access-clab-access-guest--uplink-isp-a";
        };
        "p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-nebula-egress" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-nebula-egress";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-nebula-egress";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens31";
          };
          "link" = "p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-nebula-egress";
        };
        "p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-wireguard-egress" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-wireguard-egress";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-wireguard-egress";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens32";
          };
          "link" = "p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-wireguard-egress";
        };
        "p2p-clab-policy-clab-upstream-selector--access-clab-access-work--uplink-isp-a" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-policy-clab-upstream-selector--access-clab-access-work--uplink-isp-a";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-work--uplink-isp-a";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens33";
          };
          "link" = "p2p-clab-policy-clab-upstream-selector--access-clab-access-work--uplink-isp-a";
        };
        "p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-isp-a" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-isp-a";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-isp-a";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens34";
          };
          "link" = "p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-isp-a";
        };
        "p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-a" = {
          "adapterName" = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-a";
          "attach" = {
            "bridge" = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-a";
            "kind" = "bridge";
          };
          "interface" = {
            "name" = "ens35";
          };
          "link" = "p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-a";
        };
      };
    };
  };
}
