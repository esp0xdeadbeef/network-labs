# Standalone HAT inventory with explicit realization data.
let
  protectedPppoeCredentialBindings = import ./protected-pppoe-credential-bindings.nix {
    consumerNode = "esp0xdeadbeef-site-a-nixos-core-testnet-host-isp";
    harness = "s-router-nixos";
    site = "nixos";
  };
in
{
  inherit (protectedPppoeCredentialBindings) secretDeclarations secretSources sourceBindings;

  deployment = {
    hosts = {
      s-router-clab = {
        bridgeNetworks = {
          stub-clab-br-site-b-p2p-clab-access-client-clab-downstream-selector = { };
          stub-clab-br-site-b-p2p-clab-access-dmz-clab-downstream-selector = { };
          stub-clab-br-site-b-p2p-clab-access-guest-clab-downstream-selector = { };
          stub-clab-br-site-b-p2p-clab-access-iot-clab-core-nebula = { };
          stub-clab-br-site-b-p2p-clab-access-iot-clab-core-wireguard-host128 = { };
          stub-clab-br-site-b-p2p-clab-access-iot-clab-core-wireguard-remote-egress = { };
          stub-clab-br-site-b-p2p-clab-access-iot-clab-downstream-selector = { };
          stub-clab-br-site-b-p2p-clab-access-management-clab-downstream-selector = { };
          stub-clab-br-site-b-p2p-clab-access-trusted-clab-downstream-selector = { };
          stub-clab-br-site-b-p2p-clab-access-work-clab-downstream-selector = { };
          stub-clab-br-site-b-p2p-clab-core-commercial-vpn-clab-upstream-selector = { };
          stub-clab-br-site-b-p2p-clab-core-nebula-clab-upstream-selector = { };
          stub-clab-br-site-b-p2p-clab-core-route-import-clab-upstream-selector = { };
          stub-clab-br-site-b-p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a = { };
          stub-clab-br-site-b-p2p-clab-core-testnet-host-isp-clab-upstream-selector = { };
          stub-clab-br-site-b-p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b = { };
          stub-clab-br-site-b-p2p-clab-core-testnet-routed-isp-clab-upstream-selector = { };
          stub-clab-br-site-b-p2p-clab-core-upstream-vlan4-clab-upstream-selector = { };
          stub-clab-br-site-b-p2p-clab-core-wireguard-host128-clab-upstream-selector = { };
          stub-clab-br-site-b-p2p-clab-core-wireguard-remote-egress-clab-upstream-selector = { };
          stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-client = { };
          stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-dmz = { };
          stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-guest = { };
          stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-iot = { };
          stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-management = { };
          stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-trusted = { };
          stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-work = { };
          stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-a =
            { };
          stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-b =
            { };
          stub-clab-br-site-b-p2p-clab-downstream-selector-clab-provider-handoff-access-a = { };
          stub-clab-br-site-b-p2p-clab-downstream-selector-clab-provider-handoff-access-b = { };
          stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-host-isp =
            { };
          stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-routed-isp =
            { };
          stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-guest--uplink-isp-a =
            { };
          stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-nebula-egress =
            { };
          stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-wireguard-egress =
            { };
          stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-work--uplink-isp-a =
            { };
          stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-isp-a =
            { };
          stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-a =
            { };
          stub-clab-client = { };
          stub-clab-dmz = { };
          stub-clab-guest = { };
          stub-clab-iot = { };
          stub-clab-mgmt = { };
          stub-clab-trusted = { };
          stub-clab-work = { };
        };
        uplinks = {
          commercial-vpn = {
            bridge = "stub-clab-br-nixos-uplink-commercial-vpn";
            ipv4 = {
              method = "none";
            };
            ipv6 = {
              method = "none";
            };
            parent = "hat-commercial-vpn";
            upstream = "commercial-vpn";
          };
          management = {
            bridge = "stub-clab-vlan2";
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
          nebula-egress = {
            bridge = "stub-clab-br-nixos-uplink-nebula-egress";
            ipv4 = {
              method = "none";
            };
            ipv6 = {
              method = "none";
            };
            parent = "hat-nebula-egress";
            upstream = "nebula-egress";
          };
          route-import = {
            bridge = "stub-clab-br-nixos-uplink-route-import";
            ipv4 = {
              method = "none";
            };
            ipv6 = {
              method = "none";
            };
            parent = "hat-route-import";
            upstream = "route-import";
          };
          uplink-isp-a = {
            bridge = "stub-clab-br-uplink0";
            ipv4 = {
              dhcp = true;
              enable = true;
              method = "dhcp";
            };
            ipv6 = {
              acceptRA = true;
              dhcp = false;
              dhcpv6PD = false;
              enable = true;
              method = "slaac";
            };
            mode = "vlan";
            parent = "eth0";
            upstream = "isp-a";
            vlan = 4;
          };
          uplink-testnet-host-isp = {
            bridge = "stub-clab-br-t-host";
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
          uplink-testnet-routed-isp = {
            bridge = "stub-clab-br-t-routed";
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
          wireguard-egress = {
            bridge = "stub-clab-br-nixos-uplink-wireguard-egress";
            ipv4 = {
              method = "none";
            };
            ipv6 = {
              method = "none";
            };
            parent = "hat-wireguard-egress";
            upstream = "wireguard-egress";
          };
          wireguard-host128 = {
            bridge = "stub-clab-br-nixos-uplink-wireguard-host128";
            ipv4 = {
              method = "none";
            };
            ipv6 = {
              address = "2001:db8:128::1/128";
              method = "static";
            };
            parent = "hat-wireguard-host128";
            upstream = "wireguard-host128";
          };
        };
        wanGroupToUplink = {
          "esp0xdeadbeef::site-b::clab-core-commercial-vpn" = "commercial-vpn";
          "esp0xdeadbeef::site-b::clab-core-nebula" = "nebula-egress";
          "esp0xdeadbeef::site-b::clab-core-route-import" = "route-import";
          "esp0xdeadbeef::site-b::clab-core-testnet-host-isp" = "uplink-testnet-host-isp";
          "esp0xdeadbeef::site-b::clab-core-testnet-routed-isp" = "uplink-testnet-routed-isp";
          "esp0xdeadbeef::site-b::clab-core-upstream-vlan4" = "uplink-isp-a";
          "esp0xdeadbeef::site-b::clab-core-wireguard-host128" = "wireguard-host128";
          "esp0xdeadbeef::site-b::clab-core-wireguard-remote-egress" = "wireguard-egress";
        };
      };
      s-router-nixos = {
        bridgeNetworks = {
          br-n-pppoe = {
            hatPurpose = "residential-pppoe-handoff";
            isolated = true;
          };
          br-site-a-p2p-nixos-access-client-nixos-downstream-selector = { };
          br-site-a-p2p-nixos-access-dmz-nixos-downstream-selector = { };
          br-site-a-p2p-nixos-access-guest-nixos-downstream-selector = { };
          br-site-a-p2p-nixos-access-iot-nixos-core-nebula = { };
          br-site-a-p2p-nixos-access-iot-nixos-core-wireguard-host128 = { };
          br-site-a-p2p-nixos-access-iot-nixos-core-wireguard-remote-egress = { };
          br-site-a-p2p-nixos-access-iot-nixos-downstream-selector = { };
          br-site-a-p2p-nixos-access-management-nixos-downstream-selector = { };
          br-site-a-p2p-nixos-access-trusted-nixos-downstream-selector = { };
          br-site-a-p2p-nixos-access-work-nixos-downstream-selector = { };
          br-site-a-p2p-nixos-core-commercial-vpn-nixos-upstream-selector = { };
          br-site-a-p2p-nixos-core-nebula-nixos-upstream-selector = { };
          br-site-a-p2p-nixos-core-route-import-nixos-upstream-selector = { };
          br-site-a-p2p-nixos-core-testnet-host-isp-nixos-provider-handoff-access-a = { };
          br-site-a-p2p-nixos-core-testnet-host-isp-nixos-upstream-selector = { };
          br-site-a-p2p-nixos-core-testnet-routed-isp-nixos-provider-handoff-access-b = { };
          br-site-a-p2p-nixos-core-testnet-routed-isp-nixos-upstream-selector = { };
          br-site-a-p2p-nixos-core-upstream-vlan4-nixos-upstream-selector = { };
          br-site-a-p2p-nixos-core-wireguard-host128-nixos-upstream-selector = { };
          br-site-a-p2p-nixos-core-wireguard-remote-egress-nixos-upstream-selector = { };
          br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-client = { };
          br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-dmz = { };
          br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-guest = { };
          br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-iot = { };
          br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-management = { };
          br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-trusted = { };
          br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-work = { };
          br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-a = { };
          br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-b = { };
          br-site-a-p2p-nixos-downstream-selector-nixos-provider-handoff-access-a = { };
          br-site-a-p2p-nixos-downstream-selector-nixos-provider-handoff-access-b = { };
          br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-host-isp =
            { };
          br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-routed-isp =
            { };
          br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-guest--uplink-isp-a = { };
          br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-nebula-egress =
            { };
          br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-wireguard-egress =
            { };
          br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-work--uplink-isp-a = { };
          br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-isp-a =
            { };
          br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-a =
            { };
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
          guest = {
            mode = "vlan";
            parent = "eth0";
            vlan = 306;
          };
          iot = { };
          mgmt = {
            mode = "vlan";
            parent = "eth0";
            vlan = 300;
          };
          trusted = {
            mode = "vlan";
            parent = "eth0";
            vlan = 301;
          };
          work = { };
        };
        hat = {
          providerAccess = {
            residentialDhcpRoutedTestnet = {
              advertisedIpv4 = {
                customerAddress = "203.0.113.2";
                prefix = "203.0.113.0/30";
                probeAddress = "203.0.113.1";
                providerAddress = "203.0.113.1";
              };
              delegatedIpv6 = {
                kind = "delegated-prefix";
                prefix = "2001:db8:113::/48";
              };
              distribution = {
                mode = "network-wide";
                technology = "dhcp";
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
                probeAddress = "203.0.113.4";
                providerPeerAddress = "203.0.113.5";
              };
              delegatedIpv6 = {
                kind = "constrained-prefix";
                prefix = "2001:db8:113:64::/64";
              };
              distribution = {
                endpoint = "nixos-core-testnet-host-isp";
                mode = "endpoint-specific";
                technology = "pppoe";
              };
              credentials = {
                labOnly = true;
                passwordFile = "/run/secrets/hat-pppoe-password";
                usernameFile = "/run/secrets/hat-pppoe-username";
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
          commercial-vpn = {
            bridge = "br-nixos-uplink-commercial-vpn";
            ipv4 = {
              method = "none";
            };
            ipv6 = {
              method = "none";
            };
            parent = "hat-commercial-vpn";
            upstream = "commercial-vpn";
          };
          management = {
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
          nebula-egress = {
            bridge = "br-nixos-uplink-nebula-egress";
            ipv4 = {
              method = "none";
            };
            ipv6 = {
              method = "none";
            };
            parent = "hat-nebula-egress";
            upstream = "nebula-egress";
          };
          route-import = {
            bridge = "br-nixos-uplink-route-import";
            ipv4 = {
              method = "none";
            };
            ipv6 = {
              method = "none";
            };
            parent = "hat-route-import";
            upstream = "route-import";
          };
          uplink-isp-a = {
            bridge = "br-uplink0";
            ipv4 = {
              dhcp = true;
              enable = true;
              method = "dhcp";
            };
            ipv6 = {
              acceptRA = true;
              dhcp = false;
              dhcpv6PD = false;
              enable = true;
              method = "slaac";
            };
            mode = "vlan";
            parent = "eth0";
            upstream = "isp-a";
            vlan = 4;
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
          wireguard-egress = {
            bridge = "br-nixos-uplink-wireguard-egress";
            ipv4 = {
              method = "none";
            };
            ipv6 = {
              method = "none";
            };
            parent = "hat-wireguard-egress";
            upstream = "wireguard-egress";
          };
          wireguard-host128 = {
            bridge = "br-nixos-uplink-wireguard-host128";
            ipv4 = {
              method = "none";
            };
            ipv6 = {
              address = "2001:db8:128::1/128";
              method = "static";
            };
            parent = "hat-wireguard-host128";
            upstream = "wireguard-host128";
          };
        };
        wanGroupToUplink = {
          "esp0xdeadbeef::site-a::nixos-core-commercial-vpn" = "commercial-vpn";
          "esp0xdeadbeef::site-a::nixos-core-nebula" = "nebula-egress";
          "esp0xdeadbeef::site-a::nixos-core-route-import" = "route-import";
          "esp0xdeadbeef::site-a::nixos-core-testnet-host-isp" = "uplink-testnet-host-isp";
          "esp0xdeadbeef::site-a::nixos-core-testnet-routed-isp" = "uplink-testnet-routed-isp";
          "esp0xdeadbeef::site-a::nixos-core-upstream-vlan4" = "uplink-isp-a";
          "esp0xdeadbeef::site-a::nixos-core-wireguard-host128" = "wireguard-host128";
          "esp0xdeadbeef::site-a::nixos-core-wireguard-remote-egress" = "wireguard-egress";
          "esp0xdeadbeef::site-b::clab-core-commercial-vpn" = "commercial-vpn";
          "esp0xdeadbeef::site-b::clab-core-nebula" = "nebula-egress";
          "esp0xdeadbeef::site-b::clab-core-route-import" = "route-import";
          "esp0xdeadbeef::site-b::clab-core-testnet-host-isp" = "uplink-testnet-host-isp";
          "esp0xdeadbeef::site-b::clab-core-testnet-routed-isp" = "uplink-testnet-routed-isp";
          "esp0xdeadbeef::site-b::clab-core-upstream-vlan4" = "uplink-isp-a";
          "esp0xdeadbeef::site-b::clab-core-wireguard-host128" = "wireguard-host128";
          "esp0xdeadbeef::site-b::clab-core-wireguard-remote-egress" = "wireguard-egress";
        };
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
        hat = {
          requiredEndpointClients = [
            "nixos-branch-node01"
            "nixos-client01"
            "nixos-client02"
            "nixos-emulated-sigma"
            "nixos-printer01"
            "nixos-receiver01"
            "nixos-streaming-test"
          ];
          endpointClients = {
            nixos-branch-node01 = {
              addressDelivery = "endpoint-configured";
              assignment = "static-ipv4-or-ipv6-client";
              gateway4 = "10.60.10.1";
              gateway6 = "fd42:dead:feed:10::1";
              ipv4 = [ "10.60.10.10/24" ];
              ipv6 = [ "fd42:dead:feed:10::10/64" ];
              managementBoundary = {
                fixturePlacementCreatesManagementAccess = false;
                mode = "no-general-management";
              };
              owningSubstrate = "nixos";
              persistenceExpectation = {
                kind = "ephemeral-fixture";
                required = false;
              };
              tenant = "branch";
            };
            nixos-client01 = {
              assignment = "dhcp";
              managementBoundary = {
                fixturePlacementCreatesManagementAccess = false;
                mode = "no-general-management";
              };
              owningSubstrate = "nixos";
              persistenceExpectation = {
                kind = "ephemeral-fixture";
                required = false;
              };
              tenant = "client";
            };
            nixos-client02 = {
              assignment = "dhcp";
              managementBoundary = {
                fixturePlacementCreatesManagementAccess = false;
                mode = "no-general-management";
              };
              owningSubstrate = "nixos";
              persistenceExpectation = {
                kind = "ephemeral-fixture";
                required = false;
              };
              tenant = "client";
            };
            nixos-emulated-sigma = {
              addressDelivery = "endpoint-configured";
              assignment = "static-ipv4-or-ipv6-client";
              gateway4 = "10.20.10.1";
              gateway6 = "fd42:dead:beef:10::1";
              ipv4 = [ "10.20.10.50/24" ];
              ipv6 = [ "fd42:dead:beef:10::50/64" ];
              managementBoundary = {
                fixturePlacementCreatesManagementAccess = false;
                mode = "no-general-management";
              };
              owningSubstrate = "nixos";
              persistenceExpectation = {
                kind = "ephemeral-fixture";
                required = false;
              };
              tenant = "mgmt";
            };
            nixos-printer01 = {
              addressDelivery = "endpoint-configured";
              assignment = "static-ipv4-or-ipv6-client";
              gampId = "FS-730-HDS-010-SDS-010-SMS-010";
              gateway4 = "10.20.20.1";
              gateway6 = "fd42:dead:beef:20::1";
              ipv4 = [ "10.20.20.60/24" ];
              ipv6 = [ "fd42:dead:beef:20::60/64" ];
              fixtureAuthority = {
                gampId = "FS-730-HDS-010-SDS-010-SMS-030";
                mayGrantManagementAccess = false;
                mayInferPolicy = false;
                policyAuthority = "intent-communication-contract";
              };
              managementBoundary = {
                fixturePlacementCreatesManagementAccess = false;
                mode = "declared-service-surfaces-only";
              };
              owningSubstrate = "nixos";
              persistenceExpectation = {
                gampId = "FS-730-HDS-010-SDS-010-SMS-030";
                kind = "persistent-service-state";
                paths = [ "/var/lib/cups" ];
                required = true;
                service = "cups";
              };
              serviceState = {
                gampId = "FS-730-HDS-010-SDS-010-SMS-020";
                required = true;
                service = "cups";
                systemdUnit = "cups.service";
                targetState = "running";
              };
              serviceSurfaces = {
                admin = {
                  gampId = "FS-740-HDS-010-SDS-010-SMS-010";
                  ports = [ 80 ];
                  protocol = "tcp";
                  service = "hat-printer-admin";
                };
                ipp = {
                  gampId = "FS-730-HDS-010-SDS-010-SMS-010";
                  ports = [ 631 ];
                  protocol = "tcp";
                  service = "hat-printer-ipp";
                };
              };
              tenant = "client";
              vm = {
                gampId = "FS-730-HDS-010-SDS-010-SMS-010";
                kind = "nixos-vm";
                role = "cups-printer";
                service = "cups";
              };
            };
            nixos-receiver01 = {
              addressDelivery = "endpoint-configured";
              assignment = "static-ipv4-or-ipv6-client";
              gampId = "FS-750-HDS-010-SDS-010-SMS-010";
              gateway4 = "10.20.20.1";
              gateway6 = "fd42:dead:beef:20::1";
              ipv4 = [ "10.20.20.70/24" ];
              ipv6 = [ "fd42:dead:beef:20::70/64" ];
              fixtureAuthority = {
                gampId = "FS-750-HDS-010-SDS-010-SMS-030";
                mayGrantDiscovery = false;
                mayGrantManagementAccess = false;
                mayGrantMulticastForwarding = false;
                mayGrantPayloadAccess = false;
                mayGrantReverseInitiation = false;
                mayGrantTenantReachability = false;
                mayInferPolicy = false;
                policyAuthority = "intent-communication-contract";
              };
              managementBoundary = {
                fixturePlacementCreatesManagementAccess = false;
                mode = "no-general-management";
              };
              owningSubstrate = "nixos";
              persistenceExpectation = {
                kind = "ephemeral-fixture";
                required = false;
              };
              serviceSurfaces = {
                control = {
                  gampId = "FS-750-HDS-010-SDS-010-SMS-020";
                  ports = [
                    8008
                    8009
                  ];
                  protocol = "tcp";
                  service = "hat-receiver-control";
                };
                discovery = {
                  gampId = "FS-760-HDS-010-SDS-010-SMS-010";
                  ports = [
                    5353
                    1900
                  ];
                  protocol = "udp";
                  service = "hat-receiver-discovery";
                };
              };
              tenant = "client";
            };
            nixos-streaming-test = {
              addressDelivery = "endpoint-configured";
              assignment = "static-ipv4-or-ipv6-client";
              gateway4 = "10.20.50.1";
              gateway6 = "fd42:dead:beef:50::1";
              ipv4 = [ "10.20.50.10/24" ];
              ipv6 = [ "fd42:dead:beef:50::10/64" ];
              managementBoundary = {
                fixturePlacementCreatesManagementAccess = false;
                mode = "no-general-management";
              };
              owningSubstrate = "nixos";
              persistenceExpectation = {
                kind = "ephemeral-fixture";
                required = false;
              };
              tenant = "streaming";
            };
          };
        };
        uplinks = {
          management = {
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
        };
      };
    };
  };
  endpoints = {
    clab-site-dns-client = {
      ipv4 = [ "10.50.20.1" ];
      ipv6 = [ "fd42:dead:feed:20::1" ];
    };
    nixos-site-dns-client = {
      ipv4 = [ "10.20.20.1" ];
      ipv6 = [ "fd42:dead:beef:20::1" ];
    };
  };
  realization = {
    nodes = {
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
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "nixos-access-client";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          p2p-nixos-access-client-nixos-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-access-client-p2p-nixos-access-client-nixos-downstream-selector";
            attach = {
              bridge = "br-site-a-p2p-nixos-access-client-nixos-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-nixos-access-client-nixos-downstream-selector";
          };
          tenant-client = {
            attach = {
              bridge = "client";
              kind = "bridge";
            };
            interface = {
              name = "tenant-client";
            };
            logicalInterface = "tenant-client";
          };
        };
      };
      esp0xdeadbeef-site-a-nixos-access-dmz = {
        advertisements = {
          dhcp4.tenant-dmz.domain = "lan.";
          dhcpv6 = { };
          ipv6Ra.tenant-dmz.dnssl = [ "lan." ];
        };
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "nixos-access-dmz";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          p2p-nixos-access-dmz-nixos-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-access-dmz-p2p-nixos-access-dmz-nixos-downstream-selector";
            attach = {
              bridge = "br-site-a-p2p-nixos-access-dmz-nixos-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-nixos-access-dmz-nixos-downstream-selector";
          };
          tenant-dmz = {
            attach = {
              bridge = "dmz";
              kind = "bridge";
            };
            interface = {
              name = "tenant-dmz";
            };
            logicalInterface = "tenant-dmz";
          };
        };
      };
      esp0xdeadbeef-site-a-nixos-access-guest = {
        advertisements = {
          dhcp4.tenant-guest.domain = "lan.";
          dhcpv6 = { };
          ipv6Ra.tenant-guest.dnssl = [ "lan." ];
        };
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "nixos-access-guest";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          p2p-nixos-access-guest-nixos-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-access-guest-p2p-nixos-access-guest-nixos-downstream-selector";
            attach = {
              bridge = "br-site-a-p2p-nixos-access-guest-nixos-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-nixos-access-guest-nixos-downstream-selector";
          };
          tenant-guest = {
            attach = {
              bridge = "guest";
              kind = "bridge";
            };
            interface = {
              name = "tenant-guest";
            };
            logicalInterface = "tenant-guest";
          };
        };
      };
      esp0xdeadbeef-site-a-nixos-access-iot = {
        advertisements = {
          dhcp4.tenant-iot.domain = "lan.";
          dhcpv6 = { };
          ipv6Ra.tenant-iot.dnssl = [ "lan." ];
        };
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "nixos-access-iot";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          p2p-nixos-access-iot-nixos-core-nebula = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-access-iot-p2p-nixos-access-iot-nixos-core-nebula";
            attach = {
              bridge = "br-site-a-p2p-nixos-access-iot-nixos-core-nebula";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-nixos-access-iot-nixos-core-nebula";
          };
          p2p-nixos-access-iot-nixos-core-wireguard-host128 = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-access-iot-p2p-nixos-access-iot-nixos-core-wireguard-host128";
            attach = {
              bridge = "br-site-a-p2p-nixos-access-iot-nixos-core-wireguard-host128";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-nixos-access-iot-nixos-core-wireguard-host128";
          };
          p2p-nixos-access-iot-nixos-core-wireguard-remote-egress = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-access-iot-p2p-nixos-access-iot-nixos-core-wireguard-remote-egress";
            attach = {
              bridge = "br-site-a-p2p-nixos-access-iot-nixos-core-wireguard-remote-egress";
              kind = "bridge";
            };
            interface = {
              name = "ens22";
            };
            link = "p2p-nixos-access-iot-nixos-core-wireguard-remote-egress";
          };
          p2p-nixos-access-iot-nixos-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-access-iot-p2p-nixos-access-iot-nixos-downstream-selector";
            attach = {
              bridge = "br-site-a-p2p-nixos-access-iot-nixos-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens23";
            };
            link = "p2p-nixos-access-iot-nixos-downstream-selector";
          };
          tenant-iot = {
            attach = {
              bridge = "iot";
              kind = "bridge";
            };
            interface = {
              name = "tenant-iot";
            };
            logicalInterface = "tenant-iot";
          };
        };
      };
      esp0xdeadbeef-site-a-nixos-access-management = {
        advertisements = {
          dhcp4.tenant-management.domain = "lan.";
          dhcpv6 = { };
          ipv6Ra.tenant-management.dnssl = [ "lan." ];
        };
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "nixos-access-management";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          p2p-nixos-access-management-nixos-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-access-management-p2p-nixos-access-management-nixos-downstream-selector";
            attach = {
              bridge = "br-site-a-p2p-nixos-access-management-nixos-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-nixos-access-management-nixos-downstream-selector";
          };
          tenant-management = {
            attach = {
              bridge = "mgmt";
              kind = "bridge";
            };
            interface = {
              name = "tenant-mgmt";
            };
            logicalInterface = "tenant-management";
          };
        };
      };
      esp0xdeadbeef-site-a-nixos-access-trusted = {
        advertisements = {
          dhcp4.tenant-trusted.domain = "lan.";
          dhcpv6 = { };
          ipv6Ra.tenant-trusted.dnssl = [ "lan." ];
        };
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "nixos-access-trusted";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          p2p-nixos-access-trusted-nixos-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-access-trusted-p2p-nixos-access-trusted-nixos-downstream-selector";
            attach = {
              bridge = "br-site-a-p2p-nixos-access-trusted-nixos-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-nixos-access-trusted-nixos-downstream-selector";
          };
          tenant-trusted = {
            attach = {
              bridge = "trusted";
              kind = "bridge";
            };
            interface = {
              name = "tenant-trusted";
            };
            logicalInterface = "tenant-trusted";
          };
        };
      };
      esp0xdeadbeef-site-a-nixos-access-work = {
        advertisements = {
          dhcp4.tenant-work.domain = "lan.";
          dhcpv6 = { };
          ipv6Ra.tenant-work.dnssl = [ "lan." ];
        };
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "nixos-access-work";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          p2p-nixos-access-work-nixos-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-access-work-p2p-nixos-access-work-nixos-downstream-selector";
            attach = {
              bridge = "br-site-a-p2p-nixos-access-work-nixos-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-nixos-access-work-nixos-downstream-selector";
          };
          tenant-work = {
            attach = {
              bridge = "work";
              kind = "bridge";
            };
            interface = {
              name = "tenant-work";
            };
            logicalInterface = "tenant-work";
          };
        };
      };
      esp0xdeadbeef-site-a-nixos-core-commercial-vpn = {
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "nixos-core-commercial-vpn";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          commercial-vpn = {
            attach = {
              bridge = "br-nixos-uplink-commercial-vpn";
              kind = "bridge";
            };
            external = true;
            interface = {
              name = "ens80";
            };
            uplink = "commercial-vpn";
          };
          p2p-nixos-core-commercial-vpn-nixos-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-core-commercial-vpn-p2p-nixos-core-commercial-vpn-nixos-upstream-selector";
            attach = {
              bridge = "br-site-a-p2p-nixos-core-commercial-vpn-nixos-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-nixos-core-commercial-vpn-nixos-upstream-selector";
          };
        };
      };
      esp0xdeadbeef-site-a-nixos-core-nebula = {
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "nixos-core-nebula";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          nebula-egress = {
            attach = {
              bridge = "br-nixos-uplink-nebula-egress";
              kind = "bridge";
            };
            external = true;
            interface = {
              name = "ens80";
            };
            uplink = "nebula-egress";
          };
          p2p-nixos-access-iot-nixos-core-nebula = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-core-nebula-p2p-nixos-access-iot-nixos-core-nebula";
            attach = {
              bridge = "br-site-a-p2p-nixos-access-iot-nixos-core-nebula";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-nixos-access-iot-nixos-core-nebula";
          };
          p2p-nixos-core-nebula-nixos-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-core-nebula-p2p-nixos-core-nebula-nixos-upstream-selector";
            attach = {
              bridge = "br-site-a-p2p-nixos-core-nebula-nixos-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-nixos-core-nebula-nixos-upstream-selector";
          };
        };
      };
      esp0xdeadbeef-site-a-nixos-core-route-import = {
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "nixos-core-route-import";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          p2p-nixos-core-route-import-nixos-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-core-route-import-p2p-nixos-core-route-import-nixos-upstream-selector";
            attach = {
              bridge = "br-site-a-p2p-nixos-core-route-import-nixos-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-nixos-core-route-import-nixos-upstream-selector";
          };
          route-import = {
            attach = {
              bridge = "br-nixos-uplink-route-import";
              kind = "bridge";
            };
            external = true;
            interface = {
              name = "ens80";
            };
            uplink = "route-import";
          };
        };
      };
      esp0xdeadbeef-site-a-nixos-core-testnet-host-isp = {
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "nixos-core-testnet-host-isp";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          p2p-nixos-core-testnet-host-isp-nixos-provider-handoff-access-a = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-core-testnet-host-isp-p2p-nixos-core-testnet-host-isp-nixos-provider-handoff-access-a";
            attach = {
              bridge = "br-site-a-p2p-nixos-core-testnet-host-isp-nixos-provider-handoff-access-a";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-nixos-core-testnet-host-isp-nixos-provider-handoff-access-a";
          };
          p2p-nixos-core-testnet-host-isp-nixos-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-core-testnet-host-isp-p2p-nixos-core-testnet-host-isp-nixos-upstream-selector";
            attach = {
              bridge = "br-site-a-p2p-nixos-core-testnet-host-isp-nixos-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-nixos-core-testnet-host-isp-nixos-upstream-selector";
          };
          testnet-host-isp = {
            attach = {
              bridge = "br-t-host";
              kind = "bridge";
            };
            external = true;
            interface = {
              name = "ens80";
            };
            uplink = "testnet-host-isp";
          };
        };
        services = {
          pppoe = {
            client = {
              credentials = {
                labOnly = true;
                passwordFile = "/run/secrets/hat-pppoe-password";
                usernameFile = "/run/secrets/hat-pppoe-username";
              };
              defaultRoute = true;
              interface = "p2p-nixos-core-testnet-host-isp-nixos-provider-handoff-access-a";
              mtu = 1492;
              runtimeInterface = "ppp0";
              usePeerDns = true;
            };
          };
        };
      };
      esp0xdeadbeef-site-a-nixos-core-testnet-routed-isp = {
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "nixos-core-testnet-routed-isp";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          p2p-nixos-core-testnet-routed-isp-nixos-provider-handoff-access-b = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-core-testnet-routed-isp-p2p-nixos-core-testnet-routed-isp-nixos-provider-handoff-access-b";
            attach = {
              bridge = "br-site-a-p2p-nixos-core-testnet-routed-isp-nixos-provider-handoff-access-b";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-nixos-core-testnet-routed-isp-nixos-provider-handoff-access-b";
          };
          p2p-nixos-core-testnet-routed-isp-nixos-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-core-testnet-routed-isp-p2p-nixos-core-testnet-routed-isp-nixos-upstream-selector";
            attach = {
              bridge = "br-site-a-p2p-nixos-core-testnet-routed-isp-nixos-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-nixos-core-testnet-routed-isp-nixos-upstream-selector";
          };
          testnet-routed-isp = {
            attach = {
              bridge = "br-t-routed";
              kind = "bridge";
            };
            external = true;
            interface = {
              name = "ens80";
            };
            uplink = "testnet-routed-isp";
          };
        };
        services = {
          pppoe = {
            client = {
              credentials = {
                labOnly = true;
                passwordFile = "/run/secrets/hat-pppoe-password";
                usernameFile = "/run/secrets/hat-pppoe-username";
              };
              defaultRoute = true;
              interface = "p2p-nixos-core-testnet-routed-isp-nixos-provider-handoff-access-b";
              mtu = 1492;
              runtimeInterface = "ppp1";
              usePeerDns = true;
            };
          };
        };
      };
      esp0xdeadbeef-site-a-nixos-core-upstream-vlan4 = {
        host = "s-router-nixos";
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
              name = "ens80";
            };
            uplink = "isp-a";
          };
          p2p-nixos-core-upstream-vlan4-nixos-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-core-upstream-vlan4-p2p-nixos-core-upstream-vlan4-nixos-upstream-selector";
            attach = {
              bridge = "br-site-a-p2p-nixos-core-upstream-vlan4-nixos-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-nixos-core-upstream-vlan4-nixos-upstream-selector";
          };
        };
      };
      esp0xdeadbeef-site-a-nixos-core-wireguard-host128 = {
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "nixos-core-wireguard-host128";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          p2p-nixos-access-iot-nixos-core-wireguard-host128 = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-core-wireguard-host128-p2p-nixos-access-iot-nixos-core-wireguard-host128";
            attach = {
              bridge = "br-site-a-p2p-nixos-access-iot-nixos-core-wireguard-host128";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-nixos-access-iot-nixos-core-wireguard-host128";
          };
          p2p-nixos-core-wireguard-host128-nixos-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-core-wireguard-host128-p2p-nixos-core-wireguard-host128-nixos-upstream-selector";
            attach = {
              bridge = "br-site-a-p2p-nixos-core-wireguard-host128-nixos-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-nixos-core-wireguard-host128-nixos-upstream-selector";
          };
          wireguard-host128 = {
            attach = {
              bridge = "br-nixos-uplink-wireguard-host128";
              kind = "bridge";
            };
            external = true;
            interface = {
              name = "ens80";
            };
            uplink = "wireguard-host128";
          };
        };
      };
      esp0xdeadbeef-site-a-nixos-core-wireguard-remote-egress = {
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "nixos-core-wireguard-remote-egress";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          p2p-nixos-access-iot-nixos-core-wireguard-remote-egress = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-core-wireguard-remote-egress-p2p-nixos-access-iot-nixos-core-wireguard-remote-egress";
            attach = {
              bridge = "br-site-a-p2p-nixos-access-iot-nixos-core-wireguard-remote-egress";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-nixos-access-iot-nixos-core-wireguard-remote-egress";
          };
          p2p-nixos-core-wireguard-remote-egress-nixos-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-core-wireguard-remote-egress-p2p-nixos-core-wireguard-remote-egress-nixos-upstream-selector";
            attach = {
              bridge = "br-site-a-p2p-nixos-core-wireguard-remote-egress-nixos-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-nixos-core-wireguard-remote-egress-nixos-upstream-selector";
          };
          wireguard-egress = {
            attach = {
              bridge = "br-nixos-uplink-wireguard-egress";
              kind = "bridge";
            };
            external = true;
            interface = {
              name = "ens80";
            };
            uplink = "wireguard-egress";
          };
        };
      };
      esp0xdeadbeef-site-a-nixos-downstream-selector = {
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "nixos-downstream-selector";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          p2p-nixos-access-client-nixos-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-access-client-nixos-downstream-selector";
            attach = {
              bridge = "br-site-a-p2p-nixos-access-client-nixos-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-nixos-access-client-nixos-downstream-selector";
          };
          p2p-nixos-access-dmz-nixos-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-access-dmz-nixos-downstream-selector";
            attach = {
              bridge = "br-site-a-p2p-nixos-access-dmz-nixos-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-nixos-access-dmz-nixos-downstream-selector";
          };
          p2p-nixos-access-guest-nixos-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-access-guest-nixos-downstream-selector";
            attach = {
              bridge = "br-site-a-p2p-nixos-access-guest-nixos-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens22";
            };
            link = "p2p-nixos-access-guest-nixos-downstream-selector";
          };
          p2p-nixos-access-iot-nixos-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-access-iot-nixos-downstream-selector";
            attach = {
              bridge = "br-site-a-p2p-nixos-access-iot-nixos-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens23";
            };
            link = "p2p-nixos-access-iot-nixos-downstream-selector";
          };
          p2p-nixos-access-management-nixos-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-access-management-nixos-downstream-selector";
            attach = {
              bridge = "br-site-a-p2p-nixos-access-management-nixos-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens24";
            };
            link = "p2p-nixos-access-management-nixos-downstream-selector";
          };
          p2p-nixos-access-trusted-nixos-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-access-trusted-nixos-downstream-selector";
            attach = {
              bridge = "br-site-a-p2p-nixos-access-trusted-nixos-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens25";
            };
            link = "p2p-nixos-access-trusted-nixos-downstream-selector";
          };
          p2p-nixos-access-work-nixos-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-access-work-nixos-downstream-selector";
            attach = {
              bridge = "br-site-a-p2p-nixos-access-work-nixos-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens26";
            };
            link = "p2p-nixos-access-work-nixos-downstream-selector";
          };
          p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-client = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-client";
            attach = {
              bridge = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-client";
              kind = "bridge";
            };
            interface = {
              name = "ens27";
            };
            link = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-client";
          };
          p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-dmz = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-dmz";
            attach = {
              bridge = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-dmz";
              kind = "bridge";
            };
            interface = {
              name = "ens28";
            };
            link = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-dmz";
          };
          p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-guest = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-guest";
            attach = {
              bridge = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-guest";
              kind = "bridge";
            };
            interface = {
              name = "ens29";
            };
            link = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-guest";
          };
          p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-iot = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-iot";
            attach = {
              bridge = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-iot";
              kind = "bridge";
            };
            interface = {
              name = "ens30";
            };
            link = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-iot";
          };
          p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-management = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-management";
            attach = {
              bridge = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-management";
              kind = "bridge";
            };
            interface = {
              name = "ens31";
            };
            link = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-management";
          };
          p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-trusted = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-trusted";
            attach = {
              bridge = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-trusted";
              kind = "bridge";
            };
            interface = {
              name = "ens32";
            };
            link = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-trusted";
          };
          p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-work = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-work";
            attach = {
              bridge = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-work";
              kind = "bridge";
            };
            interface = {
              name = "ens33";
            };
            link = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-work";
          };
          p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-a = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-a";
            attach = {
              bridge = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-a";
              kind = "bridge";
            };
            interface = {
              name = "ens34";
            };
            link = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-a";
          };
          p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-b = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-b";
            attach = {
              bridge = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-b";
              kind = "bridge";
            };
            interface = {
              name = "ens35";
            };
            link = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-b";
          };
          p2p-nixos-downstream-selector-nixos-provider-handoff-access-a = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-downstream-selector-nixos-provider-handoff-access-a";
            attach = {
              bridge = "br-site-a-p2p-nixos-downstream-selector-nixos-provider-handoff-access-a";
              kind = "bridge";
            };
            interface = {
              name = "ens36";
            };
            link = "p2p-nixos-downstream-selector-nixos-provider-handoff-access-a";
          };
          p2p-nixos-downstream-selector-nixos-provider-handoff-access-b = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-downstream-selector-p2p-nixos-downstream-selector-nixos-provider-handoff-access-b";
            attach = {
              bridge = "br-site-a-p2p-nixos-downstream-selector-nixos-provider-handoff-access-b";
              kind = "bridge";
            };
            interface = {
              name = "ens37";
            };
            link = "p2p-nixos-downstream-selector-nixos-provider-handoff-access-b";
          };
        };
      };
      esp0xdeadbeef-site-a-nixos-policy = {
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "nixos-policy";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-client = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-client";
            attach = {
              bridge = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-client";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-client";
          };
          p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-dmz = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-dmz";
            attach = {
              bridge = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-dmz";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-dmz";
          };
          p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-guest = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-guest";
            attach = {
              bridge = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-guest";
              kind = "bridge";
            };
            interface = {
              name = "ens22";
            };
            link = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-guest";
          };
          p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-iot = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-iot";
            attach = {
              bridge = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-iot";
              kind = "bridge";
            };
            interface = {
              name = "ens23";
            };
            link = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-iot";
          };
          p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-management = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-management";
            attach = {
              bridge = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-management";
              kind = "bridge";
            };
            interface = {
              name = "ens24";
            };
            link = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-management";
          };
          p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-trusted = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-trusted";
            attach = {
              bridge = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-trusted";
              kind = "bridge";
            };
            interface = {
              name = "ens25";
            };
            link = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-trusted";
          };
          p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-work = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-work";
            attach = {
              bridge = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-work";
              kind = "bridge";
            };
            interface = {
              name = "ens26";
            };
            link = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-work";
          };
          p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-a = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-a";
            attach = {
              bridge = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-a";
              kind = "bridge";
            };
            interface = {
              name = "ens27";
            };
            link = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-a";
          };
          p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-b = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-b";
            attach = {
              bridge = "br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-b";
              kind = "bridge";
            };
            interface = {
              name = "ens28";
            };
            link = "p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-b";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-host-isp = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-host-isp";
            attach = {
              bridge = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-host-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens29";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-host-isp";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-routed-isp = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-routed-isp";
            attach = {
              bridge = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-routed-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens30";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-routed-isp";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-guest--uplink-isp-a = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-guest--uplink-isp-a";
            attach = {
              bridge = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-guest--uplink-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "ens31";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-guest--uplink-isp-a";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-nebula-egress = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-nebula-egress";
            attach = {
              bridge = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-nebula-egress";
              kind = "bridge";
            };
            interface = {
              name = "ens32";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-nebula-egress";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-wireguard-egress = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-wireguard-egress";
            attach = {
              bridge = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-wireguard-egress";
              kind = "bridge";
            };
            interface = {
              name = "ens33";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-wireguard-egress";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-work--uplink-isp-a = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-work--uplink-isp-a";
            attach = {
              bridge = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-work--uplink-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "ens34";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-work--uplink-isp-a";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-isp-a = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-isp-a";
            attach = {
              bridge = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "ens35";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-isp-a";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-a = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-a";
            attach = {
              bridge = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "ens36";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-a";
          };
        };
      };
      esp0xdeadbeef-site-a-nixos-provider-handoff-access-a = {
        advertisements = {
          dhcp4 = {
            tenant-provider-handoff-a = {
              enabled = false;
            };
          };
          dhcpv6 = { };
          ipv6Ra = {
            tenant-provider-handoff-a = {
              enabled = false;
            };
          };
        };
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "nixos-provider-handoff-access-a";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          p2p-nixos-core-testnet-host-isp-nixos-provider-handoff-access-a = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-provider-handoff-access-a-p2p-nixos-core-testnet-host-isp-nixos-provider-handoff-access-a";
            attach = {
              bridge = "br-site-a-p2p-nixos-core-testnet-host-isp-nixos-provider-handoff-access-a";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-nixos-core-testnet-host-isp-nixos-provider-handoff-access-a";
          };
          p2p-nixos-downstream-selector-nixos-provider-handoff-access-a = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-provider-handoff-access-a-p2p-nixos-downstream-selector-nixos-provider-handoff-access-a";
            attach = {
              bridge = "br-site-a-p2p-nixos-downstream-selector-nixos-provider-handoff-access-a";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-nixos-downstream-selector-nixos-provider-handoff-access-a";
          };
        };
        services = {
          pppoe = {
            server = {
              credentials = {
                labOnly = true;
                passwordFile = "/run/secrets/hat-pppoe-password";
                usernameFile = "/run/secrets/hat-pppoe-username";
              };
              customerAddress = "203.0.113.4";
              implementation = "rp-pppoe";
              interface = "p2p-nixos-core-testnet-host-isp-nixos-provider-handoff-access-a";
              maxSessions = 32;
              mtu = 1492;
              providerAddress = "203.0.113.5";
            };
          };
        };
      };
      esp0xdeadbeef-site-a-nixos-provider-handoff-access-b = {
        advertisements = {
          dhcp4 = {
            tenant-provider-handoff-b = {
              enabled = false;
            };
          };
          dhcpv6 = { };
          ipv6Ra = {
            tenant-provider-handoff-b = {
              enabled = false;
            };
          };
        };
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "nixos-provider-handoff-access-b";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          p2p-nixos-core-testnet-routed-isp-nixos-provider-handoff-access-b = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-provider-handoff-access-b-p2p-nixos-core-testnet-routed-isp-nixos-provider-handoff-access-b";
            attach = {
              bridge = "br-site-a-p2p-nixos-core-testnet-routed-isp-nixos-provider-handoff-access-b";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-nixos-core-testnet-routed-isp-nixos-provider-handoff-access-b";
          };
          p2p-nixos-downstream-selector-nixos-provider-handoff-access-b = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-provider-handoff-access-b-p2p-nixos-downstream-selector-nixos-provider-handoff-access-b";
            attach = {
              bridge = "br-site-a-p2p-nixos-downstream-selector-nixos-provider-handoff-access-b";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-nixos-downstream-selector-nixos-provider-handoff-access-b";
          };
        };
        services = {
          pppoe = {
            server = {
              credentials = {
                labOnly = true;
                passwordFile = "/run/secrets/hat-pppoe-password";
                usernameFile = "/run/secrets/hat-pppoe-username";
              };
              customerAddress = "203.0.113.2";
              implementation = "rp-pppoe";
              interface = "p2p-nixos-core-testnet-routed-isp-nixos-provider-handoff-access-b";
              maxSessions = 32;
              mtu = 1492;
              providerAddress = "203.0.113.1";
            };
          };
        };
      };
      esp0xdeadbeef-site-a-nixos-upstream-selector = {
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "nixos-upstream-selector";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          p2p-nixos-core-commercial-vpn-nixos-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-core-commercial-vpn-nixos-upstream-selector";
            attach = {
              bridge = "br-site-a-p2p-nixos-core-commercial-vpn-nixos-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-nixos-core-commercial-vpn-nixos-upstream-selector";
          };
          p2p-nixos-core-nebula-nixos-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-core-nebula-nixos-upstream-selector";
            attach = {
              bridge = "br-site-a-p2p-nixos-core-nebula-nixos-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-nixos-core-nebula-nixos-upstream-selector";
          };
          p2p-nixos-core-route-import-nixos-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-core-route-import-nixos-upstream-selector";
            attach = {
              bridge = "br-site-a-p2p-nixos-core-route-import-nixos-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens22";
            };
            link = "p2p-nixos-core-route-import-nixos-upstream-selector";
          };
          p2p-nixos-core-testnet-host-isp-nixos-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-core-testnet-host-isp-nixos-upstream-selector";
            attach = {
              bridge = "br-site-a-p2p-nixos-core-testnet-host-isp-nixos-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens23";
            };
            link = "p2p-nixos-core-testnet-host-isp-nixos-upstream-selector";
          };
          p2p-nixos-core-testnet-routed-isp-nixos-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-core-testnet-routed-isp-nixos-upstream-selector";
            attach = {
              bridge = "br-site-a-p2p-nixos-core-testnet-routed-isp-nixos-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens24";
            };
            link = "p2p-nixos-core-testnet-routed-isp-nixos-upstream-selector";
          };
          p2p-nixos-core-upstream-vlan4-nixos-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-core-upstream-vlan4-nixos-upstream-selector";
            attach = {
              bridge = "br-site-a-p2p-nixos-core-upstream-vlan4-nixos-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens25";
            };
            link = "p2p-nixos-core-upstream-vlan4-nixos-upstream-selector";
          };
          p2p-nixos-core-wireguard-host128-nixos-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-core-wireguard-host128-nixos-upstream-selector";
            attach = {
              bridge = "br-site-a-p2p-nixos-core-wireguard-host128-nixos-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens26";
            };
            link = "p2p-nixos-core-wireguard-host128-nixos-upstream-selector";
          };
          p2p-nixos-core-wireguard-remote-egress-nixos-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-core-wireguard-remote-egress-nixos-upstream-selector";
            attach = {
              bridge = "br-site-a-p2p-nixos-core-wireguard-remote-egress-nixos-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens27";
            };
            link = "p2p-nixos-core-wireguard-remote-egress-nixos-upstream-selector";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-host-isp = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-host-isp";
            attach = {
              bridge = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-host-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens28";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-host-isp";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-routed-isp = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-routed-isp";
            attach = {
              bridge = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-routed-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens29";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-routed-isp";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-guest--uplink-isp-a = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-guest--uplink-isp-a";
            attach = {
              bridge = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-guest--uplink-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "ens30";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-guest--uplink-isp-a";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-nebula-egress = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-nebula-egress";
            attach = {
              bridge = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-nebula-egress";
              kind = "bridge";
            };
            interface = {
              name = "ens31";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-nebula-egress";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-wireguard-egress = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-wireguard-egress";
            attach = {
              bridge = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-wireguard-egress";
              kind = "bridge";
            };
            interface = {
              name = "ens32";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-wireguard-egress";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-work--uplink-isp-a = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-work--uplink-isp-a";
            attach = {
              bridge = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-work--uplink-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "ens33";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-work--uplink-isp-a";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-isp-a = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-isp-a";
            attach = {
              bridge = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "ens34";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-isp-a";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-a = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-a";
            attach = {
              bridge = "br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "ens35";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-a";
          };
        };
      };
      esp0xdeadbeef-site-b-clab-access-client = {
        advertisements = {
          dhcp4 = {
            tenant-client = {
              dnsServers = [ "router-self" ];
              domain = "lan.";
            };
          };
          dhcpv6 = { };
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
          name = "clab-access-client";
          site = "site-b";
        };
        platform = "linux";
        ports = {
          p2p-clab-access-client-clab-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-access-client-p2p-clab-access-client-clab-downstream-selector";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-access-client-clab-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-clab-access-client-clab-downstream-selector";
          };
          tenant-client = {
            attach = {
              bridge = "stub-clab-client";
              kind = "bridge";
            };
            interface = {
              name = "tenant-client";
            };
            logicalInterface = "tenant-client";
          };
        };
      };
      esp0xdeadbeef-site-b-clab-access-dmz = {
        advertisements = {
          dhcp4.tenant-dmz.domain = "lan.";
          dhcpv6 = { };
          ipv6Ra.tenant-dmz.dnssl = [ "lan." ];
        };
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "clab-access-dmz";
          site = "site-b";
        };
        platform = "linux";
        ports = {
          p2p-clab-access-dmz-clab-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-access-dmz-p2p-clab-access-dmz-clab-downstream-selector";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-access-dmz-clab-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-clab-access-dmz-clab-downstream-selector";
          };
          tenant-dmz = {
            attach = {
              bridge = "stub-clab-dmz";
              kind = "bridge";
            };
            interface = {
              name = "tenant-dmz";
            };
            logicalInterface = "tenant-dmz";
          };
        };
      };
      esp0xdeadbeef-site-b-clab-access-guest = {
        advertisements = {
          dhcp4.tenant-guest.domain = "lan.";
          dhcpv6 = { };
          ipv6Ra.tenant-guest.dnssl = [ "lan." ];
        };
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "clab-access-guest";
          site = "site-b";
        };
        platform = "linux";
        ports = {
          p2p-clab-access-guest-clab-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-access-guest-p2p-clab-access-guest-clab-downstream-selector";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-access-guest-clab-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-clab-access-guest-clab-downstream-selector";
          };
          tenant-guest = {
            attach = {
              bridge = "stub-clab-guest";
              kind = "bridge";
            };
            interface = {
              name = "tenant-guest";
            };
            logicalInterface = "tenant-guest";
          };
        };
      };
      esp0xdeadbeef-site-b-clab-access-iot = {
        advertisements = {
          dhcp4.tenant-iot.domain = "lan.";
          dhcpv6 = { };
          ipv6Ra.tenant-iot.dnssl = [ "lan." ];
        };
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "clab-access-iot";
          site = "site-b";
        };
        platform = "linux";
        ports = {
          p2p-clab-access-iot-clab-core-nebula = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-access-iot-p2p-clab-access-iot-clab-core-nebula";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-access-iot-clab-core-nebula";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-clab-access-iot-clab-core-nebula";
          };
          p2p-clab-access-iot-clab-core-wireguard-host128 = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-access-iot-p2p-clab-access-iot-clab-core-wireguard-host128";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-access-iot-clab-core-wireguard-host128";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-clab-access-iot-clab-core-wireguard-host128";
          };
          p2p-clab-access-iot-clab-core-wireguard-remote-egress = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-access-iot-p2p-clab-access-iot-clab-core-wireguard-remote-egress";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-access-iot-clab-core-wireguard-remote-egress";
              kind = "bridge";
            };
            interface = {
              name = "ens22";
            };
            link = "p2p-clab-access-iot-clab-core-wireguard-remote-egress";
          };
          p2p-clab-access-iot-clab-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-access-iot-p2p-clab-access-iot-clab-downstream-selector";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-access-iot-clab-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens23";
            };
            link = "p2p-clab-access-iot-clab-downstream-selector";
          };
          tenant-iot = {
            attach = {
              bridge = "stub-clab-iot";
              kind = "bridge";
            };
            interface = {
              name = "tenant-iot";
            };
            logicalInterface = "tenant-iot";
          };
        };
      };
      esp0xdeadbeef-site-b-clab-access-management = {
        advertisements = {
          dhcp4.tenant-management.domain = "lan.";
          dhcpv6 = { };
          ipv6Ra.tenant-management.dnssl = [ "lan." ];
        };
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "clab-access-management";
          site = "site-b";
        };
        platform = "linux";
        ports = {
          p2p-clab-access-management-clab-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-access-management-p2p-clab-access-management-clab-downstream-selector";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-access-management-clab-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-clab-access-management-clab-downstream-selector";
          };
          tenant-management = {
            attach = {
              bridge = "stub-clab-mgmt";
              kind = "bridge";
            };
            interface = {
              name = "tenant-mgmt";
            };
            logicalInterface = "tenant-management";
          };
        };
      };
      esp0xdeadbeef-site-b-clab-access-trusted = {
        advertisements = {
          dhcp4.tenant-trusted.domain = "lan.";
          dhcpv6 = { };
          ipv6Ra.tenant-trusted.dnssl = [ "lan." ];
        };
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "clab-access-trusted";
          site = "site-b";
        };
        platform = "linux";
        ports = {
          p2p-clab-access-trusted-clab-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-access-trusted-p2p-clab-access-trusted-clab-downstream-selector";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-access-trusted-clab-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-clab-access-trusted-clab-downstream-selector";
          };
          tenant-trusted = {
            attach = {
              bridge = "stub-clab-trusted";
              kind = "bridge";
            };
            interface = {
              name = "tenant-trusted";
            };
            logicalInterface = "tenant-trusted";
          };
        };
      };
      esp0xdeadbeef-site-b-clab-access-work = {
        advertisements = {
          dhcp4.tenant-work.domain = "lan.";
          dhcpv6 = { };
          ipv6Ra.tenant-work.dnssl = [ "lan." ];
        };
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "clab-access-work";
          site = "site-b";
        };
        platform = "linux";
        ports = {
          p2p-clab-access-work-clab-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-access-work-p2p-clab-access-work-clab-downstream-selector";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-access-work-clab-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-clab-access-work-clab-downstream-selector";
          };
          tenant-work = {
            attach = {
              bridge = "stub-clab-work";
              kind = "bridge";
            };
            interface = {
              name = "tenant-work";
            };
            logicalInterface = "tenant-work";
          };
        };
      };
      esp0xdeadbeef-site-b-clab-core-commercial-vpn = {
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "clab-core-commercial-vpn";
          site = "site-b";
        };
        platform = "linux";
        ports = {
          commercial-vpn = {
            attach = {
              bridge = "stub-clab-br-nixos-uplink-commercial-vpn";
              kind = "bridge";
            };
            external = true;
            interface = {
              name = "ens80";
            };
            uplink = "commercial-vpn";
          };
          p2p-clab-core-commercial-vpn-clab-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-core-commercial-vpn-p2p-clab-core-commercial-vpn-clab-upstream-selector";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-core-commercial-vpn-clab-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-clab-core-commercial-vpn-clab-upstream-selector";
          };
        };
      };
      esp0xdeadbeef-site-b-clab-core-nebula = {
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "clab-core-nebula";
          site = "site-b";
        };
        platform = "linux";
        ports = {
          nebula-egress = {
            attach = {
              bridge = "stub-clab-br-nixos-uplink-nebula-egress";
              kind = "bridge";
            };
            external = true;
            interface = {
              name = "ens80";
            };
            uplink = "nebula-egress";
          };
          p2p-clab-access-iot-clab-core-nebula = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-core-nebula-p2p-clab-access-iot-clab-core-nebula";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-access-iot-clab-core-nebula";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-clab-access-iot-clab-core-nebula";
          };
          p2p-clab-core-nebula-clab-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-core-nebula-p2p-clab-core-nebula-clab-upstream-selector";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-core-nebula-clab-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-clab-core-nebula-clab-upstream-selector";
          };
        };
      };
      esp0xdeadbeef-site-b-clab-core-route-import = {
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "clab-core-route-import";
          site = "site-b";
        };
        platform = "linux";
        ports = {
          p2p-clab-core-route-import-clab-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-core-route-import-p2p-clab-core-route-import-clab-upstream-selector";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-core-route-import-clab-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-clab-core-route-import-clab-upstream-selector";
          };
          route-import = {
            attach = {
              bridge = "stub-clab-br-nixos-uplink-route-import";
              kind = "bridge";
            };
            external = true;
            interface = {
              name = "ens80";
            };
            uplink = "route-import";
          };
        };
      };
      esp0xdeadbeef-site-b-clab-core-testnet-host-isp = {
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "clab-core-testnet-host-isp";
          site = "site-b";
        };
        platform = "linux";
        ports = {
          p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-core-testnet-host-isp-p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a";
          };
          p2p-clab-core-testnet-host-isp-clab-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-core-testnet-host-isp-p2p-clab-core-testnet-host-isp-clab-upstream-selector";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-core-testnet-host-isp-clab-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-clab-core-testnet-host-isp-clab-upstream-selector";
          };
          testnet-host-isp = {
            attach = {
              bridge = "stub-clab-br-t-host";
              kind = "bridge";
            };
            external = true;
            interface = {
              name = "ens80";
            };
            uplink = "testnet-host-isp";
          };
        };
        services = {
          pppoe = {
            client = {
              credentials = {
                labOnly = true;
                passwordFile = "/run/secrets/hat-pppoe-password";
                usernameFile = "/run/secrets/hat-pppoe-username";
              };
              defaultRoute = true;
              interface = "p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a";
              mtu = 1492;
              runtimeInterface = "ppp0";
              usePeerDns = true;
            };
          };
        };
      };
      esp0xdeadbeef-site-b-clab-core-testnet-routed-isp = {
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "clab-core-testnet-routed-isp";
          site = "site-b";
        };
        platform = "linux";
        ports = {
          p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-core-testnet-routed-isp-p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b";
          };
          p2p-clab-core-testnet-routed-isp-clab-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-core-testnet-routed-isp-p2p-clab-core-testnet-routed-isp-clab-upstream-selector";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-core-testnet-routed-isp-clab-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-clab-core-testnet-routed-isp-clab-upstream-selector";
          };
          testnet-routed-isp = {
            attach = {
              bridge = "stub-clab-br-t-routed";
              kind = "bridge";
            };
            external = true;
            interface = {
              name = "ens80";
            };
            uplink = "testnet-routed-isp";
          };
        };
        services = {
          pppoe = {
            client = {
              credentials = {
                labOnly = true;
                passwordFile = "/run/secrets/hat-pppoe-password";
                usernameFile = "/run/secrets/hat-pppoe-username";
              };
              defaultRoute = true;
              interface = "p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b";
              mtu = 1492;
              runtimeInterface = "ppp1";
              usePeerDns = true;
            };
          };
        };
      };
      esp0xdeadbeef-site-b-clab-core-upstream-vlan4 = {
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "clab-core-upstream-vlan4";
          site = "site-b";
        };
        platform = "linux";
        ports = {
          isp-a = {
            attach = {
              bridge = "stub-clab-br-uplink0";
              kind = "bridge";
              parentUplink = "uplink-isp-a";
            };
            external = true;
            interface = {
              name = "ens80";
            };
            uplink = "isp-a";
          };
          p2p-clab-core-upstream-vlan4-clab-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-core-upstream-vlan4-p2p-clab-core-upstream-vlan4-clab-upstream-selector";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-core-upstream-vlan4-clab-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-clab-core-upstream-vlan4-clab-upstream-selector";
          };
        };
      };
      esp0xdeadbeef-site-b-clab-core-wireguard-host128 = {
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "clab-core-wireguard-host128";
          site = "site-b";
        };
        platform = "linux";
        ports = {
          p2p-clab-access-iot-clab-core-wireguard-host128 = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-core-wireguard-host128-p2p-clab-access-iot-clab-core-wireguard-host128";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-access-iot-clab-core-wireguard-host128";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-clab-access-iot-clab-core-wireguard-host128";
          };
          p2p-clab-core-wireguard-host128-clab-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-core-wireguard-host128-p2p-clab-core-wireguard-host128-clab-upstream-selector";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-core-wireguard-host128-clab-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-clab-core-wireguard-host128-clab-upstream-selector";
          };
          wireguard-host128 = {
            attach = {
              bridge = "stub-clab-br-nixos-uplink-wireguard-host128";
              kind = "bridge";
            };
            external = true;
            interface = {
              name = "ens80";
            };
            uplink = "wireguard-host128";
          };
        };
      };
      esp0xdeadbeef-site-b-clab-core-wireguard-remote-egress = {
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "clab-core-wireguard-remote-egress";
          site = "site-b";
        };
        platform = "linux";
        ports = {
          p2p-clab-access-iot-clab-core-wireguard-remote-egress = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-core-wireguard-remote-egress-p2p-clab-access-iot-clab-core-wireguard-remote-egress";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-access-iot-clab-core-wireguard-remote-egress";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-clab-access-iot-clab-core-wireguard-remote-egress";
          };
          p2p-clab-core-wireguard-remote-egress-clab-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-core-wireguard-remote-egress-p2p-clab-core-wireguard-remote-egress-clab-upstream-selector";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-core-wireguard-remote-egress-clab-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-clab-core-wireguard-remote-egress-clab-upstream-selector";
          };
          wireguard-egress = {
            attach = {
              bridge = "stub-clab-br-nixos-uplink-wireguard-egress";
              kind = "bridge";
            };
            external = true;
            interface = {
              name = "ens80";
            };
            uplink = "wireguard-egress";
          };
        };
      };
      esp0xdeadbeef-site-b-clab-downstream-selector = {
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "clab-downstream-selector";
          site = "site-b";
        };
        platform = "linux";
        ports = {
          p2p-clab-access-client-clab-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-access-client-clab-downstream-selector";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-access-client-clab-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-clab-access-client-clab-downstream-selector";
          };
          p2p-clab-access-dmz-clab-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-access-dmz-clab-downstream-selector";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-access-dmz-clab-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-clab-access-dmz-clab-downstream-selector";
          };
          p2p-clab-access-guest-clab-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-access-guest-clab-downstream-selector";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-access-guest-clab-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens22";
            };
            link = "p2p-clab-access-guest-clab-downstream-selector";
          };
          p2p-clab-access-iot-clab-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-access-iot-clab-downstream-selector";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-access-iot-clab-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens23";
            };
            link = "p2p-clab-access-iot-clab-downstream-selector";
          };
          p2p-clab-access-management-clab-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-access-management-clab-downstream-selector";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-access-management-clab-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens24";
            };
            link = "p2p-clab-access-management-clab-downstream-selector";
          };
          p2p-clab-access-trusted-clab-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-access-trusted-clab-downstream-selector";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-access-trusted-clab-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens25";
            };
            link = "p2p-clab-access-trusted-clab-downstream-selector";
          };
          p2p-clab-access-work-clab-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-access-work-clab-downstream-selector";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-access-work-clab-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens26";
            };
            link = "p2p-clab-access-work-clab-downstream-selector";
          };
          p2p-clab-downstream-selector-clab-policy--access-clab-access-client = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-downstream-selector-clab-policy--access-clab-access-client";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-client";
              kind = "bridge";
            };
            interface = {
              name = "ens27";
            };
            link = "p2p-clab-downstream-selector-clab-policy--access-clab-access-client";
          };
          p2p-clab-downstream-selector-clab-policy--access-clab-access-dmz = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-downstream-selector-clab-policy--access-clab-access-dmz";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-dmz";
              kind = "bridge";
            };
            interface = {
              name = "ens28";
            };
            link = "p2p-clab-downstream-selector-clab-policy--access-clab-access-dmz";
          };
          p2p-clab-downstream-selector-clab-policy--access-clab-access-guest = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-downstream-selector-clab-policy--access-clab-access-guest";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-guest";
              kind = "bridge";
            };
            interface = {
              name = "ens29";
            };
            link = "p2p-clab-downstream-selector-clab-policy--access-clab-access-guest";
          };
          p2p-clab-downstream-selector-clab-policy--access-clab-access-iot = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-downstream-selector-clab-policy--access-clab-access-iot";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-iot";
              kind = "bridge";
            };
            interface = {
              name = "ens30";
            };
            link = "p2p-clab-downstream-selector-clab-policy--access-clab-access-iot";
          };
          p2p-clab-downstream-selector-clab-policy--access-clab-access-management = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-downstream-selector-clab-policy--access-clab-access-management";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-management";
              kind = "bridge";
            };
            interface = {
              name = "ens31";
            };
            link = "p2p-clab-downstream-selector-clab-policy--access-clab-access-management";
          };
          p2p-clab-downstream-selector-clab-policy--access-clab-access-trusted = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-downstream-selector-clab-policy--access-clab-access-trusted";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-trusted";
              kind = "bridge";
            };
            interface = {
              name = "ens32";
            };
            link = "p2p-clab-downstream-selector-clab-policy--access-clab-access-trusted";
          };
          p2p-clab-downstream-selector-clab-policy--access-clab-access-work = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-downstream-selector-clab-policy--access-clab-access-work";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-work";
              kind = "bridge";
            };
            interface = {
              name = "ens33";
            };
            link = "p2p-clab-downstream-selector-clab-policy--access-clab-access-work";
          };
          p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-a = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-a";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-a";
              kind = "bridge";
            };
            interface = {
              name = "ens34";
            };
            link = "p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-a";
          };
          p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-b = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-b";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-b";
              kind = "bridge";
            };
            interface = {
              name = "ens35";
            };
            link = "p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-b";
          };
          p2p-clab-downstream-selector-clab-provider-handoff-access-a = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-downstream-selector-clab-provider-handoff-access-a";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-downstream-selector-clab-provider-handoff-access-a";
              kind = "bridge";
            };
            interface = {
              name = "ens36";
            };
            link = "p2p-clab-downstream-selector-clab-provider-handoff-access-a";
          };
          p2p-clab-downstream-selector-clab-provider-handoff-access-b = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-downstream-selector-p2p-clab-downstream-selector-clab-provider-handoff-access-b";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-downstream-selector-clab-provider-handoff-access-b";
              kind = "bridge";
            };
            interface = {
              name = "ens37";
            };
            link = "p2p-clab-downstream-selector-clab-provider-handoff-access-b";
          };
        };
      };
      esp0xdeadbeef-site-b-clab-policy = {
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "clab-policy";
          site = "site-b";
        };
        platform = "linux";
        ports = {
          p2p-clab-downstream-selector-clab-policy--access-clab-access-client = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-downstream-selector-clab-policy--access-clab-access-client";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-client";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-clab-downstream-selector-clab-policy--access-clab-access-client";
          };
          p2p-clab-downstream-selector-clab-policy--access-clab-access-dmz = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-downstream-selector-clab-policy--access-clab-access-dmz";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-dmz";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-clab-downstream-selector-clab-policy--access-clab-access-dmz";
          };
          p2p-clab-downstream-selector-clab-policy--access-clab-access-guest = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-downstream-selector-clab-policy--access-clab-access-guest";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-guest";
              kind = "bridge";
            };
            interface = {
              name = "ens22";
            };
            link = "p2p-clab-downstream-selector-clab-policy--access-clab-access-guest";
          };
          p2p-clab-downstream-selector-clab-policy--access-clab-access-iot = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-downstream-selector-clab-policy--access-clab-access-iot";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-iot";
              kind = "bridge";
            };
            interface = {
              name = "ens23";
            };
            link = "p2p-clab-downstream-selector-clab-policy--access-clab-access-iot";
          };
          p2p-clab-downstream-selector-clab-policy--access-clab-access-management = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-downstream-selector-clab-policy--access-clab-access-management";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-management";
              kind = "bridge";
            };
            interface = {
              name = "ens24";
            };
            link = "p2p-clab-downstream-selector-clab-policy--access-clab-access-management";
          };
          p2p-clab-downstream-selector-clab-policy--access-clab-access-trusted = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-downstream-selector-clab-policy--access-clab-access-trusted";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-trusted";
              kind = "bridge";
            };
            interface = {
              name = "ens25";
            };
            link = "p2p-clab-downstream-selector-clab-policy--access-clab-access-trusted";
          };
          p2p-clab-downstream-selector-clab-policy--access-clab-access-work = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-downstream-selector-clab-policy--access-clab-access-work";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-work";
              kind = "bridge";
            };
            interface = {
              name = "ens26";
            };
            link = "p2p-clab-downstream-selector-clab-policy--access-clab-access-work";
          };
          p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-a = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-a";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-a";
              kind = "bridge";
            };
            interface = {
              name = "ens27";
            };
            link = "p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-a";
          };
          p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-b = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-b";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-b";
              kind = "bridge";
            };
            interface = {
              name = "ens28";
            };
            link = "p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-b";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-host-isp = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-host-isp";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-host-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens29";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-host-isp";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-routed-isp = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-routed-isp";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-routed-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens30";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-routed-isp";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-access-guest--uplink-isp-a = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-policy-clab-upstream-selector--access-clab-access-guest--uplink-isp-a";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-guest--uplink-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "ens31";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-access-guest--uplink-isp-a";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-nebula-egress = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-nebula-egress";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-nebula-egress";
              kind = "bridge";
            };
            interface = {
              name = "ens32";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-nebula-egress";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-wireguard-egress = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-wireguard-egress";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-wireguard-egress";
              kind = "bridge";
            };
            interface = {
              name = "ens33";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-wireguard-egress";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-access-work--uplink-isp-a = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-policy-clab-upstream-selector--access-clab-access-work--uplink-isp-a";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-work--uplink-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "ens34";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-access-work--uplink-isp-a";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-isp-a = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-isp-a";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "ens35";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-isp-a";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-a = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-a";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "ens36";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-a";
          };
        };
      };
      esp0xdeadbeef-site-b-clab-provider-handoff-access-a = {
        advertisements = {
          dhcp4 = {
            tenant-provider-handoff-a = {
              enabled = false;
            };
          };
          dhcpv6 = { };
          ipv6Ra = {
            tenant-provider-handoff-a = {
              enabled = false;
            };
          };
        };
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "clab-provider-handoff-access-a";
          site = "site-b";
        };
        platform = "linux";
        ports = {
          p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-provider-handoff-access-a-p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a";
          };
          p2p-clab-downstream-selector-clab-provider-handoff-access-a = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-provider-handoff-access-a-p2p-clab-downstream-selector-clab-provider-handoff-access-a";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-downstream-selector-clab-provider-handoff-access-a";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-clab-downstream-selector-clab-provider-handoff-access-a";
          };
        };
        services = {
          pppoe = {
            server = {
              credentials = {
                labOnly = true;
                passwordFile = "/run/secrets/hat-pppoe-password";
                usernameFile = "/run/secrets/hat-pppoe-username";
              };
              customerAddress = "203.0.113.4";
              implementation = "rp-pppoe";
              interface = "p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a";
              maxSessions = 32;
              mtu = 1492;
              providerAddress = "203.0.113.5";
            };
          };
        };
      };
      esp0xdeadbeef-site-b-clab-provider-handoff-access-b = {
        advertisements = {
          dhcp4 = {
            tenant-provider-handoff-b = {
              enabled = false;
            };
          };
          dhcpv6 = { };
          ipv6Ra = {
            tenant-provider-handoff-b = {
              enabled = false;
            };
          };
        };
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "clab-provider-handoff-access-b";
          site = "site-b";
        };
        platform = "linux";
        ports = {
          p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-provider-handoff-access-b-p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b";
          };
          p2p-clab-downstream-selector-clab-provider-handoff-access-b = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-provider-handoff-access-b-p2p-clab-downstream-selector-clab-provider-handoff-access-b";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-downstream-selector-clab-provider-handoff-access-b";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-clab-downstream-selector-clab-provider-handoff-access-b";
          };
        };
        services = {
          pppoe = {
            server = {
              credentials = {
                labOnly = true;
                passwordFile = "/run/secrets/hat-pppoe-password";
                usernameFile = "/run/secrets/hat-pppoe-username";
              };
              customerAddress = "203.0.113.2";
              implementation = "rp-pppoe";
              interface = "p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b";
              maxSessions = 32;
              mtu = 1492;
              providerAddress = "203.0.113.1";
            };
          };
        };
      };
      esp0xdeadbeef-site-b-clab-upstream-selector = {
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "clab-upstream-selector";
          site = "site-b";
        };
        platform = "linux";
        ports = {
          p2p-clab-core-commercial-vpn-clab-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-core-commercial-vpn-clab-upstream-selector";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-core-commercial-vpn-clab-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-clab-core-commercial-vpn-clab-upstream-selector";
          };
          p2p-clab-core-nebula-clab-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-core-nebula-clab-upstream-selector";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-core-nebula-clab-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-clab-core-nebula-clab-upstream-selector";
          };
          p2p-clab-core-route-import-clab-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-core-route-import-clab-upstream-selector";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-core-route-import-clab-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens22";
            };
            link = "p2p-clab-core-route-import-clab-upstream-selector";
          };
          p2p-clab-core-testnet-host-isp-clab-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-core-testnet-host-isp-clab-upstream-selector";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-core-testnet-host-isp-clab-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens23";
            };
            link = "p2p-clab-core-testnet-host-isp-clab-upstream-selector";
          };
          p2p-clab-core-testnet-routed-isp-clab-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-core-testnet-routed-isp-clab-upstream-selector";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-core-testnet-routed-isp-clab-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens24";
            };
            link = "p2p-clab-core-testnet-routed-isp-clab-upstream-selector";
          };
          p2p-clab-core-upstream-vlan4-clab-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-core-upstream-vlan4-clab-upstream-selector";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-core-upstream-vlan4-clab-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens25";
            };
            link = "p2p-clab-core-upstream-vlan4-clab-upstream-selector";
          };
          p2p-clab-core-wireguard-host128-clab-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-core-wireguard-host128-clab-upstream-selector";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-core-wireguard-host128-clab-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens26";
            };
            link = "p2p-clab-core-wireguard-host128-clab-upstream-selector";
          };
          p2p-clab-core-wireguard-remote-egress-clab-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-core-wireguard-remote-egress-clab-upstream-selector";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-core-wireguard-remote-egress-clab-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens27";
            };
            link = "p2p-clab-core-wireguard-remote-egress-clab-upstream-selector";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-host-isp = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-host-isp";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-host-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens28";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-host-isp";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-routed-isp = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-routed-isp";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-routed-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens29";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-routed-isp";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-access-guest--uplink-isp-a = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-policy-clab-upstream-selector--access-clab-access-guest--uplink-isp-a";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-guest--uplink-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "ens30";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-access-guest--uplink-isp-a";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-nebula-egress = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-nebula-egress";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-nebula-egress";
              kind = "bridge";
            };
            interface = {
              name = "ens31";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-nebula-egress";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-wireguard-egress = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-wireguard-egress";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-wireguard-egress";
              kind = "bridge";
            };
            interface = {
              name = "ens32";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-wireguard-egress";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-access-work--uplink-isp-a = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-policy-clab-upstream-selector--access-clab-access-work--uplink-isp-a";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-work--uplink-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "ens33";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-access-work--uplink-isp-a";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-isp-a = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-isp-a";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "ens34";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-isp-a";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-a = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-a";
            attach = {
              bridge = "stub-clab-br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "ens35";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-a";
          };
        };
      };
    };
  };
}
