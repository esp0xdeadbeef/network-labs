{
  mini-smt.FS-540-HDS-010-SDS-010-SMS-030 = {
    communicationContract = {
      relations = [
        {
          id = "FS-540-HDS-010-SDS-010-SMS-030__recursive-client-to-access";
          priority = 100;
          from = {
            kind = "tenant";
            name = "recursive-client";
          };
          to = {
            kind = "service";
            name = "recursive-dns";
          };
          trafficType = "dns";
          action = "allow";
          returnBehavior = "symmetric";
        }
        {
          id = "FS-540-HDS-010-SDS-010-SMS-030__local-client-to-access";
          priority = 101;
          from = {
            kind = "tenant";
            name = "local-client";
          };
          to = {
            kind = "service";
            name = "local-dns";
          };
          trafficType = "dns";
          action = "allow";
          returnBehavior = "symmetric";
        }
        {
          id = "FS-540-HDS-010-SDS-010-SMS-030__local-dns-to-recursive-dns";
          priority = 90;
          from = {
            kind = "service";
            name = "local-dns";
          };
          to = {
            kind = "service";
            name = "recursive-dns";
          };
          trafficType = "dns";
          action = "allow";
          returnBehavior = "symmetric";
        }
        {
          id = "FS-540-HDS-010-SDS-010-SMS-030__recursive-client-web-egress";
          priority = 200;
          from = {
            kind = "tenant";
            name = "recursive-client";
          };
          to = {
            kind = "external";
            uplinks = [ "isp-primary" ];
          };
          trafficType = "web";
          action = "allow";
          returnBehavior = "symmetric";
        }
      ];
      services = [
        {
          name = "recursive-dns";
          providers = [ "recursive-dns" ];
          trafficType = "dns";
        }
        {
          name = "local-dns";
          providers = [ "local-dns" ];
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
          providerNode = "core-primary";
          addressAuthority = "model-allocated-service-prefix";
          trafficType = "dns";
          recursionMode = "iterative";
        }
      ];
      relations = [
        {
          id = "FS-540-HDS-010-SDS-010-SMS-030__recursive-dns-to-core";
          priority = 110;
          from = {
            kind = "service";
            name = "recursive-dns";
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
          id = "FS-540-HDS-010-SDS-010-SMS-030__core-dns-to-provider";
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
            name = "recursive-dns";
          };
          advertisedResolver = {
            kind = "service";
            name = "recursive-dns";
          };
          resolverSource = "local-recursive";
          upstreamResolver = {
            kind = "service";
            name = "core-dns";
            node = "core-primary";
          };
          resolverPath = [
            "access-recursive"
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

    localDnsSharingIntent = {
      namespace = "lab.";
      authority = {
        service = "recursive-dns";
        records = [ "synthetic-shared-records" ];
      };
      requester = {
        service = "local-dns";
        allowedNamespaces = [
          "lab."
          "30.54.10.in-addr.arpa."
        ];
        recursion = false;
        publicFallback = false;
      };
      relation = {
        id = "FS-540-HDS-010-SDS-010-SMS-030__local-dns-to-recursive-dns";
        from = {
          kind = "service";
          name = "local-dns";
        };
        to = {
          kind = "service";
          name = "recursive-dns";
        };
        trafficType = "dns";
        returnBehavior = "symmetric";
        resolverPath = [
          "access-local"
          "downstream-selector"
          "access-recursive"
        ];
      };
      providerPolicy = {
        source = "local-dns";
        action = "refuse_non_local";
      };
      lateralPolicy = {
        source = "recursive-client";
        target = "local-dns";
        localData = true;
        recursion = false;
        transitiveEgress = false;
        action = "refuse_non_local";
      };
    };

    ownership = {
      prefixes = [
        {
          kind = "tenant";
          name = "recursive-client";
          ipv4 = "10.54.30.0/24";
          ipv6 = "fd42:540:30::/64";
        }
        {
          kind = "tenant";
          name = "local-client";
          ipv4 = "10.54.31.0/24";
          ipv6 = "fd42:540:31::/64";
        }
      ];
      endpoints = [
        {
          kind = "host";
          name = "recursive-dns";
          tenant = "recursive-client";
          ipv4 = [ "10.54.30.1" ];
          ipv6 = [ "fd42:540:30::1" ];
        }
        {
          kind = "host";
          name = "local-dns";
          tenant = "local-client";
          ipv4 = [ "10.54.31.1" ];
          ipv6 = [ "fd42:540:31::1" ];
        }
      ];
    };
    pools = {
      loopback = {
        ipv4 = "10.54.0.0/24";
        ipv6 = "fd42:540:ff::/118";
      };
      p2p = {
        ipv4 = "10.54.255.0/24";
        ipv6 = "fd42:540:fe::/118";
      };
    };
    topology = {
      links = [
        [
          "access-recursive"
          "downstream-selector"
        ]
        [
          "access-local"
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
        access-recursive = {
          role = "access";
          attachments = [
            {
              kind = "tenant";
              name = "recursive-client";
            }
          ];
        };
        access-local = {
          role = "access";
          attachments = [
            {
              kind = "tenant";
              name = "local-client";
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
}
