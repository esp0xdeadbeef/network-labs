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
              name = "wan";
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
            attachments = [
              {
                kind = "tenant";
                name = "admin";
              }
            ];
            role = "access";
          };
          s-router-access-client = {
            attachments = [
              {
                kind = "tenant";
                name = "client";
              }
            ];
            role = "access";
          };
          s-router-access-mgmt = {
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
