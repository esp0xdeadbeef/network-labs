{
  mini-smt = {
    FS-800-HDS-010-SDS-020-SMS-020 = {
      communicationContract = {
        interfaceTags = {
          external-internet-vlan4 = "internet-vlan4";
          external-fake-isp = "fake-isp";
          tenant-client = "client";
        };
        relations = [
          {
            id = "FS-800-HDS-010-SDS-020-SMS-020__mini-provider-egress";
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
          }
          {
            id = "FS-800-HDS-010-SDS-020-SMS-020__mini-customer-nat";
            action = "allow";
            from = {
              kind = "tenant";
              name = "client";
            };
            to = {
              kind = "external";
              uplinks = [ "fake-isp" ];
            };
            trafficType = "any";
            priority = 90;
          }
        ];
        services = [ ];
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
            ipv4 = "10.3.32.0/24";
            ipv6 = "fd42:0320:50::/64";
          } ];
      };
      pools = {
        loopback = {
          ipv4 = "10.3.0.0/24";
          ipv6 = "fd42:0320:ff::/118";
        };
        p2p = {
          ipv4 = "10.3.255.0/24";
          ipv6 = "fd42:0320:fe::/118";
        };
      };
      topology = {
        links = [
          [ "access-PPPoE-Server" "downstream-selector-provider" ]
          [ "downstream-selector-provider" "policy" ]
          [ "policy" "upstream-selector-provider" ]
          [ "upstream-selector-provider" "core-vlan4-client-dhcp-slaac" ]
          [ "client-edge" "downstream-selector-customer" ]
          [ "downstream-selector-customer" "policy" ]
          [ "policy" "upstream-selector-customer" ]
          [ "upstream-selector-customer" "core-fake-isp" ]
          [ "access-PPPoE-Server" "core-fake-isp" ]
        ];
        nodes = {
          access-PPPoE-Server = {
            role = "access";
            attachments = [ {
                kind = "tenant";
                name = "client";
              } ];
          };
          downstream-selector-provider = {
            role = "downstream-selector";
          };
          policy = {
            role = "policy";
          };
          upstream-selector-provider = {
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
          client-edge = {
            role = "access";
            attachments = [ {
                kind = "tenant";
                name = "client";
              } ];
          };
          downstream-selector-customer = {
            role = "downstream-selector";
          };
          upstream-selector-customer = {
            role = "upstream-selector";
          };
          core-fake-isp = {
            role = "core";
            external = "fake-isp";
            uplinks = {
              fake-isp = {
                ipv4 = [ "203.0.113.1/32" ];
                ipv6 = [ "2001:db8:113::1/128" ];
              };
            };
          };
        };
      };
    };
  };
}
