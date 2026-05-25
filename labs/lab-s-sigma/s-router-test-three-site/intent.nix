{
  esp = {
    nixos = {
      communicationContract = {
        interfaceTags = {
          external-east-west = "east-west";
          external-isp-a = "isp-a";
          external-isp-b = "isp-b";
          service-dmz-nebula = "dmz-nebula";
          service-nixos-hostile-4444 = "nixos-hostile-4444";
          service-site-dns-mgmt = "site-dns-mgmt";
          service-cast-control = "cast-control";
          service-cast-discovery = "cast-discovery";
          tenant-admin = "admin";
          tenant-client = "client";
          tenant-dmz = "dmz";
          tenant-hostile = "hostile";
          tenant-mgmt = "mgmt";
          tenant-streaming = "streaming";
        };
        relations = [
          {
            action = "allow";
            from = {
              kind = "external";
              uplinks = [
                "isp-a"
                "isp-b"
              ];
            };
            id = "allow-site-wan-icmp-anywhere";
            priority = 6;
            to = "any";
            trafficType = "icmp";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              name = "east-west";
            };
            id = "allow-site-overlay-icmp-anywhere";
            priority = 7;
            to = "any";
            trafficType = "icmp";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [ "admin" ];
            };
            id = "allow-admin-to-mgmt";
            priority = 10;
            to = {
              kind = "tenant-set";
              members = [ "mgmt" ];
            };
            trafficType = "any";
          }
          {
            action = "deny";
            from = {
              kind = "tenant-set";
              members = [
                "client"
                "streaming"
                "dmz"
                "hostile"
              ];
            };
            id = "deny-production-to-mgmt";
            priority = 11;
            to = {
              kind = "tenant-set";
              members = [ "mgmt" ];
            };
            trafficType = "any";
          }
          {
            action = "deny";
            from = {
              kind = "tenant-set";
              members = [ "streaming" ];
            };
            id = "deny-streaming-to-client";
            priority = 12;
            to = {
              kind = "tenant-set";
              members = [ "client" ];
            };
            trafficType = "any";
          }
          {
            action = "deny";
            from = {
              kind = "tenant-set";
              members = [ "hostile" ];
            };
            id = "deny-hostile-to-local-tenants";
            priority = 13;
            to = {
              kind = "tenant-set";
              members = [
                "admin"
                "client"
                "streaming"
                "dmz"
              ];
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [
                "admin"
                "client"
                "streaming"
                "dmz"
              ];
            };
            id = "allow-tenants-to-site-dns";
            priority = 9;
            to = {
              kind = "service";
              name = "site-dns-mgmt";
            };
            trafficType = "dns";
          }
          {
            action = "allow";
            from = {
              kind = "service";
              name = "site-dns-mgmt";
            };
            id = "allow-site-dns-service-to-uplinks";
            priority = 24;
            to = {
              kind = "external";
              uplinks = [
                "isp-a"
                "isp-b"
              ];
            };
            trafficType = "dns";
          }
          {
            action = "deny";
            from = {
              kind = "tenant-set";
              members = [
                "admin"
                "client"
                "streaming"
                "dmz"
              ];
            };
            id = "deny-tenant-dns-to-uplinks";
            priority = 25;
            to = {
              kind = "external";
              uplinks = [
                "isp-a"
                "isp-b"
              ];
            };
            trafficType = "dns";
          }
          {
            action = "deny";
            from = {
              kind = "tenant-set";
              members = [ "hostile" ];
            };
            id = "deny-hostile-to-local-uplinks";
            priority = 26;
            to = {
              kind = "external";
              uplinks = [
                "isp-a"
                "isp-b"
              ];
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [ "client" ];
            };
            id = "allow-client-to-cast-discovery";
            priority = 30;
            to = {
              kind = "service";
              name = "cast-discovery";
            };
            trafficType = "cast-discovery";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [ "client" ];
            };
            id = "allow-client-to-cast-control";
            priority = 31;
            to = {
              kind = "service";
              name = "cast-control";
            };
            trafficType = "cast-control";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [ "hostile" ];
            };
            id = "allow-hostile-egress-to-hetz-overlay";
            priority = 32;
            to = {
              kind = "external";
              name = "east-west";
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [
                "admin"
                "client"
                "streaming"
              ];
            };
            id = "allow-user-tenants-to-uplinks";
            priority = 100;
            to = {
              kind = "external";
              uplinks = [
                "isp-a"
                "isp-b"
              ];
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              name = "east-west";
            };
            id = "allow-hetz-public-4444-to-nixos-hostile";
            priority = 121;
            to = {
              kind = "service";
              name = "nixos-hostile-4444";
            };
            trafficType = "tcp-udp-4444";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              name = "east-west";
            };
            id = "allow-east-west-to-site-dns";
            priority = 115;
            to = {
              kind = "service";
              name = "site-dns-mgmt";
            };
            trafficType = "dns";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              uplinks = [
                "isp-a"
                "isp-b"
              ];
            };
            id = "allow-wan-to-dmz-nebula";
            priority = 120;
            to = {
              kind = "service";
              name = "dmz-nebula";
            };
            trafficType = "nebula";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              name = "east-west";
            };
            id = "allow-nebula-underlay-to-uplinks";
            priority = 130;
            to = {
              kind = "external";
              uplinks = [
                "isp-a"
                "isp-b"
              ];
            };
            trafficType = "nebula";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              name = "east-west";
            };
            id = "allow-nebula-runtime-underlay-to-uplinks";
            priority = 131;
            to = {
              kind = "external";
              uplinks = [
                "isp-a"
                "isp-b"
              ];
            };
            trafficType = "nebula-runtime";
          }
        ];
        services = [
          {
            name = "site-dns-mgmt";
            providers = [ "site-dns-mgmt" ];
            trafficType = "dns";
          }
          {
            name = "dmz-nebula";
            providers = [ "nebula01" ];
            trafficType = "nebula";
          }
          {
            name = "nixos-hostile-4444";
            providers = [ "nixos-hostile01" ];
            trafficType = "tcp-udp-4444";
          }
          {
            name = "cast-control";
            providers = [ "streaming01" ];
            trafficType = "cast-control";
          }
          {
            name = "cast-discovery";
            providers = [ "streaming01" ];
            trafficType = "cast-discovery";
          }
        ];
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
                dports = [ 4444 ];
                family = "any";
                proto = "tcp";
              }
              {
                dports = [ 4444 ];
                family = "any";
                proto = "udp";
              }
            ];
            name = "tcp-udp-4444";
          }
          {
            match = [
              {
                dports = [ 4242 ];
                family = "any";
                proto = "udp";
              }
              {
                dports = [ 4242 ];
                family = "any";
                proto = "tcp";
              }
            ];
            name = "nebula";
          }
          {
            match = [
              {
                dports = [ 443 ];
                family = "any";
                proto = "udp";
              }
            ];
            name = "nebula-runtime";
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
      };
      ownership = {
        endpoints = [
          {
            kind = "host";
            name = "nebula01";
            tenant = "dmz";
          }
          {
            kind = "host";
            name = "nixos-hostile01";
            tenant = "hostile";
          }
          {
            kind = "host";
            name = "site-dns-mgmt";
            tenant = "mgmt";
          }
          {
            kind = "host";
            name = "streaming01";
            tenant = "streaming";
          }
        ];
        prefixes = [
          {
            ipv4 = "10.20.10.0/24";
            ipv6 = "fd42:dead:beef:10::/64";
            kind = "tenant";
            name = "mgmt";
          }
          {
            ipv4 = "10.20.15.0/24";
            ipv6 = "fd42:dead:beef:15::/64";
            kind = "tenant";
            name = "admin";
          }
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
            name = "dmz";
          }
          {
            ipv4 = "10.20.50.0/24";
            ipv6 = "fd42:dead:beef:50::/64";
            kind = "tenant";
            name = "streaming";
          }
          {
            ipv4 = "10.20.70.0/24";
            ipv6 = "fd42:dead:beef:70::/64";
            kind = "tenant";
            name = "hostile";
            routedPrefixes = [
              {
                allocation = "runtime";
                family = "ipv6";
                name = "nixos-hostile-public";
                prefixPostfix = "4444";
                delegatedPrefixLength = 64;
                perTenantPrefixLength = 64;
                slot = 0;
                sourceFile = "/run/secrets/access-node-ipv6-prefix-esp-nixos-router-access-hostile";
              }
            ];
          }
        ];
      };
      pools = {
        overlay = {
          ipv4 = {
            offsetStart = 10;
            perNodePrefixLength = 32;
            prefix = "100.96.10.0/24";
          };
          ipv6 = {
            offsetStart = 10;
            perNodePrefixLength = 128;
            prefix = "fd42:dead:beef:ee::/64";
          };
        };
        loopback = {
          ipv4 = "10.19.0.0/24";
          ipv6 = "fd42:dead:beef:1900::/118";
        };
        p2p = {
          ipv4 = "10.10.0.0/24";
          ipv6 = "fd42:dead:beef:1000::/118";
        };
      };
      topology = {
        links = [
          [
            "nixos-router-core-isp-a"
            "nixos-router-upstream"
          ]
          [
            "nixos-router-core-isp-b"
            "nixos-router-upstream"
          ]
          [
            "nixos-router-core-nebula"
            "nixos-router-upstream"
          ]
          [
            "nixos-router-upstream"
            "nixos-router-policy"
          ]
          [
            "nixos-router-policy"
            "nixos-router-downstream"
          ]
          [
            "nixos-router-downstream"
            "nixos-router-access-admin"
          ]
          [
            "nixos-router-downstream"
            "nixos-router-access-client"
          ]
          [
            "nixos-router-downstream"
            "nixos-router-access-dmz"
          ]
          [
            "nixos-router-downstream"
            "nixos-router-access-hostile"
          ]
          [
            "nixos-router-downstream"
            "nixos-router-access-mgmt"
          ]
          [
            "nixos-router-downstream"
            "nixos-router-access-streaming"
          ]
        ];
        nodes = {
          nixos-router-access-admin = {
            attachments = [
              {
                kind = "tenant";
                name = "admin";
              }
            ];
            role = "access";
          };
          nixos-router-access-client = {
            attachments = [
              {
                kind = "tenant";
                name = "client";
              }
            ];
            role = "access";
          };
          nixos-router-access-dmz = {
            attachments = [
              {
                kind = "tenant";
                name = "dmz";
              }
            ];
            role = "access";
          };
          nixos-router-access-mgmt = {
            attachments = [
              {
                kind = "tenant";
                name = "mgmt";
              }
            ];
            role = "access";
          };
          nixos-router-access-hostile = {
            attachments = [
              {
                kind = "tenant";
                name = "hostile";
              }
            ];
            role = "access";
          };
          nixos-router-access-streaming = {
            attachments = [
              {
                kind = "tenant";
                name = "streaming";
              }
            ];
            role = "access";
          };
          nixos-router-core-isp-a = {
            role = "core";
            uplinks = {
              isp-a = {
                egress.ipv6.translation = {
                  mode = "nat66";
                  warning = "NAT66 is intentionally modeled only for explicit simulated or otherwise non-routed IPv6 uplinks; routed public-prefix tenants must stay routed, not masqueraded.";
                };
                ipv4 = [ "0.0.0.0/0" ];
                ipv6 = [ "::/0" ];
              };
            };
          };
          nixos-router-core-isp-b = {
            role = "core";
            uplinks = {
              isp-b = {
                egress.ipv6.translation = {
                  mode = "nat66";
                  warning = "NAT66 is intentionally modeled only for explicit simulated or otherwise non-routed IPv6 uplinks; routed public-prefix tenants must stay routed, not masqueraded.";
                };
                ipv4 = [ "0.0.0.0/0" ];
                ipv6 = [ "::/0" ];
              };
            };
          };
          nixos-router-core-nebula = {
            attachments = [
              {
                kind = "tenant";
                name = "client";
              }
            ];
            role = "core";
            uplinks = {
              east-west = {
                ipv4 = [
                  "10.50.10.0/24"
                  "10.50.15.0/24"
                  "10.50.20.0/24"
                  "10.50.30.0/24"
                  "10.50.50.0/24"
                  "10.70.10.0/24"
                  "10.90.10.0/24"
                  "0.0.0.0/0"
                ];
                ipv6 = [
                  "fd42:dead:feed:10::/64"
                  "fd42:dead:feed:15::/64"
                  "fd42:dead:feed:20::/64"
                  "fd42:dead:feed:30::/64"
                  "fd42:dead:feed:50::/64"
                  "fd42:dead:feed:70::/64"
                  "fd42:dead:cafe:10::/64"
                  "::/0"
                ];
              };
            };
          };
          nixos-router-downstream = {
            role = "downstream-selector";
          };
          nixos-router-policy = {
            role = "policy";
          };
          nixos-router-upstream = {
            role = "upstream-selector";
          };
        };
      };
      transport = {
        overlays = [
          {
            mustTraverse = [ "policy" ];
            name = "east-west";
            peerSites = [
              "esp.clab"
              "esp.hetz"
            ];
            terminateOn = "nixos-router-core-nebula";
            underlayAccess = {
              kind = "tenant";
              name = "client";
            };
            underlayTrafficTypes = [
              "nebula"
              "nebula-runtime"
            ];
          }
        ];
      };
    };
    hetz = {
      communicationContract = {
        interfaceTags = {
          external-east-west = "east-west";
          external-wan = "wan";
          service-clab-client-4445 = "clab-client-4445";
          service-dmz-nebula = "dmz-nebula";
          service-hetz-dns-dmz = "hetz-dns-dmz";
          service-hetz-client-4446 = "hetz-client-4446";
          service-nixos-hostile-4444 = "nixos-hostile-4444";
          tenant-client = "client";
          tenant-dmz = "dmz";
        };
        relations = [
          {
            action = "allow";
            from = {
              kind = "external";
              uplinks = [ "wan" ];
            };
            id = "allow-hetz-wan-icmp-anywhere";
            priority = 6;
            to = "any";
            trafficType = "icmp";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              name = "east-west";
            };
            id = "allow-hetz-overlay-icmp-anywhere";
            priority = 7;
            to = "any";
            trafficType = "icmp";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [ "client" ];
            };
            id = "allow-hetz-client-to-dmz-dns";
            priority = 20;
            to = {
              kind = "service";
              name = "hetz-dns-dmz";
            };
            trafficType = "dns";
          }
          {
            action = "deny";
            from = {
              kind = "tenant-set";
              members = [ "client" ];
            };
            id = "deny-hetz-client-dns-to-wan";
            priority = 25;
            to = {
              kind = "external";
              name = "wan";
            };
            trafficType = "dns";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [ "client" ];
            };
            id = "allow-hetz-client-to-wan";
            priority = 100;
            to = {
              kind = "external";
              name = "wan";
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "service";
              name = "hetz-dns-dmz";
            };
            id = "allow-hetz-dns-service-to-east-west";
            priority = 109;
            to = {
              kind = "external";
              name = "east-west";
            };
            trafficType = "dns";
          }
          {
            action = "allow";
            from = {
              kind = "service";
              name = "hetz-dns-dmz";
            };
            id = "allow-hetz-dns-service-to-wan";
            priority = 110;
            to = {
              kind = "external";
              name = "wan";
            };
            trafficType = "dns";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              name = "east-west";
            };
            id = "allow-hostile-overlay-egress-to-wan";
            priority = 120;
            to = {
              kind = "external";
              uplinks = [ "wan" ];
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              uplinks = [ "wan" ];
            };
            id = "allow-wan-to-dmz-nebula";
            priority = 125;
            to = {
              kind = "service";
              name = "dmz-nebula";
            };
            trafficType = "nebula";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              name = "east-west";
            };
            id = "allow-east-west-underlay-to-dmz-nebula";
            priority = 126;
            to = {
              kind = "service";
              name = "dmz-nebula";
            };
            trafficType = "nebula";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              uplinks = [ "wan" ];
            };
            id = "allow-wan-to-nixos-hostile-4444";
            priority = 130;
            to = {
              kind = "service";
              name = "nixos-hostile-4444";
            };
            trafficType = "tcp-udp-4444";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              uplinks = [ "wan" ];
            };
            id = "allow-wan-to-clab-client-4445";
            priority = 131;
            to = {
              kind = "service";
              name = "clab-client-4445";
            };
            trafficType = "tcp-udp-4445";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              uplinks = [ "wan" ];
            };
            id = "allow-wan-to-hetz-client-4446";
            priority = 132;
            to = {
              kind = "service";
              name = "hetz-client-4446";
            };
            trafficType = "tcp-udp-4446";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              name = "east-west";
            };
            id = "allow-overlay-to-hostile-public-dns";
            priority = 133;
            to = {
              kind = "service";
              name = "hostile-public-dns";
            };
            trafficType = "dns";
          }
        ];
        services = [
          {
            name = "hetz-dns-dmz";
            providers = [ "hetz-dns-dmz" ];
            trafficType = "dns";
          }
          {
            name = "dmz-nebula";
            providers = [ "hetz-router-lighthouse" ];
            trafficType = "nebula";
          }
          {
            name = "nixos-hostile-4444";
            providers = [ "nixos-hostile01" ];
            trafficType = "tcp-udp-4444";
          }
          {
            name = "clab-client-4445";
            providers = [ "clab-client01" ];
            trafficType = "tcp-udp-4445";
          }
          {
            name = "hetz-client-4446";
            providers = [ "hetz-client01" ];
            trafficType = "tcp-udp-4446";
          }
          {
            name = "hostile-public-dns";
            providers = [ "hetz-dns-dmz" ];
            trafficType = "dns";
          }
        ];
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
                dports = [ 4242 ];
                family = "any";
                proto = "udp";
              }
              {
                dports = [ 4242 ];
                family = "any";
                proto = "tcp";
              }
            ];
            name = "nebula";
          }
          {
            match = [
              {
                dports = [ 4444 ];
                family = "any";
                proto = "tcp";
              }
              {
                dports = [ 4444 ];
                family = "any";
                proto = "udp";
              }
            ];
            name = "tcp-udp-4444";
          }
          {
            match = [
              {
                dports = [ 4445 ];
                family = "any";
                proto = "tcp";
              }
              {
                dports = [ 4445 ];
                family = "any";
                proto = "udp";
              }
            ];
            name = "tcp-udp-4445";
          }
          {
            match = [
              {
                dports = [ 4446 ];
                family = "any";
                proto = "tcp";
              }
              {
                dports = [ 4446 ];
                family = "any";
                proto = "udp";
              }
            ];
            name = "tcp-udp-4446";
          }
        ];
      };
      ownership = {
        endpoints = [
          {
            kind = "host";
            name = "hetz-dns-dmz";
            tenant = "dmz";
          }
          {
            kind = "host";
            name = "hetz-router-lighthouse";
            tenant = "dmz";
          }
          {
            kind = "host";
            name = "hetz-client01";
            tenant = "client";
          }
        ];
        prefixes = [
          {
            ipv4 = "10.90.10.0/24";
            ipv6 = "fd42:dead:cafe:10::/64";
            kind = "tenant";
            name = "dmz";
          }
          {
            ipv4 = "10.90.20.0/24";
            ipv6 = "fd42:dead:cafe:20::/64";
            kind = "tenant";
            name = "client";
            routedPrefixes = [
              {
                allocation = "runtime";
                family = "ipv6";
                name = "hetz-client-public";
                prefixPostfix = "4446";
                delegatedPrefixLength = 64;
                perTenantPrefixLength = 64;
                slot = 0;
                sourceFile = "/run/secrets/access-node-ipv6-prefix-esp-hetz-router-access-client";
              }
            ];
          }
        ];
      };
      pools = {
        overlay = {
          ipv4 = {
            offsetStart = 10;
            perNodePrefixLength = 32;
            prefix = "100.96.10.0/24";
          };
          ipv6 = {
            offsetStart = 10;
            perNodePrefixLength = 128;
            prefix = "fd42:dead:beef:ee::/64";
          };
        };
        loopback = {
          ipv4 = "10.89.0.0/24";
          ipv6 = "fd42:dead:cafe:1900::/118";
        };
        p2p = {
          ipv4 = "10.80.0.0/24";
          ipv6 = "fd42:dead:cafe:1000::/118";
        };
      };
      topology = {
        hostNatIngress = {
          enabled = true;
          targetNode = "hetz-router-core";
          uplink = "wan";
          hostReservedPorts = [
            {
              dports = [ 22 ];
              name = "ssh";
              proto = "tcp";
            }
          ];
        };
        links = [
          [
            "hetz-router-core"
            "hetz-router-upstream"
          ]
          [
            "hetz-router-nebula-core"
            "hetz-router-upstream"
          ]
          [
            "hetz-router-upstream"
            "hetz-router-policy"
          ]
          [
            "hetz-router-policy"
            "hetz-router-downstream"
          ]
          [
            "hetz-router-downstream"
            "hetz-router-access-dmz"
          ]
          [
            "hetz-router-downstream"
            "hetz-router-access-client"
          ]
        ];
        nodes = {
          hetz-router-access-client = {
            attachments = [
              {
                kind = "tenant";
                name = "client";
              }
            ];
            role = "access";
          };
          hetz-router-access-dmz = {
            attachments = [
              {
                kind = "tenant";
                name = "dmz";
              }
            ];
            role = "access";
          };
          hetz-router-core = {
            role = "core";
            uplinks = {
              wan = {
                ipv4 = [ "0.0.0.0/0" ];
                ipv6 = [ "::/0" ];
              };
            };
          };
          hetz-router-downstream = {
            role = "downstream-selector";
          };
          hetz-router-nebula-core = {
            attachments = [
              {
                kind = "tenant";
                name = "client";
              }
            ];
            role = "core";
            uplinks = {
              east-west = {
                ipv4 = [
                  "10.20.70.0/24"
                  "10.50.20.0/24"
                  "10.50.70.0/24"
                  "10.70.10.0/24"
                ];
                ipv6 = [
                  "fd42:dead:beef:70::/64"
                  "fd42:dead:feed:20::/64"
                  "fd42:dead:feed:70::/64"
                  "fd42:dead:feed:7000::/56"
                ];
              };
            };
          };
          hetz-router-policy = {
            role = "policy";
          };
          hetz-router-upstream = {
            role = "upstream-selector";
          };
        };
      };
      transport = {
        overlays = [
          {
            mustTraverse = [ "policy" ];
            name = "east-west";
            peerSites = [
              "esp.nixos"
              "esp.clab"
            ];
            terminateOn = "hetz-router-nebula-core";
            underlayAccess = {
              kind = "tenant";
              name = "client";
            };
            underlayTrafficTypes = [ "nebula" ];
          }
        ];
      };
    };
    clab = {
      communicationContract = {
        interfaceTags = {
          external-east-west = "east-west";
          external-wan = "wan";
          service-clab-site-dns = "clab-site-dns";
          service-clab-client-4445 = "clab-client-4445";
          service-cast-control = "cast-control";
          service-cast-discovery = "cast-discovery";
          tenant-admin = "admin";
          tenant-client = "client";
          tenant-dmz = "dmz";
          tenant-hostile = "hostile";
          tenant-mgmt = "mgmt";
          tenant-streaming = "streaming";
        };
        relations = [
          {
            action = "allow";
            from = {
              kind = "external";
              name = "wan";
            };
            id = "allow-clab-wan-icmp-anywhere";
            priority = 6;
            to = "any";
            trafficType = "icmp";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              name = "east-west";
            };
            id = "allow-clab-overlay-icmp-anywhere";
            priority = 7;
            to = "any";
            trafficType = "icmp";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [ "admin" ];
            };
            id = "allow-admin-to-mgmt";
            priority = 10;
            to = {
              kind = "tenant-set";
              members = [ "mgmt" ];
            };
            trafficType = "any";
          }
          {
            action = "deny";
            from = {
              kind = "tenant-set";
              members = [
                "client"
                "streaming"
                "dmz"
                "hostile"
              ];
            };
            id = "deny-production-to-mgmt";
            priority = 11;
            to = {
              kind = "tenant-set";
              members = [ "mgmt" ];
            };
            trafficType = "any";
          }
          {
            action = "deny";
            from = {
              kind = "tenant-set";
              members = [ "streaming" ];
            };
            id = "deny-streaming-to-client";
            priority = 12;
            to = {
              kind = "tenant-set";
              members = [ "client" ];
            };
            trafficType = "any";
          }
          {
            action = "deny";
            from = {
              kind = "tenant-set";
              members = [ "hostile" ];
            };
            id = "deny-hostile-to-local-tenants";
            priority = 13;
            to = {
              kind = "tenant-set";
              members = [
                "admin"
                "client"
                "streaming"
                "dmz"
              ];
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [
                "admin"
                "client"
                "streaming"
                "dmz"
              ];
            };
            id = "allow-normal-tenants-to-clab-dns";
            priority = 9;
            to = {
              kind = "service";
              name = "clab-site-dns";
            };
            trafficType = "dns";
          }
          {
            action = "deny";
            from = {
              kind = "tenant-set";
              members = [
                "admin"
                "client"
                "streaming"
                "dmz"
              ];
            };
            id = "deny-normal-tenant-dns-to-wan";
            priority = 25;
            to = {
              kind = "external";
              name = "wan";
            };
            trafficType = "dns";
          }
          {
            action = "allow";
            from = {
              kind = "service";
              name = "clab-site-dns";
            };
            id = "allow-clab-site-dns-service-to-wan";
            priority = 24;
            to = {
              kind = "external";
              name = "wan";
            };
            trafficType = "dns";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [ "client" ];
            };
            id = "allow-client-to-cast-discovery";
            priority = 30;
            to = {
              kind = "service";
              name = "cast-discovery";
            };
            trafficType = "cast-discovery";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [ "client" ];
            };
            id = "allow-client-to-cast-control";
            priority = 31;
            to = {
              kind = "service";
              name = "cast-control";
            };
            trafficType = "cast-control";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [
                "admin"
                "client"
                "streaming"
              ];
            };
            id = "allow-normal-tenants-to-wan";
            priority = 100;
            to = {
              kind = "external";
              name = "wan";
            };
            trafficType = "any";
          }
          {
            action = "deny";
            from = {
              kind = "tenant-set";
              members = [ "hostile" ];
            };
            id = "deny-hostile-to-local-wan";
            priority = 101;
            to = {
              kind = "external";
              name = "wan";
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [ "hostile" ];
            };
            id = "allow-hostile-dns-to-hetz-public-dns";
            priority = 110;
            to = {
              kind = "external";
              name = "east-west";
            };
            trafficType = "dns";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [ "hostile" ];
            };
            id = "allow-hostile-egress-to-hetz-overlay";
            priority = 111;
            to = {
              kind = "external";
              name = "east-west";
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              name = "east-west";
            };
            id = "allow-hetz-public-4445-to-clab-client";
            priority = 120;
            to = {
              kind = "service";
              name = "clab-client-4445";
            };
            trafficType = "tcp-udp-4445";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              name = "east-west";
            };
            id = "allow-nebula-underlay-to-wan";
            priority = 130;
            to = {
              kind = "external";
              uplinks = [ "wan" ];
            };
            trafficType = "nebula";
          }
        ];
        services = [
          {
            name = "clab-site-dns";
            providers = [ "clab-site-dns" ];
            trafficType = "dns";
          }
          {
            name = "clab-client-4445";
            providers = [ "clab-client01" ];
            trafficType = "tcp-udp-4445";
          }
          {
            name = "cast-control";
            providers = [ "clab-streaming01" ];
            trafficType = "cast-control";
          }
          {
            name = "cast-discovery";
            providers = [ "clab-streaming01" ];
            trafficType = "cast-discovery";
          }
        ];
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
                dports = [ 4242 ];
                family = "any";
                proto = "tcp";
              }
              {
                dports = [ 4242 ];
                family = "any";
                proto = "udp";
              }
            ];
            name = "nebula";
          }
          {
            match = [
              {
                dports = [ 4445 ];
                family = "any";
                proto = "tcp";
              }
              {
                dports = [ 4445 ];
                family = "any";
                proto = "udp";
              }
            ];
            name = "tcp-udp-4445";
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
      };
      ownership = {
        endpoints = [
          {
            kind = "host";
            name = "clab-site-dns";
            tenant = "mgmt";
          }
          {
            kind = "host";
            name = "clab-client01";
            tenant = "client";
          }
          {
            kind = "host";
            name = "clab-client02";
            tenant = "client";
          }
          {
            kind = "host";
            name = "clab-streaming01";
            tenant = "streaming";
          }
          {
            kind = "host";
            name = "hostile-node01";
            tenant = "hostile";
          }
        ];
        prefixes = [
          {
            ipv4 = "10.50.10.0/24";
            ipv6 = "fd42:dead:feed:10::/64";
            kind = "tenant";
            name = "mgmt";
          }
          {
            ipv4 = "10.50.15.0/24";
            ipv6 = "fd42:dead:feed:15::/64";
            kind = "tenant";
            name = "admin";
          }
          {
            ipv4 = "10.50.20.0/24";
            ipv6 = "fd42:dead:feed:20::/64";
            kind = "tenant";
            name = "client";
            routedPrefixes = [
              {
                allocation = "runtime";
                family = "ipv6";
                name = "clab-client-public";
                prefixPostfix = "4445";
                delegatedPrefixLength = 64;
                perTenantPrefixLength = 64;
                slot = 0;
                sourceFile = "/run/secrets/access-node-ipv6-prefix-esp-clab-router-access-client";
              }
            ];
          }
          {
            ipv4 = "10.50.30.0/24";
            ipv6 = "fd42:dead:feed:30::/64";
            kind = "tenant";
            name = "dmz";
          }
          {
            ipv4 = "10.50.50.0/24";
            ipv6 = "fd42:dead:feed:50::/64";
            kind = "tenant";
            name = "streaming";
          }
          {
            ipv4 = "10.70.10.0/24";
            ipv6 = "fd42:dead:feed:70::/64";
            kind = "tenant";
            name = "hostile";
            routedPrefixes = [
              {
                allocation = "runtime";
                family = "ipv6";
                name = "hostile-public";
                delegatedPrefixLength = 64;
                perTenantPrefixLength = 64;
                slot = 0;
                sourceFile = "/run/secrets/access-node-ipv6-prefix-esp-clab-router-access-hostile";
              }
            ];
          }
        ];
      };
      pools = {
        overlay = {
          ipv4 = {
            offsetStart = 10;
            perNodePrefixLength = 32;
            prefix = "100.96.10.0/24";
          };
          ipv6 = {
            offsetStart = 10;
            perNodePrefixLength = 128;
            prefix = "fd42:dead:beef:ee::/64";
          };
        };
        loopback = {
          ipv4 = "10.59.0.0/24";
          ipv6 = "fd42:dead:feed:1900::/118";
        };
        p2p = {
          ipv4 = "10.50.0.0/24";
          ipv6 = "fd42:dead:feed:1000::/118";
        };
      };
      topology = {
        links = [
          [
            "clab-router-core-simulated-isp"
            "clab-router-upstream"
          ]
          [
            "clab-router-core-nebula"
            "clab-router-upstream"
          ]
          [
            "clab-router-upstream"
            "clab-router-policy"
          ]
          [
            "clab-router-policy"
            "clab-router-downstream"
          ]
          [
            "clab-router-downstream"
            "clab-router-access-admin"
          ]
          [
            "clab-router-downstream"
            "clab-router-access-client"
          ]
          [
            "clab-router-downstream"
            "clab-router-access-dmz"
          ]
          [
            "clab-router-downstream"
            "clab-router-access-hostile"
          ]
          [
            "clab-router-downstream"
            "clab-router-access-mgmt"
          ]
          [
            "clab-router-downstream"
            "clab-router-access-streaming"
          ]
        ];
        nodes = {
          clab-router-access-admin = {
            attachments = [
              {
                kind = "tenant";
                name = "admin";
              }
            ];
            role = "access";
          };
          clab-router-access-client = {
            attachments = [
              {
                kind = "tenant";
                name = "client";
              }
            ];
            role = "access";
          };
          clab-router-access-dmz = {
            attachments = [
              {
                kind = "tenant";
                name = "dmz";
              }
            ];
            role = "access";
          };
          clab-router-access-hostile = {
            attachments = [
              {
                kind = "tenant";
                name = "hostile";
              }
            ];
            role = "access";
          };
          clab-router-access-mgmt = {
            attachments = [
              {
                kind = "tenant";
                name = "mgmt";
              }
            ];
            role = "access";
          };
          clab-router-access-streaming = {
            attachments = [
              {
                kind = "tenant";
                name = "streaming";
              }
            ];
            role = "access";
          };
          clab-router-core-nebula = {
            attachments = [
              {
                kind = "tenant";
                name = "client";
              }
            ];
            role = "core";
            uplinks = {
              east-west = {
                ipv4 = [
                  "10.20.10.0/24"
                  "10.20.15.0/24"
                  "10.20.20.0/24"
                  "10.20.30.0/24"
                  "10.20.50.0/24"
                  "10.90.10.0/24"
                  "0.0.0.0/0"
                ];
                ipv6 = [
                  "fd42:dead:beef:10::/64"
                  "fd42:dead:beef:15::/64"
                  "fd42:dead:beef:20::/64"
                  "fd42:dead:beef:30::/64"
                  "fd42:dead:beef:50::/64"
                  "fd42:dead:cafe:10::/64"
                  "::/0"
                ];
              };
            };
          };
          clab-router-core-simulated-isp = {
            role = "core";
            uplinks = {
              wan = {
                egress.ipv6.translation = {
                  mode = "nat66";
                  warning = "NAT66 is intentionally modeled only for explicit simulated or otherwise non-routed IPv6 uplinks; routed public-prefix tenants must stay routed, not masqueraded.";
                };
                ipv4 = [ "0.0.0.0/0" ];
                ipv6 = [ "::/0" ];
              };
            };
          };
          clab-router-downstream = {
            role = "downstream-selector";
          };
          clab-router-policy = {
            role = "policy";
          };
          clab-router-upstream = {
            role = "upstream-selector";
          };
        };
      };
      transport = {
        overlays = [
          {
            mustTraverse = [ "policy" ];
            name = "east-west";
            peerSites = [
              "esp.nixos"
              "esp.hetz"
            ];
            terminateOn = "clab-router-core-nebula";
            underlayAccess = {
              kind = "tenant";
              name = "client";
            };
            underlayTrafficTypes = [ "nebula" ];
          }
        ];
      };
    };
  };
}
