{
  esp = {
    nixos = {
      communicationContract = {
        interfaceTags = {
          external-east-west = "east-west";
          external-isp-a = "isp-a";
          external-isp-b = "isp-b";
          service-dmz-nebula = "dmz-nebula";
          service-site-dns-mgmt = "site-dns-mgmt";
          tenant-admin = "admin";
          tenant-client = "client";
          tenant-client2 = "client2";
          tenant-dmz = "dmz";
          tenant-mgmt = "mgmt";
          tenant-streaming = "streaming";
        };
        relations = [
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [ "mgmt" ];
            };
            id = "allow-mgmt-internal";
            priority = 10;
            to = {
              kind = "tenant-set";
              members = [
                "mgmt"
                "admin"
                "client"
                "client2"
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
                "client2"
                "dmz"
              ];
            };
            id = "allow-nixos-tenants-to-mgmt-dns";
            priority = 15;
            to = {
              kind = "service";
              name = "site-dns-mgmt";
            };
            trafficType = "dns";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [ "mgmt" ];
            };
            id = "allow-mgmt-dns-to-uplinks";
            priority = 16;
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
                "mgmt"
                "admin"
                "client"
                "client2"
              ];
            };
            id = "deny-nixos-dns-to-uplinks";
            priority = 20;
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
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [
                "mgmt"
                "admin"
                "client"
                "client2"
              ];
            };
            id = "allow-tenants-to-uplinks";
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
              kind = "tenant-set";
              members = [
                "mgmt"
                "admin"
                "client"
                "client2"
              ];
            };
            id = "allow-core-tenants-to-east-west";
            priority = 110;
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
            id = "allow-east-west-to-nixos-mgmt-dns";
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
              kind = "tenant-set";
              members = [
                "client"
                "client2"
              ];
            };
            id = "allow-nixos-client-to-streaming-chromecast";
            priority = 18;
            to = {
              kind = "tenant-set";
              members = [ "streaming" ];
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [ "streaming" ];
            };
            id = "allow-nixos-streaming-to-mgmt-dns";
            priority = 19;
            to = {
              kind = "service";
              name = "site-dns-mgmt";
            };
            trafficType = "dns";
          }
          {
            action = "deny";
            from = {
              kind = "tenant-set";
              members = [ "streaming" ];
            };
            id = "deny-nixos-streaming-dns-to-uplinks";
            priority = 22;
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
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [ "streaming" ];
            };
            id = "allow-nixos-streaming-to-uplinks";
            priority = 103;
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
            id = "allow-nixos-nebula-underlay-to-uplinks";
            priority = 118;
            to = {
              kind = "external";
              uplinks = [
                "isp-a"
                "isp-b"
              ];
            };
            trafficType = "nebula";
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
        ];
        trafficTypes = [
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
        ];
      };
      ownership = {
        endpoints = [
          {
            kind = "host";
            name = "nebula01";
            tenant = "dmz";
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
            ipv4 = "10.20.40.0/24";
            ipv6 = "fd42:dead:beef:40::/64";
            kind = "tenant";
            name = "client2";
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
        ];
      };
      pools = {
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
            "nixos-router-up-sel"
          ]
          [
            "nixos-router-core-isp-b"
            "nixos-router-up-sel"
          ]
          [
            "nixos-router-up-sel"
            "nixos-router-policy"
          ]
          [
            "nixos-router-policy"
            "nixos-router-down-sel"
          ]
          [
            "nixos-router-down-sel"
            "nixos-router-access-client"
          ]
          [
            "nixos-router-down-sel"
            "nixos-router-access-admin"
          ]
          [
            "nixos-router-down-sel"
            "nixos-router-access-mgmt"
          ]
          [
            "nixos-router-core-nebula"
            "nixos-router-up-sel"
          ]
          [
            "nixos-router-down-sel"
            "nixos-router-access-client2"
          ]
          [
            "nixos-router-down-sel"
            "nixos-router-access-dmz"
          ]
          [
            "nixos-router-down-sel"
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
          nixos-router-access-client2 = {
            attachments = [
              {
                kind = "tenant";
                name = "client2";
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
                ipv4 = [ "0.0.0.0/0" ];
                ipv6 = [ "::/0" ];
              };
            };
          };
          nixos-router-core-isp-b = {
            role = "core";
            uplinks = {
              isp-b = {
                ipv4 = [ "0.0.0.0/0" ];
                ipv6 = [ "::/0" ];
              };
            };
          };
          nixos-router-core-nebula = {
            role = "core";
            uplinks = {
              east-west = {
                ipv4 = [
                  "10.60.10.0/24"
                  "10.70.10.0/24"
                ];
                ipv6 = [
                  "fd42:dead:feed:10::/64"
                  "fd42:dead:feed:70::/64"
                ];
              };
            };
          };
          nixos-router-down-sel = {
            role = "downstream-selector";
          };
          nixos-router-policy = {
            role = "policy";
          };
          nixos-router-up-sel = {
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
          }
        ];
      };
    };
    hetz = {
      communicationContract = {
        interfaceTags = {
          external-east-west = "east-west";
          external-wan = "wan";
          service-hetz-dns-dmz = "hetz-dns-dmz";
          tenant-client = "client";
          tenant-dmz = "dmz";
        };
        relations = [
          {
            action = "allow";
            from = {
              kind = "external";
              name = "east-west";
            };
            id = "allow-east-west-to-hetz-client";
            priority = 131;
            to = {
              kind = "tenant-set";
              members = [ "client" ];
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              name = "east-west";
            };
            id = "allow-east-west-to-hetz-dmz-dns";
            priority = 128;
            to = {
              kind = "service";
              name = "hetz-dns-dmz";
            };
            trafficType = "dns";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              name = "east-west";
            };
            id = "allow-east-west-to-hetz-dmz-nebula";
            priority = 132;
            to = {
              kind = "tenant-set";
              members = [ "dmz" ];
            };
            trafficType = "nebula";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [ "client" ];
            };
            id = "allow-hetz-client-to-dmz-dns";
            priority = 110;
            to = {
              kind = "service";
              name = "hetz-dns-dmz";
            };
            trafficType = "dns";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [ "client" ];
            };
            id = "allow-hetz-client-to-east-west";
            priority = 130;
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
              members = [ "client" ];
            };
            id = "allow-hetz-client-to-wan";
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
              kind = "service";
              name = "hetz-dns-dmz";
            };
            id = "allow-hetz-dmz-dns-to-wan";
            priority = 111;
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
              members = [ "dmz" ];
            };
            id = "allow-hetz-dmz-nebula-to-east-west";
            priority = 129;
            to = {
              kind = "external";
              name = "east-west";
            };
            trafficType = "nebula";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [ "dmz" ];
            };
            id = "allow-hetz-dmz-to-wan";
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
              kind = "external";
              uplinks = [ "wan" ];
            };
            id = "allow-hetz-wan-to-dmz-nebula";
            priority = 128;
            to = {
              kind = "service";
              name = "dmz-nebula";
            };
            trafficType = "nebula";
          }
          {
            action = "deny";
            from = {
              kind = "tenant-set";
              members = [ "client" ];
            };
            id = "deny-hetz-client-dns-to-wan";
            priority = 99;
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
            id = "allow-hetz-nebula-underlay-to-wan";
            priority = 133;
            to = {
              kind = "external";
              uplinks = [ "wan" ];
            };
            trafficType = "nebula";
          }
        ];
        services = [
          {
            name = "dmz-nebula";
            providers = [ "hetz-router-lighthouse" ];
            trafficType = "nebula";
          }
          {
            name = "hetz-dns-dmz";
            providers = [ "hetz-dns-dmz" ];
            trafficType = "dns";
          }
        ];
        trafficTypes = [
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
        ];
      };
      ownership = {
        endpoints = [
          {
            kind = "host";
            name = "hetz-router-lighthouse";
            tenant = "dmz";
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
              }
            ];
          }
        ];
      };
      pools = {
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
        links = [
          [
            "hetz-router-core"
            "hetz-router-up-sel"
          ]
          [
            "hetz-router-nebula-core"
            "hetz-router-up-sel"
          ]
          [
            "hetz-router-up-sel"
            "hetz-router-policy"
          ]
          [
            "hetz-router-policy"
            "hetz-router-down-sel"
          ]
          [
            "hetz-router-down-sel"
            "hetz-router-access-dmz"
          ]
          [
            "hetz-router-down-sel"
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
          hetz-router-down-sel = {
            role = "downstream-selector";
          };
          hetz-router-nebula-core = {
            role = "core";
            uplinks = {
              east-west = {
                ipv4 = [ ];
                ipv6 = [ ];
              };
            };
          };
          hetz-router-policy = {
            role = "policy";
          };
          hetz-router-up-sel = {
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
          }
        ];
      };
    };
    clab = {
      communicationContract = {
        interfaceTags = {
          external-east-west = "east-west";
          external-wan = "wan";
          service-nixos-mgmt-dns = "nixos-mgmt-dns";
          tenant-branch = "branch";
          tenant-hostile = "hostile";
        };
        relations = [
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [ "branch" ];
            };
            id = "allow-branch-dns-to-nixos-mgmt-dns";
            priority = 89;
            to = {
              kind = "service";
              name = "nixos-mgmt-dns";
            };
            trafficType = "dns";
          }
          {
            action = "deny";
            from = {
              kind = "tenant-set";
              members = [ "branch" ];
            };
            id = "deny-branch-dns-to-wan";
            priority = 90;
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
              members = [ "branch" ];
            };
            id = "allow-branch-to-wan";
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
              kind = "tenant-set";
              members = [ "branch" ];
            };
            id = "allow-branch-to-east-west";
            priority = 110;
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
              members = [ "hostile" ];
            };
            id = "allow-hostile-dns-to-hetz-public-dns";
            priority = 114;
            to = {
              kind = "service";
              name = "hetz-public-dns";
            };
            trafficType = "dns";
          }
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [ "hostile" ];
            };
            id = "allow-hostile-dns-to-east-west";
            priority = 115;
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
            id = "allow-hostile-to-east-west";
            priority = 116;
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
            id = "allow-east-west-to-branch";
            priority = 120;
            to = {
              kind = "tenant-set";
              members = [ "branch" ];
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              name = "east-west";
            };
            id = "allow-east-west-to-hostile";
            priority = 121;
            to = {
              kind = "tenant-set";
              members = [ "hostile" ];
            };
            trafficType = "any";
          }
          {
            action = "allow";
            from = {
              kind = "external";
              name = "east-west";
            };
            id = "allow-clab-nebula-underlay-to-wan";
            priority = 117;
            to = {
              kind = "external";
              uplinks = [ "wan" ];
            };
            trafficType = "nebula-storage";
          }
        ];
        services = [
          {
            name = "hetz-public-dns";
            providers = [ "hetz-dns-dmz" ];
            trafficType = "dns";
          }
          {
            name = "nixos-mgmt-dns";
            providers = [ "site-dns-mgmt" ];
            trafficType = "dns";
          }
        ];
        trafficTypes = [
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
            name = "nebula-storage";
          }
        ];
      };
      ownership = {
        prefixes = [
          {
            ipv4 = "10.60.10.0/24";
            ipv6 = "fd42:dead:feed:10::/64";
            kind = "tenant";
            name = "branch";
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
                name = "branch-hostile-public";
              }
            ];
          }
        ];
      };
      pools = {
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
            "clab-router-core-nebula"
            "clab-router-up-sel"
          ]
          [
            "clab-router-core-simulated-isp"
            "clab-router-up-sel"
          ]
          [
            "clab-router-up-sel"
            "clab-router-policy"
          ]
          [
            "clab-router-policy"
            "clab-router-down-sel"
          ]
          [
            "clab-router-down-sel"
            "clab-router-access-branch"
          ]
          [
            "clab-router-down-sel"
            "clab-router-access-hostile"
          ]
        ];
        nodes = {
          clab-router-access-branch = {
            attachments = [
              {
                kind = "tenant";
                name = "branch";
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
          clab-router-core-nebula = {
            role = "core";
            uplinks = {
              east-west = {
                ipv4 = [ "0.0.0.0/0" ];
                ipv6 = [ "::/0" ];
              };
            };
          };
          clab-router-core-simulated-isp = {
            role = "core";
            uplinks = {
              wan = {
                ipv4 = [ "0.0.0.0/0" ];
                ipv6 = [ "::/0" ];
              };
            };
          };
          clab-router-down-sel = {
            role = "downstream-selector";
          };
          clab-router-policy = {
            role = "policy";
          };
          clab-router-up-sel = {
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
          }
        ];
      };
    };
  };
}
