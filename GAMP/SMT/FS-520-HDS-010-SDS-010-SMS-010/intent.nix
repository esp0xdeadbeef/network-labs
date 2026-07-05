{
  mini-smt = {
    FS-520-HDS-010-SDS-010-SMS-010 = {
      communicationContract = {
        interfaceTags = {
          external-testnet = "testnet";
          tenant-client = "client";
        };
        relations = [ {
            id = "FS-520-HDS-010-SDS-010-SMS-010__mini-verify";
            action = "allow";
            from = {
              kind = "tenant";
              name = "client";
            };
            to = {
              kind = "external";
              uplinks = [ "testnet" ];
            };
            trafficType = "any";
            priority = 100;
          } ];
        services = [];
        trafficTypes = [ {
            name = "any";
            match = [ {
                family = "any";
                proto = "any";
              } ];
          } ];
      };
      ownership = {
        prefixes = [ {
            kind = "tenant";
            name = "client";
            ipv4 = "10.2.8.0/24";
            ipv6 = "fd42:0208:50::/64";
          } ];
      };
      pools = {
        loopback = {
          ipv4 = "10.2.0.0/24";
          ipv6 = "fd42:0208:ff::/118";
        };
        p2p = {
          ipv4 = "10.2.255.0/24";
          ipv6 = "fd42:0208:fe::/118";
        };
      };
      topology = {
        links = [
          [ "client-edge" "downstream-selector" ]
          [ "downstream-selector" "policy" ]
          [ "policy" "upstream-selector" ]
          [ "upstream-selector" "vlan4-client-dhcp-slaac" ]
        ];
        nodes = {
          client-edge = {
            role = "access";
            attachments = [ {
                kind = "tenant";
                name = "client";
              } ];
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
