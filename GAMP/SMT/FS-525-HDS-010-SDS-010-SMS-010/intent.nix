{
  mini-smt = {
    FS-525-HDS-010-SDS-010-SMS-010 = {
      communicationContract = {
        relations = [
          {
            id = "FS-525-HDS-010-SDS-010-SMS-010__client-to-access-dns";
            priority = 100;
            from = {
              kind = "tenant";
              name = "client";
            };
            to = {
              kind = "service";
              name = "access-dns";
            };
            trafficType = "dns";
            action = "allow";
            returnBehavior = "symmetric";
          }
          {
            id = "FS-525-HDS-010-SDS-010-SMS-010__client-egress";
            priority = 200;
            from = {
              kind = "tenant";
              name = "client";
            };
            to = {
              kind = "external";
              uplinks = [ "isp-primary" ];
            };
            trafficType = "any";
            action = "allow";
            returnBehavior = "symmetric";
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

      recursiveDnsIntent = {
        services = [
          {
            name = "core-dns";
            providerNode = "core-primary";
            addressAuthority = "model-allocated-service-prefix";
            trafficType = "dns";
            recursionMode = "iterative";
          }
        ];
        relations = [
          {
            id = "FS-525-HDS-010-SDS-010-SMS-010__access-dns-to-core-dns";
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
            id = "FS-525-HDS-010-SDS-010-SMS-010__core-dns-to-provider";
            priority = 120;
            from = {
              kind = "service";
              name = "core-dns";
            };
            to = {
              kind = "external";
              uplinks = [ "isp-primary" ];
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
              node = "core-primary";
            };
            resolverPath = [
              "access-dns"
              "downstream-selector"
              "policy"
              "upstream-selector"
              "core-primary"
            ];
            egressSurface = {
              kind = "external";
              uplinks = [ "isp-primary" ];
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
            ipv4 = "10.52.5.0/24";
            ipv6 = "fd42:525::/64";
          }
        ];
        endpoints = [
          {
            kind = "host";
            name = "access-dns";
            tenant = "client";
            ipv4 = [ "10.52.5.1" ];
            ipv6 = [ "fd42:525::1" ];
          }
        ];
      };
      pools = {
        loopback = {
          ipv4 = "10.52.0.0/24";
          ipv6 = "fd42:525:ff::/118";
        };
        p2p = {
          ipv4 = "10.52.255.0/24";
          ipv6 = "fd42:525:fe::/118";
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
            "core-primary"
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
          downstream-selector.role = "downstream-selector";
          policy.role = "policy";
          upstream-selector.role = "upstream-selector";
          core-primary = {
            role = "core";
            uplinks = {
              isp-primary = {
                ipv4 = [ "0.0.0.0/0" ];
                ipv6 = [ "::/0" ];
              };
              overlay-secondary = {
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
