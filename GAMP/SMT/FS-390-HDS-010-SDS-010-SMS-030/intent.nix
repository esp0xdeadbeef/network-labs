{
  mini-smt = {
    FS-390-HDS-010-SDS-010-SMS-030 = {
      communicationContract = {
        interfaceTags = {
          external-internet-vlan4 = "internet-vlan4";
          tenant-client = "client";
        };
        allowedRelations = [
          {
            id = "FS-390-HDS-010-SDS-010-SMS-030__mini-verify";
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
            id = "FS-390-HDS-010-SDS-010-SMS-030__client-to-tenant-service-public-via-broad-wan";
            action = "allow";
            from = {
              kind = "tenant";
              name = "client";
            };
            to = {
              kind = "public-ipv4";
              ipv4 = "203.0.113.100";
            };
            trafficType = "any";
            priority = 110;
          }
          {
            id = "FS-390-HDS-010-SDS-010-SMS-030__client-to-public-ingress-via-broad-wan";
            action = "allow";
            from = {
              kind = "tenant";
              name = "client";
            };
            to = {
              kind = "public-ipv4";
              ipv4 = "198.51.100.34";
            };
            trafficType = "any";
            priority = 111;
          }
          {
            id = "FS-390-HDS-010-SDS-010-SMS-030__tenant-service-exposure-allow";
            action = "allow";
            from = {
              kind = "service";
              name = "tenant-service-without-shortcut-policy";
            };
            to = {
              kind = "service";
              name = "tenant-service-without-shortcut-policy";
            };
            trafficType = "any";
            priority = 200;
            returnBehavior = null;
          }
          {
            id = "FS-390-HDS-010-SDS-010-SMS-030__public-web-public-ingress-exposure-allow";
            action = "allow";
            from = {
              kind = "external";
              uplinks = [ "internet-vlan4" ];
            };
            to = {
              kind = "service";
              name = "public-web-without-ingress-policy";
            };
            trafficType = "any";
            priority = 201;
            returnBehavior = null;
          }
        ];
        relations = [
          {
            id = "FS-390-HDS-010-SDS-010-SMS-030__mini-verify";
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
            id = "FS-390-HDS-010-SDS-010-SMS-030__client-to-tenant-service-public-via-broad-wan";
            action = "allow";
            from = {
              kind = "tenant";
              name = "client";
            };
            to = {
              kind = "public-ipv4";
              ipv4 = "203.0.113.100";
            };
            trafficType = "any";
            priority = 110;
          }
          {
            id = "FS-390-HDS-010-SDS-010-SMS-030__client-to-public-ingress-via-broad-wan";
            action = "allow";
            from = {
              kind = "tenant";
              name = "client";
            };
            to = {
              kind = "public-ipv4";
              ipv4 = "198.51.100.34";
            };
            trafficType = "any";
            priority = 111;
          }
          {
            id = "FS-390-HDS-010-SDS-010-SMS-030__tenant-service-exposure-allow";
            action = "allow";
            from = {
              kind = "service";
              name = "tenant-service-without-shortcut-policy";
            };
            to = {
              kind = "service";
              name = "tenant-service-without-shortcut-policy";
            };
            trafficType = "any";
            priority = 200;
            returnBehavior = null;
          }
          {
            id = "FS-390-HDS-010-SDS-010-SMS-030__public-web-public-ingress-exposure-allow";
            action = "allow";
            from = {
              kind = "external";
              uplinks = [ "internet-vlan4" ];
            };
            to = {
              kind = "service";
              name = "public-web-without-ingress-policy";
            };
            trafficType = "any";
            priority = 201;
            returnBehavior = null;
          }
        ];
        services = [
          {
            name = "tenant-service-without-shortcut-policy";
            publicIpv4 = "203.0.113.100/32";
          }
          {
            name = "public-web-without-ingress-policy";
            publicIngress = {
              enabled = true;
              ipv4 = "198.51.100.34/32";
            };
          }
        ];
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
            ipv4 = "10.30.134.0/24";
            ipv6 = "fd42:0390:30:50::/64";
            publicIpv4 = "198.51.100.30/32";
          } ];
        endpoints = [
          {
            kind = "local";
            name = "locally-routed-endpoint";
            publicIpv4 = "198.51.100.32/32";
          }
          {
            kind = "provider";
            name = "provider-owned-endpoint";
            providerOwned = true;
            publicIpv4 = "198.51.100.33/32";
          } ];
      };
      pools = {
        loopback = {
          ipv4 = "10.30.0.0/24";
          ipv6 = "fd42:0390:30:ff::/118";
        };
        p2p = {
          ipv4 = "10.30.255.0/24";
          ipv6 = "fd42:0390:30:fe::/118";
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
