{
  "mini-smt" = {
    "dns-resolver-config" = {
      communicationContract = {
        interfaceTags = {
          external-testnet = "testnet";
          tenant-client = "client";
        };
        relations = [
          {
            id = "FS-540-HDS-010-SDS-010-SMS-020__mini-dns-client-to-testnet";
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
            ipv4 = "10.54.10.0/24";
            ipv6 = "fd42:mini:540::/64";
          }
        ];
      };
      pools = {
        loopback = {
          ipv4 = "10.54.0.0/24";
          ipv6 = "fd42:mini:540:ff::/118";
        };
        p2p = {
          ipv4 = "10.54.255.0/24";
          ipv6 = "fd42:mini:540:fe::/118";
        };
      };
      topology = {
        links = [
          [
            "access-dns"
            "resolver-node"
          ]
        ];
        nodes = {
          access-dns = {
            role = "access";
            attachments = [
              {
                kind = "tenant";
                name = "client";
              }
            ];
          };
          resolver-node = {
            role = "core";
            uplinks = {
              testnet = {
                ipv4 = [ "10.20.0.0/24" ];
                ipv6 = [ "fd42:mini:540:20::/64" ];
              };
            };
          };
        };
      };
    };
  };
}
