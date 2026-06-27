{
  "mini-smt" = {
    "internet-mode-verification" = {
      communicationContract = {
        interfaceTags = {
          external-emulated-isp = "emulated-isp";
          tenant-client = "client";
        };
        relations = [
          {
            id = "FS-380-HDS-020-SDS-010-SMS-050__mini-client-to-emulated-isp";
            action = "allow";
            from = {
              kind = "tenant";
              name = "client";
            };
            to = {
              kind = "external";
              name = "emulated-isp";
            };
            trafficType = "any";
            priority = 100;
          }
        ];
        services = [
          {
            name = "emulated-isp-pppoe";
            protocol = "pppoe";
            provider = "emulated-isp";
          }
        ];
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
            "emulated-isp"
          ]
        ];
        nodes = {
          client-edge = {
            role = "access";
            accessHandoff = {
              kind = "pppoe";
              server = "emulated-isp";
            };
            attachments = [
              {
                kind = "tenant";
                name = "client";
              }
            ];
          };
          emulated-isp = {
            role = "external";
            external = "emulated-isp";
            accessServices = [
              {
                kind = "pppoe-server";
                client = "client-edge";
              }
            ];
            uplinks = {
              internet-vlan4 = {
                mode = "dhcp";
                vlan = 4;
              };
              internet-vlan5 = {
                mode = "dhcp";
                vlan = 5;
              };
            };
          };
        };
      };
    };
  };
}
