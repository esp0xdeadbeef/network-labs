{
  "mini-smt" = {
    "fs_960_hds_010_sds_016_sms_040" = {
      communicationContract = {
        interfaceTags = {
          external-testnet = "testnet";
          tenant-client = "client";
        };
        relations = [
          {
            id = "FS-960-HDS-010-SDS-016-SMS-040__mini-client-to-testnet";
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
            ipv4 = "10.47.10.0/24";
            ipv6 = "fd42:mini:47::/64";
          }
        ];
      };
      pools = {
        loopback = {
          ipv4 = "10.47.0.0/24";
          ipv6 = "fd42:mini:47:ff::/118";
        };
        p2p = {
          ipv4 = "10.0.47.0/30";
          ipv6 = "fd42:mini:47:fe::/126";
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
                ipv4 = [ "10.47.0.0/24" ];
                ipv6 = [ "fd42:mini:47:20::/64" ];
              };
            };
          };
        };
      };
    };
  };
}
