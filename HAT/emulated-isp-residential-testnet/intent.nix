{
  esp0xdeadbeef = {
    site-a = {
      communicationContract = {
        interfaceTags = {
          external-testnet-routed-isp = "testnet-routed-isp";
          external-testnet-host-isp = "testnet-host-isp";
          tenant-client = "client";
        };
        trafficTypes = [ ];
        services = [ ];
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
