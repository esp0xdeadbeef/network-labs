{
  mini-smt = {
    FS-500-HDS-010-SDS-010-SMS-040 = {
      communicationContract = {
        interfaceTags = {
          router-a = "router-a";
          router-b = "router-b";
        };
        relations = [
          {
            id = "FS-500-HDS-010-SDS-010-SMS-040__mini-p2p-route-to-peer";
            action = "route";
            from = {
              kind = "router";
              name = "router-a";
            };
            to = {
              kind = "prefix";
              prefix = "10.20.0.0/24";
            };
            via = {
              link = "p2p-ab";
              nextHop4 = "10.0.0.1";
            };
            priority = 100;
          }
        ];
        services = [ ];
        trafficTypes = [ ];
      };
      expectedRoutes = [
        {
          sourceTarget = "router-a";
          link = "p2p-ab";
          dst = "10.20.0.0/24";
          via4 = "10.0.0.1";
        }
      ];
      links = {
        p2p-ab = {
          kind = "p2p";
          endpoints = [
            {
              target = "router-a";
              interface = "p2p-ab";
              address4 = "10.0.0.0";
            }
            {
              target = "router-b";
              interface = "p2p-ab";
              address4 = "10.0.0.1";
            }
          ];
        };
      };
      pools = {
        loopback = {
          ipv4 = "10.1.0.0/24";
          ipv6 = "fd42:01f4:ff::/118";
        };
        p2p = {
          ipv4 = "10.1.255.0/24";
          ipv6 = "fd42:01f4:fe::/118";
        };
      };
      topology = {
        links = [
          [
            "router-a"
            "downstream-selector"
          ]
          [
            "downstream-selector"
            "policy"
          ]
          [
            "policy"
            "upstream-selector"
          ]
          [
            "upstream-selector"
            "router-b"
          ]
        ];
        nodes = {
          router-a = {
            role = "router";
            interfaces = {
              p2p-ab = {
                address4 = "10.0.0.0";
                prefixLength4 = 31;
              };
            };
          };
          downstream-selector = {
            role = "downstream-selector";
          };
          policy = {
            role = "policy";
          };
          upstream-selector = {
            role = "upstream-selector";
          };
          router-b = {
            role = "router";
            interfaces = {
              p2p-ab = {
                address4 = "10.0.0.1";
                prefixLength4 = 31;
              };
            };
          };
        };
      };
    };
  };
}
