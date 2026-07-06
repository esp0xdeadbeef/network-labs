{
  mini-smt = {
    FS-540-HDS-010-SDS-010-SMS-020 = {
      communicationContract = {
        interfaceTags = {
          external-internet-vlan4-vlan4 = "testnet-vlan4";
          service-access-dns = "access-dns";
          tenant-client = "client";
        };
        relations = [
          {
            id = "FS-540-HDS-010-SDS-010-SMS-020__mini-client-to-access-dns";
            action = "allow";
            from = {
              kind = "tenant";
              name = "client";
            };
            to = {
              kind = "service";
              name = "access-dns";
            };
            trafficType = "dns";
            priority = 100;
          }
          {
            id = "FS-540-HDS-010-SDS-010-SMS-020__mini-access-dns-service-to-testnet";
            action = "allow";
            from = {
              kind = "service";
              name = "access-dns";
            };
            to = {
              kind = "external";
              uplinks = [ "testnet-vlan4" ];
            };
            trafficType = "dns";
            priority = 110;
          }
          {
            id = "FS-540-HDS-010-SDS-010-SMS-020__mini-dns-client-to-testnet";
            action = "allow";
            from = {
              kind = "tenant";
              name = "client";
            };
            to = {
              kind = "external";
              uplinks = [ "testnet-vlan4" ];
            };
            trafficType = "any";
            priority = 120;
          }
        ];
        services = [
          {
            name = "access-dns";
            providers = [ "access-dns" ];
            trafficType = "dns";
          }
        ];
        trafficTypes = [
          {
            name = "dns";
            match = [
              {
                family = "any";
                proto = "udp";
                dports = [ 53 ];
              }
              {
                family = "any";
                proto = "tcp";
                dports = [ 53 ];
              }
            ];
          }
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
            ipv4 = "10.2.28.0/24";
            ipv6 = "fd42:021c:50::/64";
          }
        ];
        endpoints = [
          {
            kind = "host";
            name = "access-dns";
            tenant = "client";
            ipv4 = [ "10.54.10.1" ];
            ipv6 = [ "fd42:540::1" ];
          }
        ];
      };
      pools = {
        loopback = {
          ipv4 = "10.2.0.0/24";
          ipv6 = "fd42:021c:ff::/118";
        };
        p2p = {
          ipv4 = "10.2.255.0/24";
          ipv6 = "fd42:021c:fe::/118";
        };
      };
      topology = {
        links = [
          [
            "access-dns"
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
            "resolver-node"
          ]
        ];
        nodes = {
          access-dns = {
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
          resolver-node = {
            role = "core";
            external = "testnet-vlan4";
            uplinks = {
              testnet-vlan4 = {
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
