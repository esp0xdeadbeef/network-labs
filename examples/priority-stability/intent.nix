{
  esp0xdeadbeef = {
    site-stable = {
      communicationContract = {
        interfaceTags = {
          external-wan = "wan";
          service-dns-site = "dns-site";
          tenant-admin = "admin";
          tenant-clients = "clients";
          tenant-mgmt = "mgmt";
        };
        relations = [
          {
            action = "allow";
            from = {
              kind = "tenant";
              name = "admin";
            };
            id = "first-same-priority";
            returnBehavior = "one-way";
            priority = 100;
            to = {
              kind = "service";
              name = "dns-site";
            };
            trafficType = "dns";
          }
          {
            action = "deny";
            from = {
              kind = "tenant";
              name = "clients";
            };
            id = "second-same-priority";
            priority = 100;
            to = {
              kind = "service";
              name = "dns-site";
            };
            trafficType = "dns";
          }
          {
            action = "deny";
            from = {
              kind = "tenant";
              name = "admin";
            };
            id = "deny-admin-dns-to-wan";
            priority = 90;
            to = {
              kind = "external";
              uplinks = [ "wan" ];
            };
            trafficType = "dns";
          }
          {
            action = "allow";
            from = {
              kind = "tenant";
              name = "admin";
            };
            id = "allow-admin-to-wan";
            returnBehavior = "one-way";
            priority = 200;
            to = {
              kind = "external";
              uplinks = [ "wan" ];
            };
            trafficType = "any";
          }
        ];
        services = [
          {
            name = "dns-site";
            providers = [ "stable-dns" ];
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
            name = "stable-dns";
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
            name = "clients";
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
            "s-router-core"
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
            "s-router-access-mgmt"
          ]
          [
            "s-router-downstream-selector"
            "s-router-access-admin"
          ]
          [
            "s-router-downstream-selector"
            "s-router-access-clients"
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
          s-router-access-clients = {
            attachments = [
              {
                kind = "tenant";
                name = "clients";
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
          s-router-core = {
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
