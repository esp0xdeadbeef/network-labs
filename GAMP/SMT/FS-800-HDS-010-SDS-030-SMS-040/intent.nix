{
  "mini-smt" = {
    "fs_800_hds_010_sds_030_sms_040" = {
      communicationContract = {
        interfaceTags = {
          external-testnet = "testnet";
          tenant-client = "client";
        };
        relations = [
          {
            id = "FS-800-HDS-010-SDS-030-SMS-040__mini-client-to-testnet";
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
            ipv4 = "10.39.10.0/24";
            ipv6 = "fd42:mini:39::/64";
          }
        ];
      };
      pools = {
        loopback = {
          ipv4 = "10.39.0.0/24";
          ipv6 = "fd42:mini:39:ff::/118";
        };
        p2p = {
          ipv4 = "10.0.39.0/30";
          ipv6 = "fd42:mini:39:fe::/126";
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
                ipv4 = [ "10.39.0.0/24" ];
                ipv6 = [ "fd42:mini:39:20::/64" ];
              };
            };
          };
        };
      };
    };
  };
}
