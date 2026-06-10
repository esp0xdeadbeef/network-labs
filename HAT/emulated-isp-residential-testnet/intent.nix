{
  esp0xdeadbeef = {
    site-a = {
      communicationContract = {
        interfaceTags = {
          external-isp-a = "isp-a";
          external-testnet-host-isp = "testnet-host-isp";
          external-testnet-routed-isp = "testnet-routed-isp";
          external-nebula-egress = "nebula-egress";
          external-wireguard-egress = "wireguard-egress";
          external-wireguard-host128 = "wireguard-host128";
          external-route-import = "route-import";
          external-commercial-vpn = "commercial-vpn";
          service-hat-site-dns = "hat-site-dns";
          service-hat-printer-admin = "hat-printer-admin";
          service-hat-printer-ipp = "hat-printer-ipp";
          service-hat-receiver-control = "hat-receiver-control";
          service-hat-receiver-discovery = "hat-receiver-discovery";
          tenant-client = "client";
          tenant-dmz = "dmz";
          tenant-guest = "guest";
          tenant-iot = "iot";
          tenant-management = "management";
          tenant-provider-handoff-a = "provider-handoff-a";
          tenant-provider-handoff-b = "provider-handoff-b";
          tenant-trusted = "trusted";
          tenant-work = "work";
        };
        trafficTypes = [
          {
            match = [
              {
                family = "any";
                proto = "icmp";
              }
            ];
            name = "icmp";
          }
          {
            match = [
              {
                family = "any";
                proto = "tcp";
              }
              {
                family = "any";
                proto = "udp";
              }
            ];
            name = "overlay-control";
          }
          {
            match = [
              {
                dports = [ 53 ];
                family = "any";
                proto = "udp";
              }
              {
                dports = [ 53 ];
                family = "any";
                proto = "tcp";
              }
            ];
            name = "dns";
          }
          {
            match = [
              {
                dports = [ 631 ];
                family = "any";
                proto = "tcp";
              }
            ];
            name = "ipp";
          }
          {
            match = [
              {
                dports = [ 80 ];
                family = "any";
                proto = "tcp";
              }
            ];
            name = "printer-admin";
          }
          {
            match = [
              {
                dports = [
                  8008
                  8009
                ];
                family = "any";
                proto = "tcp";
              }
            ];
            name = "cast-control";
          }
          {
            match = [
              {
                dports = [ 5353 ];
                family = "any";
                proto = "udp";
              }
              {
                dports = [ 1900 ];
                family = "any";
                proto = "udp";
              }
            ];
            name = "cast-discovery";
          }
        ];
        services = [
          {
            name = "hat-site-dns";
            providers = [ "nixos-site-dns-client" ];
            trafficType = "dns";
          }
          {
            name = "hat-printer-ipp";
            providers = [ "nixos-printer01" ];
            trafficType = "ipp";
          }
          {
            name = "hat-printer-admin";
            providers = [ "nixos-printer01" ];
            trafficType = "printer-admin";
          }
          {
            name = "hat-receiver-control";
            providers = [ "nixos-receiver01" ];
            trafficType = "cast-control";
          }
          {
            name = "hat-receiver-discovery";
            providers = [ "nixos-receiver01" ];
            trafficType = "cast-discovery";
          }
        ];
        sharedServicePolicyAtoms = [
          {
            id = "fs740-printer-discovery-policy";
            sms = "FS-740-HDS-010-SDS-010-SMS-010";
            service = "hat-printer-ipp";
            serviceClass = "printer";
            provider = "nixos-printer01";
            requesterScopes = [ "trusted" ];
            responderScope = "trusted";
            discovery = {
              allowed = true;
              protocols = [
                "mdns"
                "dns-sd"
              ];
              transport = {
                proto = "udp";
                port = 5353;
                scope = "link-local-multicast";
              };
              records = [
                {
                  kind = "bonjour-dns-sd";
                  serviceType = "_ipp._tcp";
                  instance = "hat-printer";
                  targetService = "hat-printer-ipp";
                  payloadPort = 631;
                }
              ];
              decision = "discovery-only";
              doesNotAuthorize = [
                "print-payload"
                "printer-admin"
                "reverse-discovery"
                "multicast-flooding"
                "client-lateral"
              ];
            };
          }
          {
            id = "fs740-printer-print-payload-policy";
            sms = "FS-740-HDS-010-SDS-010-SMS-020";
            service = "hat-printer-ipp";
            serviceClass = "printer";
            requesterScopes = [ "trusted" ];
            responderScope = "trusted";
            payload = {
              allowed = true;
              protocol = "ipp";
              transport = "tcp";
              ports = [ 631 ];
              direction = "requester-to-printer";
              returnBehavior = "established-return-only";
              independentFromDiscovery = true;
            };
          }
          {
            id = "fs740-printer-admin-denial-policy";
            sms = "FS-740-HDS-010-SDS-010-SMS-030";
            service = "hat-printer-admin";
            serviceClass = "printer";
            requesterScopes = [ "trusted" ];
            responderScope = "trusted";
            administration = {
              service = "hat-printer-admin";
              transport = "tcp";
              ports = [ 80 ];
              allowedScopes = [ ];
              deniedScopes = [
                "guest"
                "iot"
                "work"
                "client"
                "management"
              ];
              independentFromDiscovery = true;
              independentFromPayload = true;
            };
          }
          {
            id = "fs740-printer-reverse-multicast-lateral-denial";
            sms = "FS-740-HDS-010-SDS-010-SMS-040";
            service = "hat-printer-ipp";
            serviceClass = "printer";
            requesterScopes = [ "trusted" ];
            responderScope = "trusted";
            deniedPaths = [
              {
                kind = "reverse-discovery";
                from = "trusted";
                to = "trusted";
                direction = "printer-to-requester";
                reason = "printer-discovery-does-not-authorize-reverse-discovery";
              }
              {
                kind = "multicast-flooding";
                from = "trusted";
                to = "any";
                protocols = [
                  "mdns"
                  "dns-sd"
                ];
                reason = "selected-discovery-does-not-authorize-broad-flooding";
              }
              {
                kind = "unrelated-client-lateral";
                from = "guest";
                to = "trusted";
                reason = "printer-service-policy-does-not-authorize-unrelated-client-access";
              }
            ];
          }
          {
            id = "fs760-receiver-discovery-policy";
            sms = "FS-760-HDS-010-SDS-010-SMS-010";
            service = "hat-receiver-discovery";
            serviceClass = "media-receiver";
            provider = "nixos-receiver01";
            controllerScopes = [ "trusted" ];
            receiverScope = "iot";
            discovery = {
              allowed = true;
              selectedProtocols = [
                "mdns"
                "ssdp"
                "dial"
              ];
              transports = [
                {
                  protocol = "mdns";
                  proto = "udp";
                  port = 5353;
                  record = "_googlecast._tcp";
                }
                {
                  protocol = "ssdp";
                  proto = "udp";
                  port = 1900;
                  record = "urn:dial-multiscreen-org:service:dial:1";
                }
                {
                  protocol = "dial";
                  proto = "tcp";
                  service = "hat-receiver-control";
                }
              ];
              decision = "discovery-only";
              doesNotAuthorize = [
                "controller-payload"
                "reverse-initiation"
                "guest-to-trusted"
                "media-to-management"
                "multicast-flooding"
              ];
            };
          }
          {
            id = "fs760-receiver-controller-payload-policy";
            sms = "FS-760-HDS-010-SDS-010-SMS-020";
            service = "hat-receiver-control";
            serviceClass = "media-receiver";
            controllerScopes = [ "trusted" ];
            receiverScope = "iot";
            payload = {
              allowed = true;
              protocol = "cast-control";
              transport = "tcp";
              ports = [
                8008
                8009
              ];
              direction = "controller-to-receiver";
              returnBehavior = "established-return-only";
              independentFromDiscovery = true;
            };
          }
          {
            id = "fs760-receiver-reverse-initiation-denial";
            sms = "FS-760-HDS-010-SDS-010-SMS-030";
            service = "hat-receiver-control";
            serviceClass = "media-receiver";
            controllerScopes = [ "trusted" ];
            receiverScope = "iot";
            deniedPaths = [
              {
                kind = "receiver-to-controller-initiation";
                from = "iot";
                to = "trusted";
                reason = "payload-return-does-not-authorize-new-receiver-initiated-sessions";
              }
            ];
          }
          {
            id = "fs760-receiver-tenant-management-denial";
            sms = "FS-760-HDS-010-SDS-010-SMS-040";
            service = "hat-receiver-control";
            serviceClass = "media-receiver";
            controllerScopes = [ "trusted" ];
            receiverScope = "iot";
            deniedPaths = [
              {
                kind = "guest-to-trusted";
                from = "guest";
                to = "trusted";
                reason = "receiver-policy-does-not-authorize-guest-to-trusted-reachability";
              }
              {
                kind = "media-to-management";
                from = "iot";
                to = "management";
                reason = "receiver-policy-does-not-authorize-management-reachability";
              }
            ];
          }
          {
            id = "fs760-receiver-multicast-flooding-denial";
            sms = "FS-760-HDS-010-SDS-010-SMS-050";
            service = "hat-receiver-discovery";
            serviceClass = "media-receiver";
            controllerScopes = [ "trusted" ];
            receiverScope = "iot";
            deniedPaths = [
              {
                kind = "multicast-flooding";
                from = "trusted";
                to = "any";
                protocols = [
                  "mdns"
                  "ssdp"
                  "dial"
                ];
                reason = "selected-receiver-discovery-does-not-authorize-broad-flooding";
              }
            ];
          }
        ];
        relations = [
          {
            action = "allow";
            from = {
              kind = "tenant";
              name = "client";
            };
            id = "allow-client-to-hat-site-dns";
            priority = 70;
            to = {
              kind = "service";
              name = "hat-site-dns";
            };
            trafficType = "dns";
          }
          {
            action = "allow";
            from = {
              kind = "service";
              name = "hat-site-dns";
            };
            id = "allow-hat-site-dns-service-to-client-uplinks";
            priority = 71;
            to = {
              kind = "external";
              uplinks = [
                "testnet-host-isp"
                "testnet-routed-isp"
              ];
            };
            trafficType = "dns";
          }
          {
            action = "deny";
            from = {
              kind = "tenant";
              name = "client";
            };
            id = "deny-client-dns-to-uplinks";
            priority = 72;
            to = {
              kind = "external";
              uplinks = [
                "testnet-host-isp"
                "testnet-routed-isp"
              ];
            };
            trafficType = "dns";
          }
          {
            action = "allow";
            from = {
              kind = "tenant";
              name = "provider-handoff-a";
            };
            id = "allow-provider-handoff-a-to-isp-a";
            priority = 80;
            to = {
              kind = "external";
              uplinks = [ "isp-a" ];
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "tenant";
              name = "provider-handoff-b";
            };
            id = "allow-provider-handoff-b-to-isp-a";
            priority = 81;
            to = {
              kind = "external";
              uplinks = [ "isp-a" ];
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "tenant";
              name = "client";
            };
            id = "allow-client-to-testnet-host-isp";
            priority = 100;
            to = {
              kind = "external";
              uplinks = [ "testnet-host-isp" ];
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "tenant";
              name = "client";
            };
            id = "allow-client-to-testnet-routed-isp";
            priority = 101;
            to = {
              kind = "external";
              uplinks = [ "testnet-routed-isp" ];
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "tenant";
              name = "iot";
            };
            id = "allow-iot-underlay-to-nebula-egress";
            priority = 110;
            to = {
              kind = "external";
              uplinks = [ "nebula-egress" ];
            };
            trafficType = "overlay-control";
          }
          {
            action = "allow";
            from = {
              kind = "tenant";
              name = "iot";
            };
            id = "allow-iot-underlay-to-wireguard-egress";
            priority = 111;
            to = {
              kind = "external";
              uplinks = [ "wireguard-egress" ];
            };
            trafficType = "overlay-control";
          }
          {
            action = "allow";
            from = {
              kind = "tenant";
              name = "trusted";
            };
            id = "allow-trusted-to-shared-services";
            priority = 120;
            to = {
              kind = "tenant-set";
              members = [
                "trusted"
                "iot"
              ];
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "tenant";
              name = "guest";
            };
            id = "allow-guest-to-isp-a";
            priority = 130;
            to = {
              kind = "external";
              uplinks = [ "isp-a" ];
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "tenant";
              name = "work";
            };
            id = "allow-work-to-isp-a";
            priority = 131;
            to = {
              kind = "external";
              uplinks = [ "isp-a" ];
            };
            trafficType = "any";
          }
        ];
      };

      transport.overlays = [
        {
          name = "nebula-egress";
          terminateOn = "nixos-core-nebula";
        }
        {
          name = "wireguard-egress";
          terminateOn = "nixos-core-wireguard-remote-egress";
        }
        {
          name = "wireguard-host128";
          terminateOn = "nixos-core-wireguard-host128";
        }
      ];

      ownership = {
        endpoints = [
          {
            kind = "host";
            name = "nixos-client";
            tenant = "client";
          }
          {
            kind = "host";
            name = "nixos-site-dns-client";
            tenant = "client";
          }
          {
            kind = "host";
            name = "nixos-printer01";
            tenant = "trusted";
          }
          {
            kind = "host";
            name = "nixos-receiver01";
            tenant = "iot";
          }
          {
            kind = "host";
            name = "nixos-server01";
            tenant = "dmz";
          }
        ];
        prefixes = [
          {
            ipv4 = "10.20.20.0/24";
            ipv6 = "fd42:dead:beef:20::/64";
            kind = "tenant";
            name = "client";
          }
          {
            ipv4 = "10.20.30.0/24";
            ipv6 = "fd42:dead:beef:30::/64";
            kind = "tenant";
            name = "trusted";
          }
          {
            ipv4 = "10.20.40.0/24";
            ipv6 = "fd42:dead:beef:40::/64";
            kind = "tenant";
            name = "guest";
          }
          {
            ipv4 = "10.20.50.0/24";
            ipv6 = "fd42:dead:beef:50::/64";
            kind = "tenant";
            name = "iot";
          }
          {
            ipv4 = "10.20.60.0/24";
            ipv6 = "fd42:dead:beef:60::/64";
            kind = "tenant";
            name = "work";
          }
          {
            ipv4 = "10.20.70.0/24";
            ipv6 = "fd42:dead:beef:70::/64";
            kind = "tenant";
            name = "management";
          }
          {
            ipv4 = "10.20.80.0/24";
            ipv6 = "fd42:dead:beef:80::/64";
            kind = "tenant";
            name = "dmz";
          }
          {
            ipv4 = "10.44.11.0/24";
            ipv6 = "fd42:dead:beef:4411::/64";
            kind = "tenant";
            name = "provider-handoff-a";
          }
          {
            ipv4 = "10.44.12.0/24";
            ipv6 = "fd42:dead:beef:4412::/64";
            kind = "tenant";
            name = "provider-handoff-b";
          }
        ];
      };

      pools = {
        loopback = {
          ipv4 = "10.19.44.0/24";
          ipv6 = "fd42:dead:beef:1944::/118";
        };
        p2p = {
          ipv4 = "10.10.44.0/24";
          ipv6 = "fd42:dead:beef:1044::/118";
        };
      };

      hostManagement = {
        required = true;
        interface = "management";
        purpose = "hardware-management";
      };

      topology = {
        links = [
          [
            "nixos-core-upstream-vlan4"
            "nixos-upstream-selector"
          ]
          [
            "nixos-core-testnet-host-isp"
            "nixos-upstream-selector"
          ]
          [
            "nixos-core-testnet-routed-isp"
            "nixos-upstream-selector"
          ]
          [
            "nixos-core-nebula"
            "nixos-upstream-selector"
          ]
          [
            "nixos-core-wireguard-remote-egress"
            "nixos-upstream-selector"
          ]
          [
            "nixos-core-wireguard-host128"
            "nixos-upstream-selector"
          ]
          [
            "nixos-core-route-import"
            "nixos-upstream-selector"
          ]
          [
            "nixos-core-commercial-vpn"
            "nixos-upstream-selector"
          ]
          [
            "nixos-upstream-selector"
            "nixos-policy"
          ]
          [
            "nixos-policy"
            "nixos-downstream-selector"
          ]
          [
            "nixos-downstream-selector"
            "nixos-provider-handoff-access-a"
          ]
          [
            "nixos-downstream-selector"
            "nixos-provider-handoff-access-b"
          ]
          [
            "nixos-downstream-selector"
            "nixos-access-client"
          ]
          [
            "nixos-downstream-selector"
            "nixos-access-iot"
          ]
          [
            "nixos-downstream-selector"
            "nixos-access-trusted"
          ]
          [
            "nixos-downstream-selector"
            "nixos-access-guest"
          ]
          [
            "nixos-downstream-selector"
            "nixos-access-work"
          ]
          [
            "nixos-downstream-selector"
            "nixos-access-management"
          ]
          [
            "nixos-downstream-selector"
            "nixos-access-dmz"
          ]
          [
            "nixos-provider-handoff-access-a"
            "nixos-core-testnet-host-isp"
          ]
          [
            "nixos-provider-handoff-access-b"
            "nixos-core-testnet-routed-isp"
          ]
          [
            "nixos-access-iot"
            "nixos-core-nebula"
          ]
          [
            "nixos-access-iot"
            "nixos-core-wireguard-remote-egress"
          ]
          [
            "nixos-access-iot"
            "nixos-core-wireguard-host128"
          ]
        ];
        nodes = {
          nixos-access-client = {
            attachments = [
              {
                kind = "tenant";
                name = "client";
              }
            ];
            role = "access";
          };
          nixos-access-dmz = {
            attachments = [
              {
                kind = "tenant";
                name = "dmz";
              }
            ];
            role = "access";
          };
          nixos-access-guest = {
            attachments = [
              {
                kind = "tenant";
                name = "guest";
              }
            ];
            role = "access";
          };
          nixos-access-iot = {
            attachments = [
              {
                kind = "tenant";
                name = "iot";
              }
            ];
            role = "access";
          };
          nixos-access-management = {
            attachments = [
              {
                kind = "tenant";
                name = "management";
              }
            ];
            role = "access";
          };
          nixos-access-trusted = {
            attachments = [
              {
                kind = "tenant";
                name = "trusted";
              }
            ];
            role = "access";
          };
          nixos-access-work = {
            attachments = [
              {
                kind = "tenant";
                name = "work";
              }
            ];
            role = "access";
          };
          nixos-provider-handoff-access-a = {
            attachments = [
              {
                kind = "tenant";
                name = "provider-handoff-a";
              }
            ];
            role = "access";
          };
          nixos-provider-handoff-access-b = {
            attachments = [
              {
                kind = "tenant";
                name = "provider-handoff-b";
              }
            ];
            role = "access";
          };
          nixos-core-commercial-vpn = {
            role = "core";
            uplinks = {
              commercial-vpn = {
                ipv4 = [ "0.0.0.0/0" ];
                ipv6 = [ "::/0" ];
              };
            };
          };
          nixos-core-nebula = {
            attachments = [
              {
                kind = "tenant";
                name = "iot";
              }
            ];
            role = "core";
            uplinks = {
              nebula-egress = {
                ipv4 = [ "100.96.44.0/24" ];
                ipv6 = [ "fd42:dead:beef:9644::/64" ];
              };
            };
          };
          nixos-core-route-import = {
            role = "core";
            uplinks = {
              route-import = {
                ipv4 = [ "198.51.100.0/24" ];
                ipv6 = [ "2001:db8:51::/48" ];
              };
            };
          };
          nixos-core-testnet-host-isp = {
            attachments = [
              {
                kind = "tenant";
                name = "provider-handoff-a";
              }
            ];
            role = "core";
            uplinks = {
              testnet-host-isp = {
                ipv4 = [ "203.0.113.4/32" ];
                ipv6 = [ "2001:db8:113:64::/64" ];
              };
            };
          };
          nixos-core-testnet-routed-isp = {
            attachments = [
              {
                kind = "tenant";
                name = "provider-handoff-b";
              }
            ];
            role = "core";
            uplinks = {
              testnet-routed-isp = {
                ipv4 = [ "203.0.113.0/30" ];
                ipv6 = [ "2001:db8:113::/48" ];
              };
            };
          };
          nixos-core-upstream-vlan4 = {
            role = "core";
            uplinks = {
              isp-a = {
                ipv4 = [ "0.0.0.0/0" ];
                ipv6 = [ "::/0" ];
              };
            };
          };
          nixos-core-wireguard-host128 = {
            attachments = [
              {
                kind = "tenant";
                name = "iot";
              }
            ];
            role = "core";
            uplinks = {
              wireguard-host128 = {
                ipv4 = [ "0.0.0.0/0" ];
                ipv6 = [ "2001:db8:128::1/128" ];
              };
            };
          };
          nixos-core-wireguard-remote-egress = {
            attachments = [
              {
                kind = "tenant";
                name = "iot";
              }
            ];
            role = "core";
            uplinks = {
              wireguard-egress = {
                ipv4 = [ "0.0.0.0/0" ];
                ipv6 = [ "::/0" ];
              };
            };
          };
          nixos-downstream-selector = {
            role = "downstream-selector";
          };
          nixos-policy = {
            role = "policy";
          };
          nixos-upstream-selector = {
            role = "upstream-selector";
          };
        };
      };
    };
    site-b = {
      communicationContract = {
        interfaceTags = {
          external-isp-a = "isp-a";
          external-testnet-host-isp = "testnet-host-isp";
          external-testnet-routed-isp = "testnet-routed-isp";
          external-nebula-egress = "nebula-egress";
          external-wireguard-egress = "wireguard-egress";
          external-wireguard-host128 = "wireguard-host128";
          external-route-import = "route-import";
          external-commercial-vpn = "commercial-vpn";
          service-hat-site-dns = "hat-site-dns";
          service-hat-printer-admin = "hat-printer-admin";
          service-hat-printer-ipp = "hat-printer-ipp";
          service-hat-receiver-control = "hat-receiver-control";
          service-hat-receiver-discovery = "hat-receiver-discovery";
          tenant-client = "client";
          tenant-dmz = "dmz";
          tenant-guest = "guest";
          tenant-iot = "iot";
          tenant-management = "management";
          tenant-provider-handoff-a = "provider-handoff-a";
          tenant-provider-handoff-b = "provider-handoff-b";
          tenant-trusted = "trusted";
          tenant-work = "work";
        };
        trafficTypes = [
          {
            match = [
              {
                family = "any";
                proto = "icmp";
              }
            ];
            name = "icmp";
          }
          {
            match = [
              {
                family = "any";
                proto = "tcp";
              }
              {
                family = "any";
                proto = "udp";
              }
            ];
            name = "overlay-control";
          }
          {
            match = [
              {
                dports = [ 53 ];
                family = "any";
                proto = "udp";
              }
              {
                dports = [ 53 ];
                family = "any";
                proto = "tcp";
              }
            ];
            name = "dns";
          }
          {
            match = [
              {
                dports = [ 631 ];
                family = "any";
                proto = "tcp";
              }
            ];
            name = "ipp";
          }
          {
            match = [
              {
                dports = [ 80 ];
                family = "any";
                proto = "tcp";
              }
            ];
            name = "printer-admin";
          }
          {
            match = [
              {
                dports = [
                  8008
                  8009
                ];
                family = "any";
                proto = "tcp";
              }
            ];
            name = "cast-control";
          }
          {
            match = [
              {
                dports = [ 5353 ];
                family = "any";
                proto = "udp";
              }
              {
                dports = [ 1900 ];
                family = "any";
                proto = "udp";
              }
            ];
            name = "cast-discovery";
          }
        ];
        services = [
          {
            name = "hat-site-dns";
            providers = [ "clab-site-dns-client" ];
            trafficType = "dns";
          }
          {
            name = "hat-printer-ipp";
            providers = [ "clab-printer01" ];
            trafficType = "ipp";
          }
          {
            name = "hat-printer-admin";
            providers = [ "clab-printer01" ];
            trafficType = "printer-admin";
          }
          {
            name = "hat-receiver-control";
            providers = [ "clab-receiver01" ];
            trafficType = "cast-control";
          }
          {
            name = "hat-receiver-discovery";
            providers = [ "clab-receiver01" ];
            trafficType = "cast-discovery";
          }
        ];
        sharedServicePolicyAtoms = [
          {
            id = "fs740-printer-discovery-policy";
            sms = "FS-740-HDS-010-SDS-010-SMS-010";
            service = "hat-printer-ipp";
            serviceClass = "printer";
            provider = "clab-printer01";
            requesterScopes = [ "trusted" ];
            responderScope = "trusted";
            discovery = {
              allowed = true;
              protocols = [
                "mdns"
                "dns-sd"
              ];
              transport = {
                proto = "udp";
                port = 5353;
                scope = "link-local-multicast";
              };
              records = [
                {
                  kind = "bonjour-dns-sd";
                  serviceType = "_ipp._tcp";
                  instance = "hat-printer";
                  targetService = "hat-printer-ipp";
                  payloadPort = 631;
                }
              ];
              decision = "discovery-only";
              doesNotAuthorize = [
                "print-payload"
                "printer-admin"
                "reverse-discovery"
                "multicast-flooding"
                "client-lateral"
              ];
            };
          }
          {
            id = "fs740-printer-print-payload-policy";
            sms = "FS-740-HDS-010-SDS-010-SMS-020";
            service = "hat-printer-ipp";
            serviceClass = "printer";
            requesterScopes = [ "trusted" ];
            responderScope = "trusted";
            payload = {
              allowed = true;
              protocol = "ipp";
              transport = "tcp";
              ports = [ 631 ];
              direction = "requester-to-printer";
              returnBehavior = "established-return-only";
              independentFromDiscovery = true;
            };
          }
          {
            id = "fs740-printer-admin-denial-policy";
            sms = "FS-740-HDS-010-SDS-010-SMS-030";
            service = "hat-printer-admin";
            serviceClass = "printer";
            requesterScopes = [ "trusted" ];
            responderScope = "trusted";
            administration = {
              service = "hat-printer-admin";
              transport = "tcp";
              ports = [ 80 ];
              allowedScopes = [ ];
              deniedScopes = [
                "guest"
                "iot"
                "work"
                "client"
                "management"
              ];
              independentFromDiscovery = true;
              independentFromPayload = true;
            };
          }
          {
            id = "fs740-printer-reverse-multicast-lateral-denial";
            sms = "FS-740-HDS-010-SDS-010-SMS-040";
            service = "hat-printer-ipp";
            serviceClass = "printer";
            requesterScopes = [ "trusted" ];
            responderScope = "trusted";
            deniedPaths = [
              {
                kind = "reverse-discovery";
                from = "trusted";
                to = "trusted";
                direction = "printer-to-requester";
                reason = "printer-discovery-does-not-authorize-reverse-discovery";
              }
              {
                kind = "multicast-flooding";
                from = "trusted";
                to = "any";
                protocols = [
                  "mdns"
                  "dns-sd"
                ];
                reason = "selected-discovery-does-not-authorize-broad-flooding";
              }
              {
                kind = "unrelated-client-lateral";
                from = "guest";
                to = "trusted";
                reason = "printer-service-policy-does-not-authorize-unrelated-client-access";
              }
            ];
          }
          {
            id = "fs760-receiver-discovery-policy";
            sms = "FS-760-HDS-010-SDS-010-SMS-010";
            service = "hat-receiver-discovery";
            serviceClass = "media-receiver";
            provider = "clab-receiver01";
            controllerScopes = [ "trusted" ];
            receiverScope = "iot";
            discovery = {
              allowed = true;
              selectedProtocols = [
                "mdns"
                "ssdp"
                "dial"
              ];
              transports = [
                {
                  protocol = "mdns";
                  proto = "udp";
                  port = 5353;
                  record = "_googlecast._tcp";
                }
                {
                  protocol = "ssdp";
                  proto = "udp";
                  port = 1900;
                  record = "urn:dial-multiscreen-org:service:dial:1";
                }
                {
                  protocol = "dial";
                  proto = "tcp";
                  service = "hat-receiver-control";
                }
              ];
              decision = "discovery-only";
              doesNotAuthorize = [
                "controller-payload"
                "reverse-initiation"
                "guest-to-trusted"
                "media-to-management"
                "multicast-flooding"
              ];
            };
          }
          {
            id = "fs760-receiver-controller-payload-policy";
            sms = "FS-760-HDS-010-SDS-010-SMS-020";
            service = "hat-receiver-control";
            serviceClass = "media-receiver";
            controllerScopes = [ "trusted" ];
            receiverScope = "iot";
            payload = {
              allowed = true;
              protocol = "cast-control";
              transport = "tcp";
              ports = [
                8008
                8009
              ];
              direction = "controller-to-receiver";
              returnBehavior = "established-return-only";
              independentFromDiscovery = true;
            };
          }
          {
            id = "fs760-receiver-reverse-initiation-denial";
            sms = "FS-760-HDS-010-SDS-010-SMS-030";
            service = "hat-receiver-control";
            serviceClass = "media-receiver";
            controllerScopes = [ "trusted" ];
            receiverScope = "iot";
            deniedPaths = [
              {
                kind = "receiver-to-controller-initiation";
                from = "iot";
                to = "trusted";
                reason = "payload-return-does-not-authorize-new-receiver-initiated-sessions";
              }
            ];
          }
          {
            id = "fs760-receiver-tenant-management-denial";
            sms = "FS-760-HDS-010-SDS-010-SMS-040";
            service = "hat-receiver-control";
            serviceClass = "media-receiver";
            controllerScopes = [ "trusted" ];
            receiverScope = "iot";
            deniedPaths = [
              {
                kind = "guest-to-trusted";
                from = "guest";
                to = "trusted";
                reason = "receiver-policy-does-not-authorize-guest-to-trusted-reachability";
              }
              {
                kind = "media-to-management";
                from = "iot";
                to = "management";
                reason = "receiver-policy-does-not-authorize-management-reachability";
              }
            ];
          }
          {
            id = "fs760-receiver-multicast-flooding-denial";
            sms = "FS-760-HDS-010-SDS-010-SMS-050";
            service = "hat-receiver-discovery";
            serviceClass = "media-receiver";
            controllerScopes = [ "trusted" ];
            receiverScope = "iot";
            deniedPaths = [
              {
                kind = "multicast-flooding";
                from = "trusted";
                to = "any";
                protocols = [
                  "mdns"
                  "ssdp"
                  "dial"
                ];
                reason = "selected-receiver-discovery-does-not-authorize-broad-flooding";
              }
            ];
          }
        ];
        relations = [
          {
            action = "allow";
            from = {
              kind = "tenant";
              name = "client";
            };
            id = "allow-client-to-hat-site-dns";
            priority = 70;
            to = {
              kind = "service";
              name = "hat-site-dns";
            };
            trafficType = "dns";
          }
          {
            action = "allow";
            from = {
              kind = "service";
              name = "hat-site-dns";
            };
            id = "allow-hat-site-dns-service-to-client-uplinks";
            priority = 71;
            to = {
              kind = "external";
              uplinks = [
                "testnet-host-isp"
                "testnet-routed-isp"
              ];
            };
            trafficType = "dns";
          }
          {
            action = "deny";
            from = {
              kind = "tenant";
              name = "client";
            };
            id = "deny-client-dns-to-uplinks";
            priority = 72;
            to = {
              kind = "external";
              uplinks = [
                "testnet-host-isp"
                "testnet-routed-isp"
              ];
            };
            trafficType = "dns";
          }
          {
            action = "allow";
            from = {
              kind = "tenant";
              name = "provider-handoff-a";
            };
            id = "allow-provider-handoff-a-to-isp-a";
            priority = 80;
            to = {
              kind = "external";
              uplinks = [ "isp-a" ];
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "tenant";
              name = "provider-handoff-b";
            };
            id = "allow-provider-handoff-b-to-isp-a";
            priority = 81;
            to = {
              kind = "external";
              uplinks = [ "isp-a" ];
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "tenant";
              name = "client";
            };
            id = "allow-client-to-testnet-host-isp";
            priority = 100;
            to = {
              kind = "external";
              uplinks = [ "testnet-host-isp" ];
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "tenant";
              name = "client";
            };
            id = "allow-client-to-testnet-routed-isp";
            priority = 101;
            to = {
              kind = "external";
              uplinks = [ "testnet-routed-isp" ];
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "tenant";
              name = "iot";
            };
            id = "allow-iot-underlay-to-nebula-egress";
            priority = 110;
            to = {
              kind = "external";
              uplinks = [ "nebula-egress" ];
            };
            trafficType = "overlay-control";
          }
          {
            action = "allow";
            from = {
              kind = "tenant";
              name = "iot";
            };
            id = "allow-iot-underlay-to-wireguard-egress";
            priority = 111;
            to = {
              kind = "external";
              uplinks = [ "wireguard-egress" ];
            };
            trafficType = "overlay-control";
          }
          {
            action = "allow";
            from = {
              kind = "tenant";
              name = "trusted";
            };
            id = "allow-trusted-to-shared-services";
            priority = 120;
            to = {
              kind = "tenant-set";
              members = [
                "trusted"
                "iot"
              ];
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "tenant";
              name = "guest";
            };
            id = "allow-guest-to-isp-a";
            priority = 130;
            to = {
              kind = "external";
              uplinks = [ "isp-a" ];
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "tenant";
              name = "work";
            };
            id = "allow-work-to-isp-a";
            priority = 131;
            to = {
              kind = "external";
              uplinks = [ "isp-a" ];
            };
            trafficType = "any";
          }
        ];
      };

      transport.overlays = [
        {
          name = "nebula-egress";
          terminateOn = "clab-core-nebula";
        }
        {
          name = "wireguard-egress";
          terminateOn = "clab-core-wireguard-remote-egress";
        }
        {
          name = "wireguard-host128";
          terminateOn = "clab-core-wireguard-host128";
        }
      ];

      ownership = {
        endpoints = [
          {
            kind = "host";
            name = "clab-client";
            tenant = "client";
          }
          {
            kind = "host";
            name = "clab-site-dns-client";
            tenant = "client";
          }
          {
            kind = "host";
            name = "clab-printer01";
            tenant = "trusted";
          }
          {
            kind = "host";
            name = "clab-receiver01";
            tenant = "iot";
          }
          {
            kind = "host";
            name = "clab-server01";
            tenant = "dmz";
          }
        ];
        prefixes = [
          {
            ipv4 = "10.50.20.0/24";
            ipv6 = "fd42:dead:feed:20::/64";
            kind = "tenant";
            name = "client";
          }
          {
            ipv4 = "10.50.30.0/24";
            ipv6 = "fd42:dead:feed:30::/64";
            kind = "tenant";
            name = "trusted";
          }
          {
            ipv4 = "10.50.40.0/24";
            ipv6 = "fd42:dead:feed:40::/64";
            kind = "tenant";
            name = "guest";
          }
          {
            ipv4 = "10.50.50.0/24";
            ipv6 = "fd42:dead:feed:50::/64";
            kind = "tenant";
            name = "iot";
          }
          {
            ipv4 = "10.50.60.0/24";
            ipv6 = "fd42:dead:feed:60::/64";
            kind = "tenant";
            name = "work";
          }
          {
            ipv4 = "10.50.70.0/24";
            ipv6 = "fd42:dead:feed:70::/64";
            kind = "tenant";
            name = "management";
          }
          {
            ipv4 = "10.50.80.0/24";
            ipv6 = "fd42:dead:feed:80::/64";
            kind = "tenant";
            name = "dmz";
          }
          {
            ipv4 = "10.55.11.0/24";
            ipv6 = "fd42:dead:feed:5511::/64";
            kind = "tenant";
            name = "provider-handoff-a";
          }
          {
            ipv4 = "10.55.12.0/24";
            ipv6 = "fd42:dead:feed:5512::/64";
            kind = "tenant";
            name = "provider-handoff-b";
          }
        ];
      };

      pools = {
        loopback = {
          ipv4 = "10.59.44.0/24";
          ipv6 = "fd42:dead:feed:5944::/118";
        };
        p2p = {
          ipv4 = "10.50.44.0/24";
          ipv6 = "fd42:dead:feed:5044::/118";
        };
      };

      hostManagement = {
        required = true;
        interface = "management";
        purpose = "hardware-management";
      };

      topology = {
        links = [
          [
            "clab-core-upstream-vlan4"
            "clab-upstream-selector"
          ]
          [
            "clab-core-testnet-host-isp"
            "clab-upstream-selector"
          ]
          [
            "clab-core-testnet-routed-isp"
            "clab-upstream-selector"
          ]
          [
            "clab-core-nebula"
            "clab-upstream-selector"
          ]
          [
            "clab-core-wireguard-remote-egress"
            "clab-upstream-selector"
          ]
          [
            "clab-core-wireguard-host128"
            "clab-upstream-selector"
          ]
          [
            "clab-core-route-import"
            "clab-upstream-selector"
          ]
          [
            "clab-core-commercial-vpn"
            "clab-upstream-selector"
          ]
          [
            "clab-upstream-selector"
            "clab-policy"
          ]
          [
            "clab-policy"
            "clab-downstream-selector"
          ]
          [
            "clab-downstream-selector"
            "clab-provider-handoff-access-a"
          ]
          [
            "clab-downstream-selector"
            "clab-provider-handoff-access-b"
          ]
          [
            "clab-downstream-selector"
            "clab-access-client"
          ]
          [
            "clab-downstream-selector"
            "clab-access-iot"
          ]
          [
            "clab-downstream-selector"
            "clab-access-trusted"
          ]
          [
            "clab-downstream-selector"
            "clab-access-guest"
          ]
          [
            "clab-downstream-selector"
            "clab-access-work"
          ]
          [
            "clab-downstream-selector"
            "clab-access-management"
          ]
          [
            "clab-downstream-selector"
            "clab-access-dmz"
          ]
          [
            "clab-provider-handoff-access-a"
            "clab-core-testnet-host-isp"
          ]
          [
            "clab-provider-handoff-access-b"
            "clab-core-testnet-routed-isp"
          ]
          [
            "clab-access-iot"
            "clab-core-nebula"
          ]
          [
            "clab-access-iot"
            "clab-core-wireguard-remote-egress"
          ]
          [
            "clab-access-iot"
            "clab-core-wireguard-host128"
          ]
        ];
        nodes = {
          clab-access-client = {
            attachments = [
              {
                kind = "tenant";
                name = "client";
              }
            ];
            role = "access";
          };
          clab-access-dmz = {
            attachments = [
              {
                kind = "tenant";
                name = "dmz";
              }
            ];
            role = "access";
          };
          clab-access-guest = {
            attachments = [
              {
                kind = "tenant";
                name = "guest";
              }
            ];
            role = "access";
          };
          clab-access-iot = {
            attachments = [
              {
                kind = "tenant";
                name = "iot";
              }
            ];
            role = "access";
          };
          clab-access-management = {
            attachments = [
              {
                kind = "tenant";
                name = "management";
              }
            ];
            role = "access";
          };
          clab-access-trusted = {
            attachments = [
              {
                kind = "tenant";
                name = "trusted";
              }
            ];
            role = "access";
          };
          clab-access-work = {
            attachments = [
              {
                kind = "tenant";
                name = "work";
              }
            ];
            role = "access";
          };
          clab-provider-handoff-access-a = {
            attachments = [
              {
                kind = "tenant";
                name = "provider-handoff-a";
              }
            ];
            role = "access";
          };
          clab-provider-handoff-access-b = {
            attachments = [
              {
                kind = "tenant";
                name = "provider-handoff-b";
              }
            ];
            role = "access";
          };
          clab-core-commercial-vpn = {
            role = "core";
            uplinks.commercial-vpn = {
              ipv4 = [ "0.0.0.0/0" ];
              ipv6 = [ "::/0" ];
            };
          };
          clab-core-nebula = {
            attachments = [
              {
                kind = "tenant";
                name = "iot";
              }
            ];
            role = "core";
            uplinks.nebula-egress = {
              ipv4 = [ "100.97.44.0/24" ];
              ipv6 = [ "fd42:dead:feed:9744::/64" ];
            };
          };
          clab-core-route-import = {
            role = "core";
            uplinks.route-import = {
              ipv4 = [ "198.51.100.0/24" ];
              ipv6 = [ "2001:db8:51::/48" ];
            };
          };
          clab-core-testnet-host-isp = {
            attachments = [
              {
                kind = "tenant";
                name = "provider-handoff-a";
              }
            ];
            role = "core";
            uplinks.testnet-host-isp = {
              ipv4 = [ "203.0.113.4/32" ];
              ipv6 = [ "2001:db8:113:64::/64" ];
            };
          };
          clab-core-testnet-routed-isp = {
            attachments = [
              {
                kind = "tenant";
                name = "provider-handoff-b";
              }
            ];
            role = "core";
            uplinks.testnet-routed-isp = {
              ipv4 = [ "203.0.113.0/30" ];
              ipv6 = [ "2001:db8:113::/48" ];
            };
          };
          clab-core-upstream-vlan4 = {
            role = "core";
            uplinks.isp-a = {
              ipv4 = [ "0.0.0.0/0" ];
              ipv6 = [ "::/0" ];
            };
          };
          clab-core-wireguard-host128 = {
            attachments = [
              {
                kind = "tenant";
                name = "iot";
              }
            ];
            role = "core";
            uplinks.wireguard-host128 = {
              ipv4 = [ "0.0.0.0/0" ];
              ipv6 = [ "2001:db8:128::2/128" ];
            };
          };
          clab-core-wireguard-remote-egress = {
            attachments = [
              {
                kind = "tenant";
                name = "iot";
              }
            ];
            role = "core";
            uplinks.wireguard-egress = {
              ipv4 = [ "0.0.0.0/0" ];
              ipv6 = [ "::/0" ];
            };
          };
          clab-downstream-selector = {
            role = "downstream-selector";
          };
          clab-policy = {
            role = "policy";
          };
          clab-upstream-selector = {
            role = "upstream-selector";
          };
        };
      };
    };
  };
}
