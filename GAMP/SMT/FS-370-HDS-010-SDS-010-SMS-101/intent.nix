{
  "mini-smt" = {
    "per-lane-return-path" = {
      communicationContract = {
        interfaceTags = {
          external-testnet = "testnet";
          tenant-client = "client";
        };
        relations = [
          {
            id = "FS-370-HDS-010-SDS-010-SMS-101__mini-policy-ds-return-path";
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
            ipv4 = "10.60.20.0/24";
            ipv6 = "fd42:mini:370:60::/64";
          }
        ];
      };
      pools = {
        loopback = {
          ipv4 = "10.60.0.0/24";
          ipv6 = "fd42:mini:370:60:ff::/118";
        };
        p2p = {
          ipv4 = "10.60.255.0/24";
          ipv6 = "fd42:mini:370:60:fe::/118";
        };
      };
      topology = {
        links = [
          [ "client-edge" "provider-edge" ]
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
          provider-edge = {
            role = "core";
            uplinks = {
              testnet = {
                ipv4 = [ "10.20.0.0/24" ];
                ipv6 = [ "fd42:mini:370:60:20::/64" ];
              };
            };
          };
        };
      };
    };
  };
}
