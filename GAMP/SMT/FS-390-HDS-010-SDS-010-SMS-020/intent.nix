{
  mini-smt = {
    FS-390-HDS-010-SDS-010-SMS-020 = {
      communicationContract = {
        interfaceTags = {
          external-testnet = "testnet";
          tenant-client = "client";
        };
        allowedRelations = [
          {
            id = "FS-390-HDS-010-SDS-010-SMS-020__mini-verify";
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
            id = "FS-390-HDS-010-SDS-010-SMS-020__client-to-tenant-api";
            action = "allow";
            from = {
              kind = "tenant";
              name = "client";
            };
            to = {
              kind = "service";
              name = "tenant-api";
            };
            trafficType = "any";
            priority = 80;
          }
          {
            id = "FS-390-HDS-010-SDS-010-SMS-020__testnet-to-public-web";
            action = "allow";
            from = {
              kind = "external";
              uplinks = [ "testnet" ];
            };
            to = {
              kind = "service";
              name = "public-web";
            };
            trafficType = "any";
            priority = 82;
          }
        ];
        relations = [
          {
            id = "FS-390-HDS-010-SDS-010-SMS-020__mini-verify";
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
            id = "FS-390-HDS-010-SDS-010-SMS-020__client-to-tenant-api";
            action = "allow";
            from = {
              kind = "tenant";
              name = "client";
            };
            to = {
              kind = "service";
              name = "tenant-api";
            };
            trafficType = "any";
            priority = 80;
          }
          {
            id = "FS-390-HDS-010-SDS-010-SMS-020__testnet-to-public-web";
            action = "allow";
            from = {
              kind = "external";
              uplinks = [ "testnet" ];
            };
            to = {
              kind = "service";
              name = "public-web";
            };
            trafficType = "any";
            priority = 82;
          }
        ];
        services = [
          {
            name = "tenant-api";
            publicIpv4 = "198.51.100.21/32";
          }
          {
            name = "public-web";
            publicIngress = {
              enabled = true;
              ipv4 = "198.51.100.24/32";
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
            ipv4 = "10.20.134.0/24";
            ipv6 = "fd42:0390:20:50::/64";
            publicIpv4 = "198.51.100.20/32";
          } ];
        endpoints = [
          {
            kind = "local";
            name = "locally-routed-endpoint";
            publicIpv4 = "198.51.100.22/32";
          }
          {
            kind = "provider";
            name = "provider-owned-endpoint";
            providerOwned = true;
            publicIpv4 = "198.51.100.23/32";
          } ];
      };
      pools = {
        loopback = {
          ipv4 = "10.20.0.0/24";
          ipv6 = "fd42:0390:20:ff::/118";
        };
        p2p = {
          ipv4 = "10.20.255.0/24";
          ipv6 = "fd42:0390:20:fe::/118";
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
