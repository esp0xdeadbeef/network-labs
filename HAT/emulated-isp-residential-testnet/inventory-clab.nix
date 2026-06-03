let
  generatedRealization = import ./generated-realization-clab.nix;
  tenantInterfaceFor =
    logicalName:
    let
      matches = pattern: builtins.match pattern logicalName != null;
    in
    if matches ".*access-client" then "tenant-client"
    else if matches ".*access-dmz" then "tenant-dmz"
    else if matches ".*access-guest" then "tenant-guest"
    else if matches ".*access-iot" then "tenant-iot"
    else if matches ".*access-management" then "tenant-management"
    else if matches ".*access-trusted" then "tenant-trusted"
    else if matches ".*access-work" then "tenant-work"
    else if matches ".*provider-handoff-access-a" then "tenant-provider-handoff-a"
    else if matches ".*provider-handoff-access-b" then "tenant-provider-handoff-b"
    else null;
  defaultAdvertisementsFor =
    tenantInterface:
    let
      disabled = {
        enabled = false;
      };
      enabled = {
        dhcp4.${tenantInterface} = {
          dnsServers = [ "router-self" ];
          domain = "lan.";
        };
        dhcpv6 = { };
        ipv6Ra.${tenantInterface} = {
          dnssl = [ "lan." ];
          rdnss = [ "router-self" ];
        };
      };
      disabledProvider = {
        dhcp4.${tenantInterface} = disabled;
        dhcpv6 = { };
        ipv6Ra.${tenantInterface} = disabled;
      };
    in
    if builtins.match "tenant-provider-handoff-.*" tenantInterface != null then disabledProvider else enabled;
  generatedRuntimeNodes =
    builtins.mapAttrs
      (_name: node:
        let
          logicalName = node.logicalNode.name or "";
          tenantInterface = tenantInterfaceFor logicalName;
        in
        if tenantInterface == null then node else node // { advertisements = defaultAdvertisementsFor tenantInterface; })
      generatedRealization.nodes;
  mergeRuntimeNodes =
    explicitNodes:
    generatedRuntimeNodes // builtins.mapAttrs
      (name: explicit:
        let
          generated = generatedRuntimeNodes.${name} or { };
          generatedLinks =
            map
              (portName: (generated.ports.${portName}.link or null))
              (builtins.attrNames (generated.ports or { }));
          explicitPorts =
            builtins.listToAttrs (
              builtins.filter
                (entry: !(builtins.elem (entry.value.link or null) generatedLinks))
                (map
                  (portName: {
                    name = portName;
                    value = explicit.ports.${portName};
                  })
                  (builtins.attrNames (explicit.ports or { })))
            );
        in
        generated // explicit // {
          ports = (generated.ports or { }) // explicitPorts;
        })
      explicitNodes;
