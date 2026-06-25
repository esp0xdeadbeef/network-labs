{
  "mini-smt" = {
    "pppoe-pairing" = {
      communicationContract = {
        interfaceTags = {
          external-pppoe = "pppoe-provider";
          tenant-client = "client";
        };
        relations = [
          {
            id = "FS-800-HDS-030-SDS-030-SMS-010__mini-pppoe-client-to-provider";
            action = "allow";
            from = {
              kind = "tenant";
              name = "client";
            };
            to = {
              kind = "external";
              name = "pppoe-provider";
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
            ipv4 = "10.80.10.0/24";
            ipv6 = "fd42:mini:800::/64";
          }
        ];
      };
      pools = {
        loopback = {
          ipv4 = "10.80.0.0/24";
          ipv6 = "fd42:mini:800:ff::/118";
        };
        p2p = {
          ipv4 = "10.80.255.0/24";
          ipv6 = "fd42:mini:800:fe::/118";
        };
      };
      topology = {
        links = [
          [
            "pppoe-client"
            "pppoe-provider"
          ]
        ];
        nodes = {
          pppoe-client = {
            role = "access";
            attachments = [
              {
                kind = "tenant";
                name = "client";
              }
            ];
          };
          pppoe-provider = {
            role = "core";
            uplinks = {
              pppoe-provider = {
                ipv4 = [ "0.0.0.0/0" ];
                ipv6 = [ "::/0" ];
              };
            };
          };
        };
      };
    };
  };
}
