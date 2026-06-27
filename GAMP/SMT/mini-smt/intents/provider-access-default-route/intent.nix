{
  "mini-smt" = {
    "provider-access-default-route" = {
      communicationContract = {
        interfaceTags = {
          external-isp = "isp";
          tenant-provider-handoff-a = "provider-handoff-a";
        };
        relations = [
          {
            id = "FS-800-HDS-010-SDS-020-SMS-040__mini-provider-handoff-to-internet";
            action = "allow";
            from = {
              kind = "tenant";
              name = "provider-handoff-a";
            };
            to = {
              kind = "external";
              name = "isp";
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
            name = "provider-handoff-a";
            ipv4 = "203.0.113.0/24";
            ipv6 = "2001:db8:800:113::/64";
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
            "provider-handoff-access-a"
            "fabric-core"
          ]
          [
            "provider-handoff-access-a"
            "pppoe-core"
          ]
        ];
        nodes = {
          provider-handoff-access-a = {
            role = "access";
            attachments = [
              {
                kind = "tenant";
                name = "provider-handoff-a";
              }
            ];
          };
          fabric-core = {
            role = "core";
            uplinks = {
              isp = {
                ipv4 = [ "0.0.0.0/0" ];
                ipv6 = [ "::/0" ];
              };
            };
          };
          pppoe-core = {
            role = "core";
          };
        };
      };
    };
  };
}
