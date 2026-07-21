{
  mini-smt = {
    FS-540-HDS-010-SDS-010-SMS-020 = {
      communicationContract = {
        interfaceTags = {
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
            returnBehavior = "stateful-return";
            priority = 100;
          }
          {
            id = "FS-540-HDS-010-SDS-010-SMS-020__mini-client-web-to-testnet";
            action = "allow";
            from = {
              kind = "tenant";
              name = "client";
            };
            to = {
              kind = "external";
              uplinks = [ "testnet-vlan4" ];
            };
            trafficType = "web";
            returnBehavior = "symmetric";
            priority = 200;
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
            name = "web";
            match = [
              {
                family = "any";
                proto = "tcp";
                dports = [
                  80
                  443
                ];
              }
            ];
          }
        ];
      };

      recursiveDnsIntent = {
        services = [
          {
            name = "core-dns";
            providerNode = "resolver-node";
            addressAuthority = "model-allocated-service-prefix";
            trafficType = "dns";
            recursionMode = "iterative";
          }
        ];
        relations = [
          {
            id = "FS-540-HDS-010-SDS-010-SMS-020__mini-access-dns-to-core-dns";
            priority = 110;
            from = {
              kind = "service";
              name = "access-dns";
            };
            to = {
              kind = "service";
              name = "core-dns";
            };
            trafficType = "dns";
            action = "allow";
            returnBehavior = "symmetric";
          }
          {
            id = "FS-540-HDS-010-SDS-010-SMS-020__mini-core-dns-to-testnet";
            priority = 120;
            from = {
              kind = "service";
              name = "core-dns";
            };
            to = {
              kind = "external";
              uplinks = [ "testnet-vlan4" ];
            };
            trafficType = "dns";
            action = "allow";
            returnBehavior = "symmetric";
          }
        ];
        bindings = [
          {
            requesterScope = {
              kind = "service";
              name = "access-dns";
            };
            advertisedResolver = {
              kind = "service";
              name = "access-dns";
            };
            resolverSource = "local-recursive";
            upstreamResolver = {
              kind = "service";
              name = "core-dns";
              node = "resolver-node";
            };
            resolverPath = [
              "access-dns"
              "downstream-selector"
              "policy"
              "upstream-selector"
              "resolver-node"
            ];
            egressSurface = {
              kind = "external";
              uplinks = [ "testnet-vlan4" ];
            };
            returnBehavior = "symmetric";
            allowedAddressFamilies = [
              "ipv4"
              "ipv6"
            ];
            directPublicFallback = false;
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
