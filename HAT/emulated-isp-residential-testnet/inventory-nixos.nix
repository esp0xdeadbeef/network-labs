let
  managementUplink = {
    bridge = "vlan2";
    ipv4 = {
      dhcp = true;
      enable = true;
      method = "dhcp";
    };
    ipv6 = {
      acceptRA = false;
      dhcp = false;
      dhcpv6PD = false;
      enable = false;
      method = "none";
    };
    mode = "vlan";
    parent = "eth0";
    vlan = 2;
  };
in
{
  deployment = {
    hosts = {
      lab-host = {
        bridgeNetworks = {
          br-n-pppoe = {
            hatPurpose = "residential-pppoe-handoff";
            isolated = true;
          };
          br-site-a-core-testnet-routed-isp-upstream = { };
          br-site-a-core-testnet-host-isp-upstream = { };
          br-site-a-downstream-client = { };
          br-site-a-downstream-policy-access-client = { };
          br-site-a-policy-upstream-access-client-testnet-routed-isp = { };
          br-site-a-policy-upstream-access-client-testnet-host-isp = { };
        };
        hat = {
          upstreamEmulation = {
            residentialDhcpRoutedTestnet = {
              advertisedIpv4 = {
                customerAddress = "203.0.113.2";
                prefix = "203.0.113.0/30";
                providerAddress = "203.0.113.1";
                probeAddress = "203.0.113.1";
              };
              delegatedIpv6 = {
                kind = "delegated-prefix";
                prefix = "2001:db8:113::/48";
              };
              gampId = "FS-800-HDS-010-SDS-010-SMS-010";
              handoff = "dhcp";
              harness = "s-router-nixos";
              l2Surface = {
                kind = "isolated-bridge";
                name = "br-t-routed";
                physical = false;
              };
              nat44 = false;
              nat64 = {
                enabled = true;
                ipv4Egress = "testnet-routed-isp";
                prefix = "64:ff9b::/96";
                probeAddress6 = "64:ff9b::cb00:7101";
                probeTarget4 = "203.0.113.1";
              };
              nat66 = false;
              probeIntent = [
                "customer-wan-dhcpv4"
                "testnet-routed-ipv4-/30"
                "testnet-ipv6-/48"
                "nat64-ipv6-to-ipv4-testnet"
                "no-provider-name-nat"
                "no-nat66"
              ];
            };
            residentialPppoeHostTestnet = {
              advertisedIpv4 = {
                customerAddress = "203.0.113.4";
                prefix = "203.0.113.4/32";
                providerPeerAddress = "203.0.113.5";
                probeAddress = "203.0.113.4";
              };
              delegatedIpv6 = {
                kind = "constrained-prefix";
                prefix = "2001:db8:113:64::/64";
              };
              gampId = "FS-800-HDS-010-SDS-010-SMS-010";
              handoff = "pppoe";
              harness = "s-router-nixos";
              l2Surface = {
                kind = "isolated-bridge";
                name = "br-n-pppoe";
                physical = false;
              };
              nat44 = false;
              nat64 = {
                enabled = true;
                ipv4Egress = "testnet-host-isp";
                prefix = "64:ff9b::/96";
                probeAddress6 = "64:ff9b::cb00:7104";
                probeTarget4 = "203.0.113.4";
              };
              nat66 = false;
              probeIntent = [
                "pppoe-session-up"
                "testnet-host-ipv4-/32"
                "testnet-ipv6-/64"
                "nat64-ipv6-to-ipv4-testnet"
                "no-provider-name-nat"
                "no-nat66"
              ];
            };
          };
        };
        uplinks = {
          management = managementUplink;
          uplink-testnet-routed-isp = {
            bridge = "br-t-routed";
            ipv4 = {
              address = "203.0.113.1/30";
              method = "static";
            };
            ipv6 = {
              address = "2001:db8:113::1/64";
              method = "static";
            };
            parent = "hat-routed-isp";
            upstream = "testnet-routed-isp";
          };
          uplink-testnet-host-isp = {
            bridge = "br-t-host";
            ipv4 = {
              address = "203.0.113.5/32";
              method = "static";
            };
            ipv6 = {
              address = "2001:db8:113:64::1/64";
              method = "static";
            };
            parent = "hat-host-isp";
            upstream = "testnet-host-isp";
          };
        };
        wanGroupToUplink = {
          "esp0xdeadbeef::site-a::s-router-core-testnet-routed-isp" = "uplink-testnet-routed-isp";
          "esp0xdeadbeef::site-a::s-router-core-testnet-host-isp" = "uplink-testnet-host-isp";
        };
      };
      s-router-nixos = {
        bridgeNetworks = { };
        uplinks.management = managementUplink;
      };
      s-router-test-clients = {
        bridgeNetworks = {
          admin = {
            mode = "vlan";
            parent = "eth0";
            vlan = 301;
          };
          branch = {
            mode = "vlan";
            parent = "eth0";
            vlan = 305;
          };
          client = {
            mode = "vlan";
            parent = "eth0";
            vlan = 302;
          };
          dmz = {
            mode = "vlan";
            parent = "eth0";
            vlan = 304;
          };
          hostile = {
            mode = "vlan";
            parent = "eth0";
            vlan = 306;
          };
          mgmt = {
            mode = "vlan";
            parent = "eth0";
            vlan = 300;
          };
          streaming = {
            mode = "vlan";
            parent = "eth0";
            vlan = 311;
          };
        };
        uplinks.management = managementUplink;
      };
    };
  };

  realization = {
    nodes = {
      esp0xdeadbeef-site-a-s-router-access-client = {
        advertisements = {
          dhcp4 = {
            tenant-client = {
              dnsServers = [ "router-self" ];
              domain = "lan.";
            };
          };
          ipv6Ra = {
            tenant-client = {
              dnssl = [ "lan." ];
              rdnss = [ "router-self" ];
            };
          };
        };
        host = "lab-host";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "s-router-access-client";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          transit-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-access-client-transit-downstream-selector";
            attach = {
              bridge = "br-site-a-downstream-client";
              kind = "bridge";
            };
            interface = {
              name = "ens3";
            };
            link = "p2p-s-router-access-client-s-router-downstream-selector";
          };
        };
      };

      esp0xdeadbeef-site-a-s-router-core-testnet-routed-isp = {
        host = "lab-host";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "s-router-core-testnet-routed-isp";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          testnet-routed-isp = {
            attach = {
              bridge = "br-t-routed";
              kind = "bridge";
            };
            external = true;
            interface = {
              name = "ens4";
            };
            uplink = "testnet-routed-isp";
          };
          upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-core-testnet-routed-isp-upstream-selector";
            attach = {
              bridge = "br-site-a-core-testnet-routed-isp-upstream";
              kind = "bridge";
            };
            interface = {
              name = "ens3";
            };
            link = "p2p-s-router-core-testnet-routed-isp-s-router-upstream-selector";
          };
        };
      };

      esp0xdeadbeef-site-a-s-router-core-testnet-host-isp = {
        host = "lab-host";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "s-router-core-testnet-host-isp";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          testnet-host-isp = {
            attach = {
              bridge = "br-t-host";
              kind = "bridge";
            };
            external = true;
            interface = {
              name = "ens4";
            };
            uplink = "testnet-host-isp";
          };
          upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-core-testnet-host-isp-upstream-selector";
            attach = {
              bridge = "br-site-a-core-testnet-host-isp-upstream";
              kind = "bridge";
            };
            interface = {
              name = "ens3";
            };
            link = "p2p-s-router-core-testnet-host-isp-s-router-upstream-selector";
          };
        };
      };

      esp0xdeadbeef-site-a-s-router-downstream-selector = {
        host = "lab-host";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "s-router-downstream-selector";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          access-client = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-downstream-selector-access-client";
            attach = {
              bridge = "br-site-a-downstream-client";
              kind = "bridge";
            };
            interface = {
              name = "ens3";
            };
            link = "p2p-s-router-access-client-s-router-downstream-selector";
          };
          policy-access-client = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-downstream-selector-policy-access-client";
            attach = {
              bridge = "br-site-a-downstream-policy-access-client";
              kind = "bridge";
            };
            interface = {
              name = "ens4";
            };
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-client";
          };
        };
      };

      esp0xdeadbeef-site-a-s-router-policy = {
        host = "lab-host";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "s-router-policy";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          downstream-access-client = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-policy-downstream-access-client";
            attach = {
              bridge = "br-site-a-downstream-policy-access-client";
              kind = "bridge";
            };
            interface = {
              name = "ens3";
            };
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-client";
          };
          upstream-access-client-testnet-routed-isp = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-policy-upstream-access-client-testnet-routed-isp";
            attach = {
              bridge = "br-site-a-policy-upstream-access-client-testnet-routed-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens4";
            };
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-client--uplink-testnet-routed-isp";
          };
          upstream-access-client-testnet-host-isp = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-policy-upstream-access-client-testnet-host-isp";
            attach = {
              bridge = "br-site-a-policy-upstream-access-client-testnet-host-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens5";
            };
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-client--uplink-testnet-host-isp";
          };
        };
      };

      esp0xdeadbeef-site-a-s-router-upstream-selector = {
        host = "lab-host";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "s-router-upstream-selector";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          core-testnet-routed-isp = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-upstream-selector-core-testnet-routed-isp";
            attach = {
              bridge = "br-site-a-core-testnet-routed-isp-upstream";
              kind = "bridge";
            };
            interface = {
              name = "ens3";
            };
            link = "p2p-s-router-core-testnet-routed-isp-s-router-upstream-selector";
          };
          core-testnet-host-isp = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-upstream-selector-core-testnet-host-isp";
            attach = {
              bridge = "br-site-a-core-testnet-host-isp-upstream";
              kind = "bridge";
            };
            interface = {
              name = "ens4";
            };
            link = "p2p-s-router-core-testnet-host-isp-s-router-upstream-selector";
          };
          policy-access-client-testnet-routed-isp = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-upstream-selector-policy-access-client-testnet-routed-isp";
            attach = {
              bridge = "br-site-a-policy-upstream-access-client-testnet-routed-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens5";
            };
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-client--uplink-testnet-routed-isp";
          };
          policy-access-client-testnet-host-isp = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-upstream-selector-policy-access-client-testnet-host-isp";
            attach = {
              bridge = "br-site-a-policy-upstream-access-client-testnet-host-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens6";
            };
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-client--uplink-testnet-host-isp";
          };
        };
      };
    };
  };
}
