let
  traceId = "FS-230-HDS-010-SDS-010-SMS-040";
in
{
  mini-smt.${traceId} = {
    communicationContract = {
      interfaceTags = {
        external-lab-wan = "lab-wan";
        service-nebula-lab = "nebula-lab";
        tenant-lab-dmz = "lab-dmz";
      };
      relations = [
        {
          id = "${traceId}__lab-wan-to-nebula-ipv6";
          priority = 100;
          action = "allow";
          from = {
            kind = "external";
            uplinks = [ "lab-wan" ];
          };
          to = {
            kind = "service";
            name = "nebula-lab";
          };
          trafficType = "nebula-ipv6";
          returnBehavior = "stateful-return";
          publicIngressTupleAuthority = {
            family = "ipv6";
            targetService = "nebula-lab";
            targetPort = 4242;
            tuples = [
              {
                protocol = "udp";
                publicPort = 4242;
              }
            ];
            translationMode = "none";
            sourcePreservation = "preserve-source";
            returnBehavior = "stateful-return";
          };
        }
      ];
      services = [
        {
          name = "nebula-lab";
          providers = [ "nebula-lab-endpoint" ];
          trafficType = "nebula-ipv6";
        }
      ];
      trafficTypes = [
        {
          name = "nebula-ipv6";
          match = [
            {
              family = "ipv6";
              proto = "udp";
              dports = [ 4242 ];
            }
          ];
        }
      ];
    };

    ownership = {
      prefixes = [
        {
          kind = "tenant";
          name = "lab-dmz";
          ipv4 = "10.2.30.0/24";
          ipv6 = "fd42:0230:40::/64";
          # This is an opaque site/allocation input under the current schema,
          # not forwarding authority and not a value evaluated by Nix.
          routedPrefixes = [
            {
              allocation = "runtime";
              family = "ipv6";
              name = "lab-dmz-public";
              sourceFile = "/run/secrets/fs230-lab-dmz-ipv6-prefix";
              delegatedPrefixLength = 48;
              perTenantPrefixLength = 64;
              slot = 35;
            }
          ];
        }
      ];
      endpoints = [
        {
          kind = "host";
          name = "nebula-lab-endpoint";
          tenant = "lab-dmz";
        }
      ];
    };

    pools = {
      loopback = {
        ipv4 = "10.23.0.0/24";
        ipv6 = "fd42:0230:ff::/118";
      };
      p2p = {
        ipv4 = "10.23.255.0/24";
        ipv6 = "fd42:0230:fe::/118";
      };
    };

    topology = {
      links = [
        [
          "access-dmz"
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
          "core-lab-wan"
        ]
      ];
      nodes = {
        access-dmz = {
          role = "access";
          attachments = [
            {
              kind = "tenant";
              name = "lab-dmz";
            }
          ];
        };
        downstream-selector.role = "downstream-selector";
        policy.role = "policy";
        upstream-selector.role = "upstream-selector";
        core-lab-wan = {
          role = "core";
          external = "lab-wan";
          uplinks.lab-wan = {
            ipv4 = [ "0.0.0.0/0" ];
            ipv6 = [ "::/0" ];
          };
        };
      };
    };
  };
}
