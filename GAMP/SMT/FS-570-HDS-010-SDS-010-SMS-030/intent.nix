{
  mini-smt = {
    FS-570-HDS-010-SDS-010-SMS-030 = {
      communicationContract = {
        interfaceTags = {
          external-internet-vlan4 = "internet-vlan4";
          tenant-client = "client";
        };
        relations = [ {
            id = "FS-570-HDS-010-SDS-010-SMS-030__mini-verify";
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
            ipv4 = "10.2.58.0/24";
            ipv6 = "fd42:023a:50::/64";
          } ];
      };
      pools = {
        loopback = {
          ipv4 = "10.2.0.0/24";
          ipv6 = "fd42:023a:ff::/118";
        };
        p2p = {
          ipv4 = "10.2.255.0/24";
          ipv6 = "fd42:023a:fe::/118";
        };
      };
      topology = {
        links = [
          [ "client-edge" "downstream-selector" ]
          [ "downstream-selector" "policy" ]
          [ "policy" "upstream-selector" ]
          [ "upstream-selector" "core-vlan4-client-dhcp-slaac" ]
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
