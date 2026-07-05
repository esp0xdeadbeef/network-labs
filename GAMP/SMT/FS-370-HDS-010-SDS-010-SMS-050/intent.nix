{
  mini-smt = {
    FS-370-HDS-010-SDS-010-SMS-050 = {
      communicationContract = {
        relations = [
          {
            id = "FS-370-HDS-010-SDS-010-SMS-050__mini-client-to-testnet-uplink";
            action = "allow";
            from = {
              kind = "tenant";
              name = "client";
            };
            to = {
              kind = "external";
              name = "testnet";
              uplinks = [ "testnet" ];
            };
            trafficType = "any";
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
            ipv4 = "10.1.114.0/24";
            ipv6 = "fd42:0172:1::/64";
          }
        ];
      };
      pools = {
        loopback = {
          ipv4 = "10.127.114.0/24";
          ipv6 = "fd42:0172:7f::/64";
        };
        p2p = {
          ipv4 = "100.1.114.0/24";
          ipv6 = "fd42:0172::/64";
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
            "vlan4-client-dhcp-slaac"
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
          vlan4-client-dhcp-slaac = {
            role = "core";
            external = "testnet";
            uplinks = {
              testnet = {
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
