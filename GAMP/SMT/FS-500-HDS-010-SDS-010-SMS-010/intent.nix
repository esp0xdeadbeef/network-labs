{
  mini-smt = {
    FS-500-HDS-010-SDS-010-SMS-010 = {
      communicationContract = {
        relations = [
          {
            id = "FS-500-HDS-010-SDS-010-SMS-010__mini-allow-client-to-testnet";
            action = "allow";
            from = {
              kind = "tenant";
              name = "client";
            };
            to = {
              kind = "external";
              uplinks = [ "internet-vlan4" ];
            };
            trafficType = "any";
            returnBehavior = "stateful-return";
            priority = 100;
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
            ipv4 = "10.1.244.0/24";
            ipv6 = "fd42:01f4:1::/64";
          }
        ];
      };
      pools = {
        loopback = {
          ipv4 = "10.127.244.0/24";
          ipv6 = "fd42:01f4:7f::/64";
        };
        p2p = {
          ipv4 = "100.1.244.0/24";
          ipv6 = "fd42:01f4::/64";
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
            "core-vlan4-client-dhcp-slaac"
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
          downstream-selector = {
            role = "downstream-selector";
          };
          policy = {
            role = "policy";
          };
          upstream-selector = {
            role = "upstream-selector";
          };
          core-vlan4-client-dhcp-slaac = {
            role = "core";
            external = "internet-vlan4";
            uplinks = {
              internet-vlan4 = {
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
