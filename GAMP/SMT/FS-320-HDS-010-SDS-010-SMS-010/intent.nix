{
  "mini-smt" = {
    "renderer-layout-preservation" = {
      communicationContract = {
        interfaceTags = {
          tenant-client = "client";
          tenant-mgmt = "mgmt";
          external-testnet = "testnet";
        };
        relations = [
          {
            id = "FS-320-HDS-010-SDS-010-SMS-010__mini-client-to-testnet-allow";
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
          {
            id = "FS-320-HDS-010-SDS-010-SMS-010__mini-mgmt-deny-internet";
            action = "deny";
            from = {
              kind = "tenant";
              name = "mgmt";
            };
            to = {
              kind = "external";
              name = "testnet";
            };
            trafficType = "any";
            priority = 90;
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
            ipv6 = "fd42:mini:320:10::/64";
          }
          {
            kind = "tenant";
            name = "mgmt";
            ipv4 = "10.50.20.0/24";
            ipv6 = "fd42:mini:320:20::/64";
          }
        ];
      };
      pools = {
        loopback = {
          ipv4 = "10.50.0.0/24";
          ipv6 = "fd42:mini:320:ff::/118";
        };
        p2p = {
          ipv4 = "10.0.0.0/30";
          ipv6 = "fd42:mini:320:fe::/126";
        };
      };
      topology = {
        links = [
          [
            "access-cohost"
            "core-exit"
          ]
        ];
        nodes = {
          access-cohost = {
            role = "access";
            attachments = [
              {
                kind = "tenant";
                name = "client";
              }
              {
                kind = "tenant";
                name = "mgmt";
              }
            ];
          };
          core-exit = {
            role = "core";
            uplinks = {
              testnet = {
                ipv4 = [ "10.20.0.0/24" ];
                ipv6 = [ "fd42:mini:320:20::/64" ];
              };
            };
          };
        };
      };
    };
  };
}
