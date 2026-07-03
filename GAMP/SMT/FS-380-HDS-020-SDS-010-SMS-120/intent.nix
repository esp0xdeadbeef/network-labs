{
  mini-smt = {
    FS-380-HDS-020-SDS-010-SMS-120 = {
      communicationContract = {
        interfaceTags = {
          external-internet-vlan4 = "internet-vlan4";
          service-access-dns = "access-dns";
          tenant-client = "client";
        };
        relations = [
          {
            id = "FS-380-HDS-020-SDS-010-SMS-120__prod-like-client-to-access-dns";
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
            priority = 80;
          }
          {
            id = "FS-380-HDS-020-SDS-010-SMS-120__prod-like-access-dns-to-vlan4";
            action = "allow";
            from = {
              kind = "service";
              name = "access-dns";
            };
            to = {
              kind = "external";
              name = "internet-vlan4";
              uplinks = [ "internet-vlan4" ];
            };
            trafficType = "dns";
            priority = 90;
          }
          {
            id = "FS-380-HDS-020-SDS-010-SMS-120__prod-like-client-to-vlan4-internet";
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
            trafficType = "ipv4-any";
            priority = 100;
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
                family = "ipv4";
                proto = "udp";
                dports = [ 53 ];
              }
              {
                family = "ipv4";
                proto = "tcp";
                dports = [ 53 ];
              }
            ];
          }
          {
            name = "ipv4-any";
            match = [
              {
                family = "ipv4";
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
            ipv4 = "10.38.120.0/24";
            ipv6 = "fd42:380:120::/64";
          }
        ];
        endpoints = [
          {
            kind = "service";
            name = "access-dns";
            tenant = "client";
          }
        ];
      };
      pools = {
        loopback = {
          ipv4 = "10.19.0.0/24";
          ipv6 = "fd42:dead:beef:1900::/118";
        };
        p2p = {
          ipv4 = "10.10.0.0/24";
          ipv6 = "fd42:dead:beef:1000::/118";
        };
      };
      topology = {
        links = [
          [
            "access-vlan2"
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
            "core"
          ]
        ];
        nodes = {
          access-vlan2 = {
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
          core = {
            role = "core";
            external = "internet-vlan4";
            uplinks = {
              internet-vlan4 = {
                ipv4 = [ "0.0.0.0/0" ];
              };
            };
          };
        };
      };
    };
  };
}
