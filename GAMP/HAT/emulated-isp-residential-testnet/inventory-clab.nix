# Standalone HAT inventory with explicit realization data.
let
  protectedPppoeCredentialBindings = import ./protected-pppoe-credential-bindings.nix {
    consumerNode = "esp0xdeadbeef-site-b-clab-core-testnet-host-isp";
    harness = "s-router-clab";
    site = "clab";
  };
  overlayVpnRuntimeAdapters = import ./overlay-vpn-runtime-adapters.nix;
  selectorFabricLinkRealization = import ./selector-fabric-link-realization.nix;
  satCompat = import ./sat-compat.nix;
  satInventory = satCompat.inventory (import ../../SAT/inventory.nix);
  withSatEspRuntimeTargets =
    inventory:
    let
      satNodes = satCompat.realizationNodes satInventory;
      hostsWithSat = satCompat.mergeHostSets satInventory.deployment.hosts inventory.deployment.hosts;
      hostsWithUplinks = satCompat.withRealizationHostUplinks hostsWithSat satNodes;
    in
    inventory
    // {
      controlPlane = satCompat.recursiveMerge (satInventory.controlPlane or { }) (inventory.controlPlane or { });
      deployment = inventory.deployment // {
        hosts = satCompat.withRealizationHostBridges hostsWithUplinks satNodes;
      };
      endpoints = (satInventory.endpoints or { }) // (inventory.endpoints or { });
      operationalPrivacyContracts = satInventory.operationalPrivacyContracts;
      failureHandlingContracts = satInventory.failureHandlingContracts;
      failureDiagnosticContracts = satInventory.failureDiagnosticContracts;
      realization = inventory.realization // {
        fabricLinks = (satInventory.realization.fabricLinks or { }) // (inventory.realization.fabricLinks or { });
        nodes = satNodes // inventory.realization.nodes;
      };
    };
