{
  "mini-smt" = {
    "internet-mode-verification" = {
      communicationContract = {
        interfaceTags = {
          external-wan = "wan";
          tenant-client = "client";
        };
        relations = [
          {
            id = "FS-380-HDS-020-SDS-010-SMS-050__mini-client-to-wan";
            action = "allow";
            from = {
              kind = "tenant";
              name = "client";
            };
            to = {
              kind = "external";
              name = "wan";
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
            ipv4 = "10.20.20.0/24";
            ipv6 = "fd42:mini:380:20::/64";
          }
        ];
      };
      pools = {
        loopback = {
          ipv4 = "10.19.0.0/24";
          ipv6 = "fd42:mini:380::/118";
        };
        p2p = {
          ipv4 = "10.10.0.0/24";
          ipv6 = "fd42:mini:380:ff::/118";
        };
      };
      topology = {
        links = [
          [
            "client-edge"
            "wan-core"
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
          wan-core = {
            role = "core";
            uplinks = {
              wan = {
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
