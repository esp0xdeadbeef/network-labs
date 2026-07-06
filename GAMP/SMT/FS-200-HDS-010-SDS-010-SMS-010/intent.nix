{
  mini-smt = {
    shared-service-exposure-boundary = {
      communicationContract = {
        interfaceTags = {
          external-internet-vlan4 = "internet-vlan4";
          tenant-client = "client";
        };
        relations = [ {
            id = "FS-200-HDS-010-SDS-010-SMS-010__mini-client-to-testnet";
            action = "allow";
            from = {
              kind = "tenant";
              name = "client";
            };
            to = {
              kind = "external";
              name = "internet-vlan4";
              uplinks = [ "internet-vlan4" ];
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
            ipv4 = "10.0.200.0/24";
            ipv6 = "fd42:00c8:50::/64";
          } ];
      };
      pools = {
        loopback = {
          ipv4 = "10.0.0.0/24";
          ipv6 = "fd42:00c8:ff::/118";
        };
        p2p = {
          ipv4 = "10.0.255.0/24";
          ipv6 = "fd42:00c8:fe::/118";
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
