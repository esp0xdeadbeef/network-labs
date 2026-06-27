{
  "mini-smt" = {
    "decision-type-preservation" = {
      communicationContract = {
        interfaceTags = {
          external-testnet = "testnet";
          tenant-client = "client";
        };
        relations = [
          {
            id = "FS-500-HDS-010-SDS-010-SMS-020__mini-decision-type-client-to-testnet";
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
            ipv4 = "10.70.20.0/24";
            ipv6 = "fd42:mini:500:70::/64";
          }
        ];
      };
      pools = {
        loopback = {
          ipv4 = "10.70.0.0/24";
          ipv6 = "fd42:mini:500:70:ff::/118";
        };
        p2p = {
          ipv4 = "10.70.255.0/24";
          ipv6 = "fd42:mini:500:70:fe::/118";
        };
      };
      topology = {
        links = [
          [ "client-edge" "testnet-edge" ]
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
                ipv6 = [ "fd42:mini:500:70:20::/64" ];
              };
            };
          };
        };
      };
    };
  };
}
