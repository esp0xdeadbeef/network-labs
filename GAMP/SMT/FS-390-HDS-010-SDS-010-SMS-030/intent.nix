{
  mini-smt = {
    FS-390-HDS-010-SDS-010-SMS-030 = {
      communicationContract = {
        interfaceTags = {
          external-testnet = "testnet";
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
              uplinks = [ "testnet" ];
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
              uplinks = [ "testnet" ];
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
