{
  esp0xdeadbeef = {
    site-a = {
      communicationContract = {
        interfaceTags = {
          external-testnet-routed-isp = "testnet-routed-isp";
          external-testnet-host-isp = "testnet-host-isp";
          service-hat-printer-admin = "hat-printer-admin";
          service-hat-printer-ipp = "hat-printer-ipp";
          service-hat-receiver-control = "hat-receiver-control";
          service-hat-receiver-discovery = "hat-receiver-discovery";
          tenant-client = "client";
        };
        trafficTypes = [
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
        relations = [
          {
            action = "allow";
            from = {
              kind = "tenant";
              name = "client";
            };
            id = "allow-client-to-testnet-routed-isp";
            priority = 100;
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
              name = "client";
            };
            id = "allow-client-to-testnet-host-isp";
            priority = 110;
            to = {
              kind = "external";
              uplinks = [ "testnet-host-isp" ];
            };
            trafficType = "any";
          }
        ];
      };

      ownership = {
        endpoints = [
          {
            kind = "host";
            name = "nixos-printer01";
            tenant = "client";
          }
          {
            kind = "host";
            name = "nixos-receiver01";
            tenant = "client";
          }
        ];
        prefixes = [
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
          ipv4 = "10.19.44.0/24";
          ipv6 = "fd42:dead:beef:1944::/118";
        };
        p2p = {
          ipv4 = "10.10.44.0/24";
          ipv6 = "fd42:dead:beef:1044::/118";
        };
      };

      topology = {
        links = [
          [
            "s-router-core-testnet-routed-isp"
            "s-router-upstream-selector"
          ]
          [
            "s-router-core-testnet-host-isp"
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
        ];
        nodes = {
          s-router-access-client = {
            attachments = [
              {
                kind = "tenant";
                name = "client";
              }
            ];
            role = "access";
          };
          s-router-core-testnet-routed-isp = {
            role = "core";
            uplinks = {
              testnet-routed-isp = {
                ipv4 = [ "203.0.113.0/30" ];
                ipv6 = [ "2001:db8:113::/48" ];
              };
            };
          };
          s-router-core-testnet-host-isp = {
            role = "core";
            uplinks = {
              testnet-host-isp = {
                ipv4 = [ "203.0.113.4/32" ];
                ipv6 = [ "2001:db8:113:64::/64" ];
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
