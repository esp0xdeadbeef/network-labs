{
  mini-smt = {
    policy-router-relation-identity = {
      communicationContract = {
        interfaceTags = {
          external-testnet = "testnet";
          tenant-client = "client";
        };
        relations = [ {
            id = "FS-310-HDS-010-SDS-010-SMS-030__mini-allow-client-to-testnet";
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
            ipv4 = "10.1.54.0/24";
            ipv6 = "fd42:0136:50::/64";
          } ];
      };
      pools = {
        loopback = {
          ipv4 = "10.1.0.0/24";
          ipv6 = "fd42:0136:ff::/118";
        };
        p2p = {
          ipv4 = "10.1.255.0/24";
          ipv6 = "fd42:0136:fe::/118";
        };
      };
      topology = {
        links = [
          [ "client-edge" "core-vlan4-client-dhcp-slaac" ]
        ];
        nodes = {
          client-edge = {
            role = "access";
            attachments = [ {
                kind = "tenant";
                name = "client";
              } ];
          };
          core-vlan4-client-dhcp-slaac = {
            role = "external";
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
