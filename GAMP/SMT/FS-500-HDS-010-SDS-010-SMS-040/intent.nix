{
  "mini-smt" = {
    "p2p-next-hop" = {
      communicationContract = {
        interfaceTags = {
          external-testnet = "testnet";
          tenant-client = "client";
        };
        relations = [
          {
            id = "FS-500-HDS-010-SDS-010-SMS-040__mini-p2p-route-to-peer";
            action = "allow";
            from = {
              kind = "tenant";
              name = "client";
            };
            to = {
              kind = "external";
              name = "testnet";
            };
            trafficType = "any";
            priority = 100;
          }
        ];
        services = [ ];
        trafficTypes = [
          {
            name = "any";
            match = [
              {
                family = "any";
                proto = "any";
              }
            ];
          }
        ];
      };
      ownership = {
        prefixes = [
          {
            kind = "tenant";
            name = "client";
            ipv4 = "10.50.10.0/24";
            ipv6 = "fd42:mini:500::/64";
          }
        ];
      };
      pools = {
        loopback = {
          ipv4 = "10.50.0.0/24";
          ipv6 = "fd42:mini:500:ff::/118";
        };
        p2p = {
          ipv4 = "10.0.0.0/30";
          ipv6 = "fd42:mini:500:fe::/126";
        };
      };
      topology = {
        links = [
          [
            "router-a"
            "router-b"
          ]
        ];
        nodes = {
          router-a = {
            role = "access";
            attachments = [
              {
                kind = "tenant";
                name = "client";
              }
            ];
          };
          router-b = {
            role = "core";
            uplinks = {
              testnet = {
                ipv4 = [ "10.20.0.0/24" ];
                ipv6 = [ "fd42:mini:500:20::/64" ];
              };
            };
          };
        };
      };
    };
  };
}
