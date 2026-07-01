{
  "mini-smt" = {
    "FS-500-HDS-010-SDS-010-SMS-040" = {
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
              uplinks = [ "testnet" ];
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
            ipv6 = "fd42:500::/64";
          }
        ];
      };
      pools = {
        loopback = {
          ipv4 = "10.50.0.0/24";
          ipv6 = "fd42:500:ff::/118";
        };
        p2p = {
          ipv4 = "10.50.240.0/28";
          ipv6 = "fd42:500:fe::/124";
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
            role = "access";
            attachments = [
              {
                kind = "tenant";
                name = "client";
              }
            ];
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
            role = "core";
            uplinks = {
              testnet = {
                ipv4 = [ "10.20.0.0/24" ];
                ipv6 = [ "fd42:500:20::/64" ];
              };
            };
          };
        };
      };
    };
  };
}