in
withSatEspRuntimeTargets (selectorFabricLinkRealization {
  inherit (protectedPppoeCredentialBindings) secretDeclarations secretSources sourceBindings;
  commonBehaviorSourceBinding = import ./common-behavior-source-binding.nix {
    inventoryPath = "GAMP/HAT/emulated-isp-residential-testnet/inventory-clab.nix";
    profile = "clab";
  };

  controlPlane = {
    sites.esp0xdeadbeef = {
      site-a = {
        overlays = overlayVpnRuntimeAdapters.site-a;
        uplinks.isp-b.egress = {
          mode = "bgp";
          bgp = {
            peerAsn = 65530;
            peerAddr4 = "198.51.100.1";
            peerAddr6 = "2001:db8:51::1";
          };
        };
      };
      site-b = {
        overlays = overlayVpnRuntimeAdapters.site-b;
        uplinks.isp-b.egress = {
          mode = "bgp";
          bgp = {
            peerAsn = 65530;
            peerAddr4 = "198.51.100.1";
            peerAddr6 = "2001:db8:51::1";
          };
        };
      };
    };
  };

  deployment = {
    hosts = {
      s-router-clab = {
        bridgeNetworks = {
          br-c-pppoe = {
            hatPurpose = "residential-pppoe-handoff";
            isolated = true;
          };
          provider-handoff-a = { };
          provider-handoff-b = { };
          br-site-b-p2p-clab-access-client-clab-downstream-selector = { };
          br-site-b-p2p-clab-access-dmz-clab-downstream-selector = { };
          br-site-b-p2p-clab-access-guest-clab-downstream-selector = { };
          br-site-b-p2p-clab-access-iot-clab-downstream-selector = { };
          br-site-b-p2p-clab-access-management-clab-downstream-selector = { };
          br-site-b-p2p-clab-access-trusted-clab-downstream-selector = { };
          br-site-b-p2p-clab-access-work-clab-downstream-selector = { };
          br-site-b-p2p-clab-core-commercial-vpn-clab-upstream-selector = { };
          br-site-b-p2p-clab-core-nebula-clab-upstream-selector = { };
          br-site-b-p2p-clab-core-route-import-clab-upstream-selector = { };
          br-site-b-p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a = { };
          br-site-b-p2p-clab-core-testnet-host-isp-clab-upstream-selector = { };
          br-site-b-p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b = { };
          br-site-b-p2p-clab-core-testnet-routed-isp-clab-upstream-selector = { };
          br-site-b-p2p-clab-core-bgp-uplink-isp-b-clab-upstream-selector = { };
          br-site-b-p2p-clab-core-upstream-vlan4-clab-upstream-selector = { };
          br-site-b-p2p-clab-core-wireguard-host128-clab-upstream-selector = { };
          br-site-b-p2p-clab-core-wireguard-remote-egress-clab-upstream-selector = { };
          br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-client = { };
          br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-dmz = { };
          br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-guest = { };
          br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-iot = { };
          br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-management = { };
          br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-trusted = { };
          br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-work = { };
          br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-a = { };
          br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-b = { };
          br-site-b-p2p-clab-downstream-selector-clab-provider-handoff-access-a = { };
          br-site-b-p2p-clab-downstream-selector-clab-provider-handoff-access-b = { };
          br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-host-isp =
            { };
          br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-routed-isp =
            { };
          br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-guest--uplink-isp-a = { };
          br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-nebula-egress =
            { };
          br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-wireguard-egress =
            { };
          br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-work--uplink-isp-a = { };
          br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-isp-a =
            { };
          br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-a =
            { };
          br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-guest--uplink-isp-b = { };
          br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-work--uplink-isp-b = { };
          br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-isp-b =
            { };
          br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-b =
            { };
          br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-management--uplink-testnet-host-isp =
            { };
          br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-management--uplink-testnet-routed-isp =
            { };
          br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-testnet-host-isp =
            { };
          br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-testnet-routed-isp =
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
          emulationSubnets = [
            {
              subnet = "10.11.0.0/24";
              vlan = 4;
              description = "upstream-vlan4 WAN (DHCP from host VLAN4)";
              hatOnly = true;
              labScope = "s-router-hat";
            }
          ];
          endpointClients = {
            clab-client01 = {
              assignment = "dhcp";
              managementBoundary = {
                fixturePlacementCreatesManagementAccess = false;
                mode = "no-general-management";
              };
              owningSubstrate = "clab";
              persistenceExpectation = {
                kind = "ephemeral-fixture";
                required = false;
              };
              required = true;
              status = "missing-live-evidence";
              tenant = "client";
            };
            clab-client02 = {
              assignment = "dhcp";
              managementBoundary = {
                fixturePlacementCreatesManagementAccess = false;
                mode = "no-general-management";
              };
              owningSubstrate = "clab";
              persistenceExpectation = {
                kind = "ephemeral-fixture";
                required = false;
              };
              required = true;
              status = "missing-live-evidence";
              tenant = "client";
            };
            clab-emulated-sigma = {
              addressDelivery = "endpoint-configured";
              assignment = "static-ipv4-or-ipv6-client";
              gateway4 = "10.50.10.1";
              gateway6 = "fd42:dead:feed:10::1";
              ipv4 = [ "10.50.10.50/24" ];
              ipv6 = [ "fd42:dead:feed:10::50/64" ];
              managementBoundary = {
                fixturePlacementCreatesManagementAccess = false;
                mode = "no-general-management";
              };
              owningSubstrate = "clab";
              persistenceExpectation = {
                kind = "ephemeral-fixture";
                required = false;
              };
              required = true;
              status = "missing-live-evidence";
              tenant = "mgmt";
            };
          };
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
              harness = "s-router-clab";
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
                endpoint = "clab-core-testnet-host-isp";
                mode = "endpoint-specific";
                technology = "pppoe";
              };
              credentials = {
                labOnly = true;
                passwordFile = "hat-pppoe-password";
                usernameFile = "hat-pppoe-username";
              };
              gampId = "FS-800-HDS-010-SDS-010-SMS-010";
              handoff = "pppoe";
              harness = "s-router-clab";
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
          requiredEndpointClients = [
            "clab-client01"
            "clab-client02"
            "clab-emulated-sigma"
          ];
        };
        uplinks = {
          commercial-vpn = {
            bridge = "br-clab-uplink-commercial-vpn";
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
            bridge = "br-clab-uplink-nebula-egress";
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
            bridge = "br-clab-uplink-route-import";
            ipv4 = {
              method = "none";
            };
            ipv6 = {
              method = "none";
            };
            parent = "hat-route-import";
            upstream = "route-import";
          };
          isp-a = {
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
          };
          isp-b = {
            bridge = "br-uplink-bgp";
            ipv4 = {
              address = "198.51.100.2/24";
              method = "static";
            };
            ipv6 = {
              address = "2001:db8:51::2/64";
              method = "static";
            };
            parent = "eth0";
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
            bridge = "br-clab-uplink-wireguard-egress";
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
            bridge = "br-clab-uplink-wireguard-host128";
            ipv4 = {
              method = "none";
            };
            ipv6 = {
              address = "2001:db8:128::2/128";
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
          "esp0xdeadbeef::site-a::nixos-core-upstream-vlan4" = "isp-a";
          "esp0xdeadbeef::site-a::nixos-core-wireguard-host128" = "wireguard-host128";
          "esp0xdeadbeef::site-a::nixos-core-wireguard-remote-egress" = "wireguard-egress";
          "esp0xdeadbeef::site-b::clab-core-commercial-vpn" = "commercial-vpn";
          "esp0xdeadbeef::site-b::clab-core-nebula" = "nebula-egress";
          "esp0xdeadbeef::site-b::clab-core-route-import" = "route-import";
          "esp0xdeadbeef::site-b::clab-core-testnet-host-isp" = "uplink-testnet-host-isp";
          "esp0xdeadbeef::site-b::clab-core-testnet-routed-isp" = "uplink-testnet-routed-isp";
          "esp0xdeadbeef::site-b::clab-core-bgp-uplink-isp-b" = "isp-b";
          "esp0xdeadbeef::site-b::clab-core-upstream-vlan4" = "isp-a";
          "esp0xdeadbeef::site-b::clab-core-wireguard-host128" = "wireguard-host128";
          "esp0xdeadbeef::site-b::clab-core-wireguard-remote-egress" = "wireguard-egress";
        };
      };
      s-router-nixos = {
        bridgeNetworks = {
          stub-nixos-br-site-a-p2p-nixos-access-client-nixos-downstream-selector = { };
          stub-nixos-br-site-a-p2p-nixos-access-dmz-nixos-downstream-selector = { };
          stub-nixos-br-site-a-p2p-nixos-access-guest-nixos-downstream-selector = { };
          stub-nixos-br-site-a-p2p-nixos-access-iot-nixos-downstream-selector = { };
          stub-nixos-br-site-a-p2p-nixos-access-management-nixos-downstream-selector = { };
          stub-nixos-br-site-a-p2p-nixos-access-trusted-nixos-downstream-selector = { };
          stub-nixos-br-site-a-p2p-nixos-access-work-nixos-downstream-selector = { };
          stub-nixos-br-site-a-p2p-nixos-core-commercial-vpn-nixos-upstream-selector = { };
          stub-nixos-br-site-a-p2p-nixos-core-nebula-nixos-upstream-selector = { };
          stub-nixos-br-site-a-p2p-nixos-core-route-import-nixos-upstream-selector = { };
          stub-nixos-br-site-a-p2p-nixos-core-testnet-host-isp-nixos-upstream-selector = { };
          stub-nixos-br-site-a-p2p-nixos-core-testnet-routed-isp-nixos-upstream-selector = { };
          stub-nixos-br-site-a-p2p-nixos-core-bgp-uplink-isp-b-nixos-upstream-selector = { };
          stub-nixos-br-site-a-p2p-nixos-core-upstream-vlan4-nixos-upstream-selector = { };
          stub-nixos-br-site-a-p2p-nixos-core-wireguard-host128-nixos-upstream-selector = { };
          stub-nixos-br-site-a-p2p-nixos-core-wireguard-remote-egress-nixos-upstream-selector = { };
          stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-client = { };
          stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-dmz = { };
          stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-guest = { };
          stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-iot = { };
          stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-management =
            { };
          stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-trusted = { };
          stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-work = { };
          stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-a =
            { };
          stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-b =
            { };
          stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-provider-handoff-access-a = { };
          stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-provider-handoff-access-b = { };
          stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-host-isp =
            { };
          stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-routed-isp =
            { };
          stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-guest--uplink-isp-a =
            { };
          stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-nebula-egress =
            { };
          stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-wireguard-egress =
            { };
          stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-work--uplink-isp-a =
            { };
          stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-isp-a =
            { };
          stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-a =
            { };
          stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-guest--uplink-isp-b = { };
          stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-work--uplink-isp-b = { };
          stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-isp-b =
            { };
          stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-b =
            { };
          stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-management--uplink-testnet-host-isp =
            { };
          stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-management--uplink-testnet-routed-isp =
            { };
          stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-testnet-host-isp =
            { };
          stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-testnet-routed-isp =
            { };
          stub-nixos-client = { };
          stub-nixos-dmz = { };
          stub-nixos-guest = { };
          stub-nixos-iot = { };
          stub-nixos-mgmt = { };
          stub-nixos-trusted = { };
          stub-nixos-work = { };
        };
        uplinks = {
          commercial-vpn = {
            bridge = "stub-nixos-br-clab-uplink-commercial-vpn";
            ipv4 = {
              method = "none";
            };
            ipv6 = {
              method = "none";
            };
            parent = "hat-commercial-vpn";
            upstream = "commercial-vpn";
          };
          nebula-egress = {
            bridge = "stub-nixos-br-clab-uplink-nebula-egress";
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
            bridge = "stub-nixos-br-clab-uplink-route-import";
            ipv4 = {
              method = "none";
            };
            ipv6 = {
              method = "none";
            };
            parent = "hat-route-import";
            upstream = "route-import";
          };
          isp-a = {
            bridge = "stub-nixos-br-uplink0";
            ipv4 = {
              dhcp = true;
              method = "dhcp";
            };
            ipv6 = {
              acceptRA = true;
              method = "slaac";
            };
            parent = "eth0";
          };
          isp-b = {
            bridge = "stub-nixos-br-uplink-bgp";
            ipv4 = {
              address = "198.51.100.2/24";
              method = "static";
            };
            ipv6 = {
              address = "2001:db8:51::2/64";
              method = "static";
            };
            parent = "eth0";
          };
          uplink-testnet-host-isp = {
            bridge = "stub-nixos-br-t-host";
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
            bridge = "stub-nixos-br-t-routed";
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
            bridge = "stub-nixos-br-clab-uplink-wireguard-egress";
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
            bridge = "stub-nixos-br-clab-uplink-wireguard-host128";
            ipv4 = {
              method = "none";
            };
            ipv6 = {
              address = "2001:db8:128::2/128";
              method = "static";
            };
            parent = "hat-wireguard-host128";
            upstream = "wireguard-host128";
          };
        };
        wanGroupToUplink = {
          "esp0xdeadbeef::site-a::nixos-core-bgp-uplink-isp-b" = "isp-b";
          "esp0xdeadbeef::site-a::nixos-core-commercial-vpn" = "commercial-vpn";
          "esp0xdeadbeef::site-a::nixos-core-nebula" = "nebula-egress";
          "esp0xdeadbeef::site-a::nixos-core-route-import" = "route-import";
          "esp0xdeadbeef::site-a::nixos-core-testnet-host-isp" = "uplink-testnet-host-isp";
          "esp0xdeadbeef::site-a::nixos-core-testnet-routed-isp" = "uplink-testnet-routed-isp";
          "esp0xdeadbeef::site-a::nixos-core-upstream-vlan4" = "isp-a";
          "esp0xdeadbeef::site-a::nixos-core-wireguard-host128" = "wireguard-host128";
          "esp0xdeadbeef::site-a::nixos-core-wireguard-remote-egress" = "wireguard-egress";
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
              namespaceContract = {
                namespaceOwner = "tenant-client";
                requesterScope = "tenant-client";
                recordClass = "dhcp4-lease-name";
                conflictBehavior = "fail-closed";
                staleRecordBehavior = "fail-closed-deny-answer";
                fallbackBehavior = "blocked-no-public-recursion";
                deniedClasses = [
                  "recursive-dns-authority"
                  "payload-reachability"
                  "management-reachability"
                  "public-egress"
                ];
                leaseRevocationBehavior = "remove-lease-name-on-client-revocation";
              };
            };
          };
          ipv6Ra = {
            tenant-client = {
              dnssl = [ "lan." ];
              rdnss = [ "router-self" ];
            };
          };
        };
        services.dns = { };
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-access-client-nixos-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-nixos-access-client-nixos-downstream-selector";
          };
          tenant-client = {
            attach = {
              bridge = "stub-nixos-client";
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
          dhcp4.tenant-dmz.dnsServers = [ "router-self" ];
          dhcp4.tenant-dmz.domain = "lan.";
          dhcpv6 = { };
          ipv6Ra.tenant-dmz.dnssl = [ "lan." ];
          ipv6Ra.tenant-dmz.rdnss = [ "router-self" ];
        };
        services.dns = { };
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-access-dmz-nixos-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-nixos-access-dmz-nixos-downstream-selector";
          };
          tenant-dmz = {
            attach = {
              bridge = "stub-nixos-dmz";
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
          dhcp4.tenant-guest.dnsServers = [ "router-self" ];
          dhcp4.tenant-guest.domain = "lan.";
          dhcpv6 = { };
          ipv6Ra.tenant-guest.dnssl = [ "lan." ];
          ipv6Ra.tenant-guest.rdnss = [ "router-self" ];
        };
        services.dns = { };
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-access-guest-nixos-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-nixos-access-guest-nixos-downstream-selector";
          };
          tenant-guest = {
            attach = {
              bridge = "stub-nixos-guest";
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
          dhcp4.tenant-iot.dnsServers = [ "router-self" ];
          dhcp4.tenant-iot.domain = "lan.";
          dhcpv6 = { };
          ipv6Ra.tenant-iot.dnssl = [ "lan." ];
          ipv6Ra.tenant-iot.rdnss = [ "router-self" ];
        };
        services.dns = { };
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "nixos-access-iot";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          p2p-nixos-access-iot-nixos-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-access-iot-p2p-nixos-access-iot-nixos-downstream-selector";
            attach = {
              bridge = "stub-nixos-br-site-a-p2p-nixos-access-iot-nixos-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens23";
            };
            link = "p2p-nixos-access-iot-nixos-downstream-selector";
          };
          tenant-iot = {
            attach = {
              bridge = "stub-nixos-iot";
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
          dhcp4.tenant-management.dnsServers = [ "router-self" ];
          dhcp4.tenant-management.domain = "lan.";
          dhcpv6 = { };
          ipv6Ra.tenant-management.dnssl = [ "lan." ];
          ipv6Ra.tenant-management.rdnss = [ "router-self" ];
        };
        services.dns = { };
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-access-management-nixos-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-nixos-access-management-nixos-downstream-selector";
          };
          tenant-management = {
            attach = {
              bridge = "stub-nixos-mgmt";
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
          dhcp4.tenant-trusted.dnsServers = [ "router-self" ];
          dhcp4.tenant-trusted.domain = "lan.";
          dhcpv6 = { };
          ipv6Ra.tenant-trusted.dnssl = [ "lan." ];
          ipv6Ra.tenant-trusted.rdnss = [ "router-self" ];
        };
        services.dns = { };
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-access-trusted-nixos-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-nixos-access-trusted-nixos-downstream-selector";
          };
          tenant-trusted = {
            attach = {
              bridge = "stub-nixos-trusted";
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
          dhcp4.tenant-work.dnsServers = [ "router-self" ];
          dhcp4.tenant-work.domain = "lan.";
          dhcpv6 = { };
          ipv6Ra.tenant-work.dnssl = [ "lan." ];
          ipv6Ra.tenant-work.rdnss = [ "router-self" ];
        };
        services.dns = { };
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-access-work-nixos-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-nixos-access-work-nixos-downstream-selector";
          };
          tenant-work = {
            attach = {
              bridge = "stub-nixos-work";
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
              bridge = "stub-nixos-br-clab-uplink-commercial-vpn";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-core-commercial-vpn-nixos-upstream-selector";
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
              bridge = "stub-nixos-br-clab-uplink-nebula-egress";
              kind = "bridge";
            };
            external = true;
            interface = {
              name = "ens80";
            };
            uplink = "nebula-egress";
          };
          p2p-nixos-core-nebula-nixos-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-core-nebula-p2p-nixos-core-nebula-nixos-upstream-selector";
            attach = {
              bridge = "stub-nixos-br-site-a-p2p-nixos-core-nebula-nixos-upstream-selector";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-core-route-import-nixos-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-nixos-core-route-import-nixos-upstream-selector";
          };
          route-import = {
            attach = {
              bridge = "stub-nixos-br-clab-uplink-route-import";
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
          p2p-nixos-core-testnet-host-isp-nixos-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-core-testnet-host-isp-p2p-nixos-core-testnet-host-isp-nixos-upstream-selector";
            attach = {
              bridge = "stub-nixos-br-site-a-p2p-nixos-core-testnet-host-isp-nixos-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-nixos-core-testnet-host-isp-nixos-upstream-selector";
          };
          testnet-host-isp = {
            attach = {
              bridge = "stub-nixos-br-t-host";
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
              implementation = "rp-pppoe";
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
          p2p-nixos-core-testnet-routed-isp-nixos-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-core-testnet-routed-isp-p2p-nixos-core-testnet-routed-isp-nixos-upstream-selector";
            attach = {
              bridge = "stub-nixos-br-site-a-p2p-nixos-core-testnet-routed-isp-nixos-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-nixos-core-testnet-routed-isp-nixos-upstream-selector";
          };
          testnet-routed-isp = {
            attach = {
              bridge = "stub-nixos-br-t-routed";
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
              implementation = "rp-pppoe";
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
              bridge = "stub-nixos-br-uplink0";
              kind = "bridge";
              parentUplink = "isp-a";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-core-upstream-vlan4-nixos-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-nixos-core-upstream-vlan4-nixos-upstream-selector";
          };
        };
      };
      esp0xdeadbeef-site-a-nixos-core-bgp-uplink-isp-b = {
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "nixos-core-bgp-uplink-isp-b";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          isp-b = {
            attach = {
              bridge = "stub-nixos-br-uplink-bgp";
              kind = "bridge";
              parentUplink = "isp-b";
            };
            external = true;
            interface = {
              name = "ens81";
            };
            uplink = "isp-b";
          };
          p2p-nixos-core-bgp-uplink-isp-b-nixos-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-core-bgp-uplink-isp-b-p2p-nixos-core-bgp-uplink-isp-b-nixos-upstream-selector";
            attach = {
              bridge = "stub-nixos-br-site-a-p2p-nixos-core-bgp-uplink-isp-b-nixos-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens82";
            };
            link = "p2p-nixos-core-bgp-uplink-isp-b-nixos-upstream-selector";
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
          p2p-nixos-core-wireguard-host128-nixos-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-core-wireguard-host128-p2p-nixos-core-wireguard-host128-nixos-upstream-selector";
            attach = {
              bridge = "stub-nixos-br-site-a-p2p-nixos-core-wireguard-host128-nixos-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-nixos-core-wireguard-host128-nixos-upstream-selector";
          };
          wireguard-host128 = {
            attach = {
              bridge = "stub-nixos-br-clab-uplink-wireguard-host128";
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
          p2p-nixos-core-wireguard-remote-egress-nixos-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-core-wireguard-remote-egress-p2p-nixos-core-wireguard-remote-egress-nixos-upstream-selector";
            attach = {
              bridge = "stub-nixos-br-site-a-p2p-nixos-core-wireguard-remote-egress-nixos-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-nixos-core-wireguard-remote-egress-nixos-upstream-selector";
          };
          wireguard-egress = {
            attach = {
              bridge = "stub-nixos-br-clab-uplink-wireguard-egress";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-access-client-nixos-downstream-selector";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-access-dmz-nixos-downstream-selector";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-access-guest-nixos-downstream-selector";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-access-iot-nixos-downstream-selector";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-access-management-nixos-downstream-selector";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-access-trusted-nixos-downstream-selector";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-access-work-nixos-downstream-selector";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-client";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-dmz";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-guest";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-iot";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-management";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-trusted";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-work";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-a";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-b";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-provider-handoff-access-a";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-provider-handoff-access-b";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-client";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-dmz";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-guest";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-iot";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-management";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-trusted";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-access-work";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-a";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-policy--access-nixos-provider-handoff-access-b";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-host-isp";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-routed-isp";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-guest--uplink-isp-a";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-nebula-egress";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-wireguard-egress";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-work--uplink-isp-a";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-isp-a";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "ens36";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-a";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-management--uplink-testnet-host-isp = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-management--uplink-testnet-host-isp";
            attach = {
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-management--uplink-testnet-host-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens37";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-management--uplink-testnet-host-isp";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-management--uplink-testnet-routed-isp = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-management--uplink-testnet-routed-isp";
            attach = {
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-management--uplink-testnet-routed-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens38";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-management--uplink-testnet-routed-isp";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-testnet-host-isp = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-testnet-host-isp";
            attach = {
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-testnet-host-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens39";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-testnet-host-isp";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-testnet-routed-isp = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-testnet-routed-isp";
            attach = {
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-testnet-routed-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens40";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-testnet-routed-isp";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-guest--uplink-isp-b = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-guest--uplink-isp-b";
            attach = {
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-guest--uplink-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "ens41";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-guest--uplink-isp-b";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-work--uplink-isp-b = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-work--uplink-isp-b";
            attach = {
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-work--uplink-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "ens42";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-work--uplink-isp-b";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-isp-b = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-isp-b";
            attach = {
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "ens43";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-isp-b";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-b = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-policy-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-b";
            attach = {
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "ens44";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-b";
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
        services.dns = { };
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "nixos-provider-handoff-access-a";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          p2p-nixos-downstream-selector-nixos-provider-handoff-access-a = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-provider-handoff-access-a-p2p-nixos-downstream-selector-nixos-provider-handoff-access-a";
            attach = {
              bridge = "stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-provider-handoff-access-a";
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
        services.dns = { };
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "nixos-provider-handoff-access-b";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          p2p-nixos-downstream-selector-nixos-provider-handoff-access-b = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-provider-handoff-access-b-p2p-nixos-downstream-selector-nixos-provider-handoff-access-b";
            attach = {
              bridge = "stub-nixos-br-site-a-p2p-nixos-downstream-selector-nixos-provider-handoff-access-b";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-core-commercial-vpn-nixos-upstream-selector";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-core-nebula-nixos-upstream-selector";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-core-route-import-nixos-upstream-selector";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-core-testnet-host-isp-nixos-upstream-selector";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-core-testnet-routed-isp-nixos-upstream-selector";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-core-upstream-vlan4-nixos-upstream-selector";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-core-wireguard-host128-nixos-upstream-selector";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-core-wireguard-remote-egress-nixos-upstream-selector";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-host-isp";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-client--uplink-testnet-routed-isp";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-guest--uplink-isp-a";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-nebula-egress";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-iot--uplink-wireguard-egress";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-work--uplink-isp-a";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-isp-a";
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
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "ens35";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-a";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-management--uplink-testnet-host-isp = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-management--uplink-testnet-host-isp";
            attach = {
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-management--uplink-testnet-host-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens36";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-management--uplink-testnet-host-isp";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-management--uplink-testnet-routed-isp = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-management--uplink-testnet-routed-isp";
            attach = {
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-management--uplink-testnet-routed-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens37";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-management--uplink-testnet-routed-isp";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-testnet-host-isp = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-testnet-host-isp";
            attach = {
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-testnet-host-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens38";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-testnet-host-isp";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-testnet-routed-isp = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-testnet-routed-isp";
            attach = {
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-testnet-routed-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens39";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-testnet-routed-isp";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-guest--uplink-isp-b = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-guest--uplink-isp-b";
            attach = {
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-guest--uplink-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "ens40";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-guest--uplink-isp-b";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-work--uplink-isp-b = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-work--uplink-isp-b";
            attach = {
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-work--uplink-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "ens41";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-access-work--uplink-isp-b";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-isp-b = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-isp-b";
            attach = {
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "ens42";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-a--uplink-isp-b";
          };
          p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-b = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-b";
            attach = {
              bridge = "stub-nixos-br-site-a-p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "ens43";
            };
            link = "p2p-nixos-policy-nixos-upstream-selector--access-nixos-provider-handoff-access-b--uplink-isp-b";
          };
          p2p-nixos-core-bgp-uplink-isp-b-nixos-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-nixos-upstream-selector-p2p-nixos-core-bgp-uplink-isp-b-nixos-upstream-selector";
            attach = {
              bridge = "stub-nixos-br-site-a-p2p-nixos-core-bgp-uplink-isp-b-nixos-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens45";
            };
            link = "p2p-nixos-core-bgp-uplink-isp-b-nixos-upstream-selector";
          };
        };
      };
      esp0xdeadbeef-site-b-clab-access-client = {
        advertisements = {
          dhcp4 = {
            tenant-client = {
              dnsServers = [ "router-self" ];
              domain = "lan.";
              namespaceContract = {
                namespaceOwner = "tenant-client";
                requesterScope = "tenant-client";
                recordClass = "dhcp4-lease-name";
                conflictBehavior = "fail-closed";
                staleRecordBehavior = "fail-closed-deny-answer";
                fallbackBehavior = "blocked-no-public-recursion";
                deniedClasses = [
                  "recursive-dns-authority"
                  "payload-reachability"
                  "management-reachability"
                  "public-egress"
                ];
                leaseRevocationBehavior = "remove-lease-name-on-client-revocation";
              };
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
        services.dns = { };
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
              bridge = "br-site-b-p2p-clab-access-client-clab-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-clab-access-client-clab-downstream-selector";
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
      esp0xdeadbeef-site-b-clab-access-dmz = {
        advertisements = {
          dhcp4.tenant-dmz.dnsServers = [ "router-self" ];
          dhcp4.tenant-dmz.domain = "lan.";
          dhcpv6 = { };
          ipv6Ra.tenant-dmz.dnssl = [ "lan." ];
          ipv6Ra.tenant-dmz.rdnss = [ "router-self" ];
        };
        services.dns = { };
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
              bridge = "br-site-b-p2p-clab-access-dmz-clab-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-clab-access-dmz-clab-downstream-selector";
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
      esp0xdeadbeef-site-b-clab-access-guest = {
        advertisements = {
          dhcp4.tenant-guest.dnsServers = [ "router-self" ];
          dhcp4.tenant-guest.domain = "lan.";
          dhcpv6 = { };
          ipv6Ra.tenant-guest.dnssl = [ "lan." ];
          ipv6Ra.tenant-guest.rdnss = [ "router-self" ];
        };
        services.dns = { };
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
              bridge = "br-site-b-p2p-clab-access-guest-clab-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-clab-access-guest-clab-downstream-selector";
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
      esp0xdeadbeef-site-b-clab-access-iot = {
        advertisements = {
          dhcp4.tenant-iot.dnsServers = [ "router-self" ];
          dhcp4.tenant-iot.domain = "lan.";
          dhcpv6 = { };
          ipv6Ra.tenant-iot.dnssl = [ "lan." ];
          ipv6Ra.tenant-iot.rdnss = [ "router-self" ];
        };
        services.dns = { };
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "clab-access-iot";
          site = "site-b";
        };
        platform = "linux";
        ports = {
          p2p-clab-access-iot-clab-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-access-iot-p2p-clab-access-iot-clab-downstream-selector";
            attach = {
              bridge = "br-site-b-p2p-clab-access-iot-clab-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens23";
            };
            link = "p2p-clab-access-iot-clab-downstream-selector";
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
      esp0xdeadbeef-site-b-clab-access-management = {
        advertisements = {
          dhcp4.tenant-management.dnsServers = [ "router-self" ];
          dhcp4.tenant-management.domain = "lan.";
          dhcpv6 = { };
          ipv6Ra.tenant-management.dnssl = [ "lan." ];
          ipv6Ra.tenant-management.rdnss = [ "router-self" ];
        };
        services.dns = { };
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
              bridge = "br-site-b-p2p-clab-access-management-clab-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-clab-access-management-clab-downstream-selector";
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
      esp0xdeadbeef-site-b-clab-access-trusted = {
        advertisements = {
          dhcp4.tenant-trusted.dnsServers = [ "router-self" ];
          dhcp4.tenant-trusted.domain = "lan.";
          dhcpv6 = { };
          ipv6Ra.tenant-trusted.dnssl = [ "lan." ];
          ipv6Ra.tenant-trusted.rdnss = [ "router-self" ];
        };
        services.dns = { };
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
              bridge = "br-site-b-p2p-clab-access-trusted-clab-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-clab-access-trusted-clab-downstream-selector";
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
      esp0xdeadbeef-site-b-clab-access-work = {
        advertisements = {
          dhcp4.tenant-work.dnsServers = [ "router-self" ];
          dhcp4.tenant-work.domain = "lan.";
          dhcpv6 = { };
          ipv6Ra.tenant-work.dnssl = [ "lan." ];
          ipv6Ra.tenant-work.rdnss = [ "router-self" ];
        };
        services.dns = { };
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
              bridge = "br-site-b-p2p-clab-access-work-clab-downstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-clab-access-work-clab-downstream-selector";
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
              bridge = "br-clab-uplink-commercial-vpn";
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
              bridge = "br-site-b-p2p-clab-core-commercial-vpn-clab-upstream-selector";
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
              bridge = "br-clab-uplink-nebula-egress";
              kind = "bridge";
            };
            external = true;
            interface = {
              name = "ens80";
            };
            uplink = "nebula-egress";
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
          p2p-clab-core-nebula-clab-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-core-nebula-p2p-clab-core-nebula-clab-upstream-selector";
            attach = {
              bridge = "br-site-b-p2p-clab-core-nebula-clab-upstream-selector";
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
              bridge = "br-site-b-p2p-clab-core-route-import-clab-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-clab-core-route-import-clab-upstream-selector";
          };
          route-import = {
            attach = {
              bridge = "br-clab-uplink-route-import";
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
              bridge = "br-site-b-p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            serviceInterface = "p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a";
          };
          tenant-provider-handoff-a = {
            attach = {
              bridge = "provider-handoff-a";
              kind = "bridge";
            };
            interface = {
              name = "prov-core-a";
            };
            logicalInterface = "tenant-provider-handoff-a";
          };
          p2p-clab-core-testnet-host-isp-clab-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-core-testnet-host-isp-p2p-clab-core-testnet-host-isp-clab-upstream-selector";
            attach = {
              bridge = "br-site-b-p2p-clab-core-testnet-host-isp-clab-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-clab-core-testnet-host-isp-clab-upstream-selector";
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
              implementation = "rp-pppoe";
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
              bridge = "br-site-b-p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            serviceInterface = "p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b";
          };
          tenant-provider-handoff-b = {
            attach = {
              bridge = "provider-handoff-b";
              kind = "bridge";
            };
            interface = {
              name = "prov-core-b";
            };
            logicalInterface = "tenant-provider-handoff-b";
          };
          p2p-clab-core-testnet-routed-isp-clab-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-core-testnet-routed-isp-p2p-clab-core-testnet-routed-isp-clab-upstream-selector";
            attach = {
              bridge = "br-site-b-p2p-clab-core-testnet-routed-isp-clab-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-clab-core-testnet-routed-isp-clab-upstream-selector";
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
              implementation = "rp-pppoe";
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
              bridge = "br-uplink0";
              kind = "bridge";
              parentUplink = "isp-a";
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
              bridge = "br-site-b-p2p-clab-core-upstream-vlan4-clab-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            link = "p2p-clab-core-upstream-vlan4-clab-upstream-selector";
          };
        };
      };
      esp0xdeadbeef-site-b-clab-core-bgp-uplink-isp-b = {
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "clab-core-bgp-uplink-isp-b";
          site = "site-b";
        };
        platform = "linux";
        ports = {
          isp-b = {
            attach = {
              bridge = "br-uplink-bgp";
              kind = "bridge";
              parentUplink = "isp-b";
            };
            external = true;
            interface = {
              name = "ens81";
            };
            uplink = "isp-b";
          };
          p2p-clab-core-bgp-uplink-isp-b-clab-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-core-bgp-uplink-isp-b-p2p-clab-core-bgp-uplink-isp-b-clab-upstream-selector";
            attach = {
              bridge = "br-site-b-p2p-clab-core-bgp-uplink-isp-b-clab-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens82";
            };
            link = "p2p-clab-core-bgp-uplink-isp-b-clab-upstream-selector";
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
          p2p-clab-core-wireguard-host128-clab-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-core-wireguard-host128-p2p-clab-core-wireguard-host128-clab-upstream-selector";
            attach = {
              bridge = "br-site-b-p2p-clab-core-wireguard-host128-clab-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-clab-core-wireguard-host128-clab-upstream-selector";
          };
          wireguard-host128 = {
            attach = {
              bridge = "br-clab-uplink-wireguard-host128";
              kind = "bridge";
            };
            external = true;
            interface = {
              name = "ens80";
            };
            uplink = "wireguard-host128";
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
      esp0xdeadbeef-site-b-clab-core-wireguard-remote-egress = {
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "clab-core-wireguard-remote-egress";
          site = "site-b";
        };
        platform = "linux";
        ports = {
          p2p-clab-core-wireguard-remote-egress-clab-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-core-wireguard-remote-egress-p2p-clab-core-wireguard-remote-egress-clab-upstream-selector";
            attach = {
              bridge = "br-site-b-p2p-clab-core-wireguard-remote-egress-clab-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-clab-core-wireguard-remote-egress-clab-upstream-selector";
          };
          wireguard-egress = {
            attach = {
              bridge = "br-clab-uplink-wireguard-egress";
              kind = "bridge";
            };
            external = true;
            interface = {
              name = "ens80";
            };
            uplink = "wireguard-egress";
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
              bridge = "br-site-b-p2p-clab-access-client-clab-downstream-selector";
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
              bridge = "br-site-b-p2p-clab-access-dmz-clab-downstream-selector";
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
              bridge = "br-site-b-p2p-clab-access-guest-clab-downstream-selector";
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
              bridge = "br-site-b-p2p-clab-access-iot-clab-downstream-selector";
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
              bridge = "br-site-b-p2p-clab-access-management-clab-downstream-selector";
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
              bridge = "br-site-b-p2p-clab-access-trusted-clab-downstream-selector";
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
              bridge = "br-site-b-p2p-clab-access-work-clab-downstream-selector";
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
              bridge = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-client";
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
              bridge = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-dmz";
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
              bridge = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-guest";
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
              bridge = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-iot";
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
              bridge = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-management";
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
              bridge = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-trusted";
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
              bridge = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-work";
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
              bridge = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-a";
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
              bridge = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-b";
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
              bridge = "br-site-b-p2p-clab-downstream-selector-clab-provider-handoff-access-a";
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
              bridge = "br-site-b-p2p-clab-downstream-selector-clab-provider-handoff-access-b";
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
              bridge = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-client";
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
              bridge = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-dmz";
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
              bridge = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-guest";
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
              bridge = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-iot";
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
              bridge = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-management";
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
              bridge = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-trusted";
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
              bridge = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-access-work";
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
              bridge = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-a";
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
              bridge = "br-site-b-p2p-clab-downstream-selector-clab-policy--access-clab-provider-handoff-access-b";
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
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-host-isp";
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
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-routed-isp";
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
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-guest--uplink-isp-a";
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
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-nebula-egress";
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
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-wireguard-egress";
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
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-work--uplink-isp-a";
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
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-isp-a";
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
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "ens36";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-a";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-access-management--uplink-testnet-host-isp = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-policy-clab-upstream-selector--access-clab-access-management--uplink-testnet-host-isp";
            attach = {
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-management--uplink-testnet-host-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens37";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-access-management--uplink-testnet-host-isp";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-access-management--uplink-testnet-routed-isp = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-policy-clab-upstream-selector--access-clab-access-management--uplink-testnet-routed-isp";
            attach = {
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-management--uplink-testnet-routed-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens38";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-access-management--uplink-testnet-routed-isp";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-testnet-host-isp = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-testnet-host-isp";
            attach = {
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-testnet-host-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens39";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-testnet-host-isp";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-testnet-routed-isp = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-testnet-routed-isp";
            attach = {
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-testnet-routed-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens40";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-testnet-routed-isp";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-access-guest--uplink-isp-b = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-policy-clab-upstream-selector--access-clab-access-guest--uplink-isp-b";
            attach = {
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-guest--uplink-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "ens41";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-access-guest--uplink-isp-b";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-access-work--uplink-isp-b = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-policy-clab-upstream-selector--access-clab-access-work--uplink-isp-b";
            attach = {
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-work--uplink-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "ens42";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-access-work--uplink-isp-b";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-isp-b = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-isp-b";
            attach = {
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "ens43";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-isp-b";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-b = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-policy-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-b";
            attach = {
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "ens44";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-b";
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
        services.dns = { };
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
              bridge = "br-site-b-p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            serviceInterface = "p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a";
          };
          p2p-clab-downstream-selector-clab-provider-handoff-access-a = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-provider-handoff-access-a-p2p-clab-downstream-selector-clab-provider-handoff-access-a";
            attach = {
              bridge = "br-site-b-p2p-clab-downstream-selector-clab-provider-handoff-access-a";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-clab-downstream-selector-clab-provider-handoff-access-a";
          };
          tenant-provider-handoff-a = {
            attach = {
              bridge = "provider-handoff-a";
              kind = "bridge";
            };
            interface = {
              name = "prov-handoff-a";
            };
            logicalInterface = "tenant-provider-handoff-a";
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
        services.dns = { };
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
              bridge = "br-site-b-p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b";
              kind = "bridge";
            };
            interface = {
              name = "ens20";
            };
            serviceInterface = "p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b";
          };
          p2p-clab-downstream-selector-clab-provider-handoff-access-b = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-provider-handoff-access-b-p2p-clab-downstream-selector-clab-provider-handoff-access-b";
            attach = {
              bridge = "br-site-b-p2p-clab-downstream-selector-clab-provider-handoff-access-b";
              kind = "bridge";
            };
            interface = {
              name = "ens21";
            };
            link = "p2p-clab-downstream-selector-clab-provider-handoff-access-b";
          };
          tenant-provider-handoff-b = {
            attach = {
              bridge = "provider-handoff-b";
              kind = "bridge";
            };
            interface = {
              name = "prov-handoff-b";
            };
            logicalInterface = "tenant-provider-handoff-b";
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
              bridge = "br-site-b-p2p-clab-core-commercial-vpn-clab-upstream-selector";
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
              bridge = "br-site-b-p2p-clab-core-nebula-clab-upstream-selector";
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
              bridge = "br-site-b-p2p-clab-core-route-import-clab-upstream-selector";
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
              bridge = "br-site-b-p2p-clab-core-testnet-host-isp-clab-upstream-selector";
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
              bridge = "br-site-b-p2p-clab-core-testnet-routed-isp-clab-upstream-selector";
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
              bridge = "br-site-b-p2p-clab-core-upstream-vlan4-clab-upstream-selector";
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
              bridge = "br-site-b-p2p-clab-core-wireguard-host128-clab-upstream-selector";
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
              bridge = "br-site-b-p2p-clab-core-wireguard-remote-egress-clab-upstream-selector";
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
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-host-isp";
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
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-client--uplink-testnet-routed-isp";
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
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-guest--uplink-isp-a";
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
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-nebula-egress";
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
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-iot--uplink-wireguard-egress";
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
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-work--uplink-isp-a";
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
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-isp-a";
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
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "ens35";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-a";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-access-management--uplink-testnet-host-isp = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-policy-clab-upstream-selector--access-clab-access-management--uplink-testnet-host-isp";
            attach = {
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-management--uplink-testnet-host-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens36";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-access-management--uplink-testnet-host-isp";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-access-management--uplink-testnet-routed-isp = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-policy-clab-upstream-selector--access-clab-access-management--uplink-testnet-routed-isp";
            attach = {
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-management--uplink-testnet-routed-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens37";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-access-management--uplink-testnet-routed-isp";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-testnet-host-isp = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-testnet-host-isp";
            attach = {
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-testnet-host-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens38";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-testnet-host-isp";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-testnet-routed-isp = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-testnet-routed-isp";
            attach = {
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-testnet-routed-isp";
              kind = "bridge";
            };
            interface = {
              name = "ens39";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-testnet-routed-isp";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-access-guest--uplink-isp-b = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-policy-clab-upstream-selector--access-clab-access-guest--uplink-isp-b";
            attach = {
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-guest--uplink-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "ens40";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-access-guest--uplink-isp-b";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-access-work--uplink-isp-b = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-policy-clab-upstream-selector--access-clab-access-work--uplink-isp-b";
            attach = {
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-access-work--uplink-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "ens41";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-access-work--uplink-isp-b";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-isp-b = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-isp-b";
            attach = {
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "ens42";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-a--uplink-isp-b";
          };
          p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-b = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-b";
            attach = {
              bridge = "br-site-b-p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "ens43";
            };
            link = "p2p-clab-policy-clab-upstream-selector--access-clab-provider-handoff-access-b--uplink-isp-b";
          };
          p2p-clab-core-bgp-uplink-isp-b-clab-upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-b-clab-upstream-selector-p2p-clab-core-bgp-uplink-isp-b-clab-upstream-selector";
            attach = {
              bridge = "br-site-b-p2p-clab-core-bgp-uplink-isp-b-clab-upstream-selector";
              kind = "bridge";
            };
            interface = {
              name = "ens44";
            };
            link = "p2p-clab-core-bgp-uplink-isp-b-clab-upstream-selector";
          };
        };
      };
    };
  };
})
