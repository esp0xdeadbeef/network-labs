{
  "mini-smt" = {
    "lane-egress-binding" = {
      communicationContract = {
        interfaceTags = {
          external-testnet = "testnet";
          tenant-client = "client";
        };
        relations = [
          {
            id = "FS-370-HDS-010-SDS-010-SMS-050__mini-client-to-testnet-uplink";
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
            ipv4 = "10.50.20.0/24";
            ipv6 = "fd42:mini:370:50::/64";
          }
        ];
      };
      pools = {
        loopback = {
          ipv4 = "10.50.0.0/24";
          ipv6 = "fd42:mini:370:50:ff::/118";
        };
        p2p = {
          ipv4 = "10.50.255.0/24";
          ipv6 = "fd42:mini:370:50:fe::/118";
        };
      };
      topology = {
        links = [
          [
            "client-edge"
            "testnet-edge"
          ]
        ];
        nodes = {
          client-edge = {
            role = "access";
            attachments = [
              {
                kind = "tenant";
                name = "client";
              }
            ];
          };
          testnet-edge = {
            role = "core";
            uplinks = {
              testnet = {
                ipv4 = [ "10.20.0.0/24" ];
                ipv6 = [ "fd42:mini:370:50:20::/64" ];
              };
            };
          };
        };
      };
    };
  };
}
