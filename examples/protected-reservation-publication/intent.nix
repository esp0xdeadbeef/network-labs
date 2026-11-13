{
  # 01-single-wan: Baseline single-WAN example with three tenants,
  # DNS service, and basic egress policy.
  esp0xdeadbeef = {
    site-a = {
      communicationContract = {
        interfaceTags = {
          external-wan = "wan";
          service-site-dns = "site-dns";
          tenant-admin = "admin";
          tenant-client = "client";
          tenant-mgmt = "mgmt";
        };
        relations = [
          {
            action = "allow";
            from = {
              kind = "tenant-set";
              members = [
                "mgmt"
                "admin"
                "client"
              ];
            };
            id = "allow-tenants-to-site-dns";
            returnBehavior = "one-way";
            priority = 5;
            to = {
              kind = "service";
              name = "site-dns";
            };
            trafficType = "dns";
          }
          # Public ingress to the site resolver. FS-790 validates each emitted
          # public-ingress row for public surface, allowed source scope and
          # exposure identity, so the example has to model one.
          {
            action = "allow";
            from = {
              kind = "external";
              scope = "s-router-core-wan";
            };
            id = "allow-wan-to-site-dns";
            priority = 10;
            publicIngressTupleAuthority = {
              sourceScope = "internet";
              publicSurface = "wan";
              targetService = "site-dns";
              targetEndpoint = "s-sigma";
              targetPort = 53;
              returnBehavior = "stateful-return";
              sourcePreservation = "rewritten";
              translationMode = "napt";
              hairpin = "not-modeled";
              asymmetricRouting = "not-allowed";
              tuples = [
                {
                  protocol = "udp";
                  publicPort = 53;
                }
                {
                  protocol = "tcp";
                  publicPort = 53;
                }
              ];
            };
            to = {
              kind = "service";
              name = "site-dns";
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
              ];
            };
            id = "allow-tenants-to-wan";
            returnBehavior = "one-way";
            priority = 100;
            to = {
              kind = "external";
            };
            trafficType = "any";
          }
        ];
        services = [
          {
            name = "site-dns";
            providers = [ "s-sigma" ];
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
          # The core's upstream selector gates its lanes with BFD, so the
          # intent must declare the BFD traffic type (udp/3784). Without it the
          # renderer fails closed rather than emitting a lane-health allow it
          # cannot justify.
          {
            match = [
              {
                dports = [ 3784 ];
                family = "any";
                proto = "udp";
              }
            ];
            name = "bfd";
          }
        ];
      };
      ownership = {
        endpoints = [
          {
            kind = "host";
            name = "s-sigma";
            tenant = "mgmt";
          }
        ];
        prefixes = [
          {
            ipv4 = "10.20.10.0/24";
            ipv6 = "fd42:dead:beef:10::/64";
            kind = "tenant";
            name = "mgmt";
            dnsDomain = "lan.";
          }
          {
            ipv4 = "10.20.15.0/24";
            ipv6 = "fd42:dead:beef:15::/64";
            kind = "tenant";
            name = "admin";
            dnsDomain = "lan.";
          }
          {
            ipv4 = "10.20.20.0/24";
            ipv6 = "fd42:dead:beef:20::/64";
            kind = "tenant";
            name = "client";
            dnsDomain = "lan.";
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
            "s-router-core-wan"
            "s-router-upstream-selector"
          ]
          [
            "s-router-upstream-selector"
            "s-router-policy"
          ]
          [
            "s-router-policy"
            "s-router-downstream-selector"
          ]
          [
            "s-router-downstream-selector"
            "s-router-access-client"
          ]
          [
            "s-router-downstream-selector"
            "s-router-access-admin"
          ]
          [
            "s-router-downstream-selector"
            "s-router-access-mgmt"
          ]
        ];
        nodes = {
          s-router-access-admin = {
            selects = [
              "wan"
            ];

            attachments = [
              {
                kind = "tenant";
                name = "admin";
              }
            ];
            role = "access";
          };
          s-router-access-client = {
            selects = [
              "wan"
            ];

            attachments = [
              {
                kind = "tenant";
                name = "client";
              }
            ];
            role = "access";
          };
          s-router-access-mgmt = {
            selects = [
              "wan"
            ];

            attachments = [
              {
                kind = "tenant";
                name = "mgmt";
              }
            ];
            role = "access";
          };
          s-router-core-wan = {
            role = "core";
            uplinks = {
              wan = {
                ipv4 = [ "0.0.0.0/0" ];
                ipv6 = [ "::/0" ];
                egress = {
                  ipv4 = {
                    translation = {
                      mode = "nat44";
                    };
                  };
                };
              };
            };
          };
          s-router-downstream-selector = {
            role = "downstream-selector";
          };
          s-router-policy = {
            role = "policy";
          };
          s-router-upstream-selector = {
            role = "upstream-selector";
          };
        };
      };
    };
  };
}
