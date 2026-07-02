{
  mini-smt = {
    FS-380-HDS-020-SDS-010-SMS-050 = {
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
              uplinks = [
                "isp"
                "pppoe-provider"
              ];
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
      internetModeRecords = [
        {
          accessHandoff = {
            kind = "pppoe";
            client = "client-edge";
            server = "emulated-isp";
          };
          upstream = {
            kind = "emulated-isp";
            internetUplinks = [
              {
                vlan = 4;
                mode = "dhcp";
              }
              {
                vlan = 5;
                mode = "dhcp";
              }
            ];
          };
        }
      ];
      ownership = {
        prefixes = [
          {
            kind = "tenant";
            name = "client";
            ipv4 = "10.1.124.0/24";
            ipv6 = "fd42:017c:50::/64";
          }
        ];
      };
      pools = {
        loopback = {
          ipv4 = "10.1.0.0/24";
          ipv6 = "fd42:017c:ff::/118";
        };
        p2p = {
          ipv4 = "10.1.255.0/24";
          ipv6 = "fd42:017c:fe::/118";
        };
      };
      topology = {
        links = [
          [
            "client-edge"
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
          downstream-selector = {
            role = "downstream-selector";
          };
          policy = {
            role = "policy";
          };
          upstream-selector = {
            role = "upstream-selector";
          };
          emulated-isp = {
            role = "core";
            external = "emulated-isp";
            accessServices = [
              {
                kind = "pppoe-server";
                client = "client-edge";
              }
            ];
            uplinks = {
              isp = {
                ipv4 = [ "0.0.0.0/0" ];
                ipv6 = [ "::/0" ];
              };
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