in
{
  deployment = {
    hosts = {
      s-router-clab = {
        bridgeNetworks = generatedRealization.bridgeNetworks // {
          br-c-pppoe = {
            hatPurpose = "residential-pppoe-handoff";
            isolated = true;
          };
          br-site-a-core-upstream-vlan4-upstream = { };
          br-site-a-core-testnet-routed-isp-upstream = { };
          br-site-a-core-testnet-host-isp-upstream = { };
          br-site-a-downstream-client = { };
          br-site-a-downstream-policy-access-client = { };
          br-site-a-policy-upstream-access-client-testnet-routed-isp = { };
          br-site-a-policy-upstream-access-client-testnet-host-isp = { };
        };
        hat = {
          providerAccess = {
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
              harness = "s-router-clab";
              distribution = {
                mode = "network-wide";
                technology = "dhcp";
              };
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
              harness = "s-router-clab";
              distribution = {
                endpoint = "nixos-core-testnet-host-isp";
                mode = "endpoint-specific";
                technology = "pppoe";
              };
              l2Surface = {
                kind = "isolated-bridge";
                name = "br-c-pppoe";
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
          uplink-isp-a = {
            bridge = "br-uplink0";
            ipv4 = {
              dhcp = true;
              method = "dhcp";
            };
            ipv6 = {
              acceptRA = true;
              method = "slaac";
            };
            parent = "eth0";
            upstream = "isp-a";
          };
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
          commercial-vpn = {
            bridge = "br-clab-uplink-commercial-vpn";
            ipv4.method = "none";
            ipv6.method = "none";
            parent = "hat-commercial-vpn";
            upstream = "commercial-vpn";
          };
          nebula-egress = {
            bridge = "br-clab-uplink-nebula-egress";
            ipv4.method = "none";
            ipv6.method = "none";
            parent = "hat-nebula-egress";
            upstream = "nebula-egress";
          };
          route-import = {
            bridge = "br-clab-uplink-route-import";
            ipv4.method = "none";
            ipv6.method = "none";
            parent = "hat-route-import";
            upstream = "route-import";
          };
          wireguard-egress = {
            bridge = "br-clab-uplink-wireguard-egress";
            ipv4.method = "none";
            ipv6.method = "none";
            parent = "hat-wireguard-egress";
            upstream = "wireguard-egress";
          };
          wireguard-host128 = {
            bridge = "br-clab-uplink-wireguard-host128";
            ipv4.method = "none";
            ipv6 = {
              address = "2001:db8:128::2/128";
              method = "static";
            };
            parent = "hat-wireguard-host128";
            upstream = "wireguard-host128";
          };
        };
        wanGroupToUplink = {
          "esp0xdeadbeef::site-a::nixos-core-upstream-vlan4" = "uplink-isp-a";
          "esp0xdeadbeef::site-a::nixos-core-testnet-routed-isp" = "uplink-testnet-routed-isp";
          "esp0xdeadbeef::site-a::nixos-core-testnet-host-isp" = "uplink-testnet-host-isp";
          "esp0xdeadbeef::site-a::nixos-core-commercial-vpn" = "commercial-vpn";
          "esp0xdeadbeef::site-a::nixos-core-nebula" = "nebula-egress";
          "esp0xdeadbeef::site-a::nixos-core-route-import" = "route-import";
          "esp0xdeadbeef::site-a::nixos-core-wireguard-remote-egress" = "wireguard-egress";
          "esp0xdeadbeef::site-a::nixos-core-wireguard-host128" = "wireguard-host128";
          "esp0xdeadbeef::site-b::clab-core-commercial-vpn" = "commercial-vpn";
          "esp0xdeadbeef::site-b::clab-core-nebula" = "nebula-egress";
          "esp0xdeadbeef::site-b::clab-core-route-import" = "route-import";
          "esp0xdeadbeef::site-b::clab-core-wireguard-remote-egress" = "wireguard-egress";
          "esp0xdeadbeef::site-b::clab-core-wireguard-host128" = "wireguard-host128";
        };
      };
    };
  };

  realization = {
    nodes = mergeRuntimeNodes {
      esp0xdeadbeef-site-a-nixos-access-client = {
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
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "nixos-access-client";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          transit-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-access-client-transit-downstream-selector";
            attach = {
              bridge = "br-site-a-downstream-client";
              kind = "bridge";
            };
            interface = {
              name = "ens3";
            };
            link = "p2p-nixos-access-client-nixos-downstream-selector";
          };
        };
      };

      esp0xdeadbeef-site-a-nixos-core-testnet-routed-isp = {
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "nixos-core-testnet-routed-isp";
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
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-core-testnet-routed-isp-upstream-selector";
            attach = {
              bridge = "br-site-a-core-testnet-routed-isp-upstream";
              kind = "bridge";
            };
            interface = {
              name = "ens3";
            };
            link = "p2p-nixos-core-testnet-routed-isp-nixos-upstream-selector";
          };
        };
      };

      esp0xdeadbeef-site-a-nixos-core-upstream-vlan4 = {
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "nixos-core-upstream-vlan4";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          isp-a = {
            attach = {
              bridge = "br-uplink0";
              kind = "bridge";
              parentUplink = "uplink-isp-a";
            };
            external = true;
            interface = {
              name = "ens4";
            };
            uplink = "isp-a";
          };
          upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-core-upstream-vlan4-upstream-selector";
            attach = {
              bridge = "br-site-a-core-upstream-vlan4-upstream";
              kind = "bridge";
            };
            interface = {
              name = "ens3";
            };
            link = "p2p-nixos-core-upstream-vlan4-nixos-upstream-selector";
          };
        };
      };

      esp0xdeadbeef-site-a-nixos-core-testnet-host-isp = {
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "nixos-core-testnet-host-isp";
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
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-core-testnet-host-isp-upstream-selector";
            attach = {
              bridge = "br-site-a-core-testnet-host-isp-upstream";
              kind = "bridge";
            };
            interface = {
              name = "ens3";
            };
            link = "p2p-nixos-core-testnet-host-isp-nixos-upstream-selector";
          };
        };
      };

      esp0xdeadbeef-site-a-nixos-downstream-selector = {
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "nixos-downstream-selector";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          access-client = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-access-client";
            attach = {
              bridge = "br-site-a-downstream-client";
              kind = "bridge";
            };
            interface = {
              name = "ens3";
            };
            link = "p2p-nixos-access-client-nixos-downstream-selector";
          };
          policy-access-client = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-policy-access-client";
            attach = {
              bridge = "br-site-a-downstream-policy-access-client";
              kind = "bridge";
            };
            interface = {
              name = "ens4";
            };
            link = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-client";
          };
        };
      };

      esp0xdeadbeef-site-a-nixos-policy = {
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "nixos-policy";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          downstream-access-client = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-policy-downstream-access-client";
            attach = {
              bridge = "br-site-a-downstream-policy-access-client";
              kind = "bridge";
            };
            interface = {
              name = "ens3";
            };
            link = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-client";
          };
          upstream-access-client-testnet-routed-isp = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-policy-upstream-access-client-testnet-routed-isp";
            attach = {
              bridge = "br-site-a-policy-upstream-access-client-testnet-routed-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens4";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-routed-isp";
          };
          upstream-access-client-testnet-host-isp = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-policy-upstream-access-client-testnet-host-isp";
            attach = {
              bridge = "br-site-a-policy-upstream-access-client-testnet-host-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens5";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-host-isp";
          };
        };
      };

      esp0xdeadbeef-site-a-nixos-upstream-selector = {
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "nixos-upstream-selector";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          core-upstream-vlan4 = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-core-upstream-vlan4";
            attach = {
              bridge = "br-site-a-core-upstream-vlan4-upstream";
              kind = "bridge";
            };
            interface = {
              name = "ens7";
            };
            link = "p2p-nixos-core-upstream-vlan4-nixos-upstream-selector";
          };
          core-testnet-routed-isp = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-core-testnet-routed-isp";
            attach = {
              bridge = "br-site-a-core-testnet-routed-isp-upstream";
              kind = "bridge";
            };
            interface = {
              name = "ens3";
            };
            link = "p2p-nixos-core-testnet-routed-isp-nixos-upstream-selector";
          };
          core-testnet-host-isp = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-core-testnet-host-isp";
            attach = {
              bridge = "br-site-a-core-testnet-host-isp-upstream";
              kind = "bridge";
            };
            interface = {
              name = "ens4";
            };
            link = "p2p-nixos-core-testnet-host-isp-nixos-upstream-selector";
          };
          policy-access-client-testnet-routed-isp = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-policy-access-client-testnet-routed-isp";
            attach = {
              bridge = "br-site-a-policy-upstream-access-client-testnet-routed-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens5";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-routed-isp";
          };
          policy-access-client-testnet-host-isp = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-policy-access-client-testnet-host-isp";
            attach = {
              bridge = "br-site-a-policy-upstream-access-client-testnet-host-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens6";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-host-isp";
          };
        };
      };
    };
  };
}
