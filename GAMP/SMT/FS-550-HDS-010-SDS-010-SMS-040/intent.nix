{
  "mini-smt" = {
    "fs_550_hds_010_sds_010_sms_040" = {
      communicationContract = {
        interfaceTags = {
          external-testnet = "testnet";
          tenant-client = "client";
        };
        relations = [
          {
            id = "FS-550-HDS-010-SDS-010-SMS-040__mini-client-to-testnet";
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
            ipv4 = "10.19.10.0/24";
            ipv6 = "fd42:mini:19::/64";
          }
        ];
      };
      pools = {
        loopback = {
          ipv4 = "10.19.0.0/24";
          ipv6 = "fd42:mini:19:ff::/118";
        };
        p2p = {
          ipv4 = "10.0.19.0/30";
          ipv6 = "fd42:mini:19:fe::/126";
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
                ipv4 = [ "10.19.0.0/24" ];
                ipv6 = [ "fd42:mini:19:20::/64" ];
              };
            };
          };
        };
      };
    };
  };
}
