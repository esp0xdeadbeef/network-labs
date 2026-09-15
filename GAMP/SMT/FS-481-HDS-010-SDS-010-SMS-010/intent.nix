# Construction-only SMT row for FS-481-HDS-010-SDS-010-SMS-010.
#
# One isolated site with three eligible egress members on one access unit:
#   - isp-dual  is IPv4 + IPv6
#   - isp-v4    is IPv4 only
#   - isp-v6    is IPv6 only
#
# The boundary names all three, so the declared per-family member sets must
# differ: IPv4 must contain isp-dual and isp-v4, IPv6 must contain isp-dual
# and isp-v6. A family-blind "has a default" question would place every member
# in both families and admit a nexthop that has no route in that family.
#
# The second relation names the same three members as an ordered list, so the
# declared order must be preserved rather than sorted.
#
# All names, prefixes, and members are synthetic. This row is construction
# only: it declares no runtime lifecycle and must not be read as live evidence.
{
  mini-smt.smt-shape = {
    addressPools = {
      local.ipv4 = "10.81.0.0/24";
      p2p.ipv4 = "10.81.1.0/24";
      p2p.ipv6 = "fd42:481:1::/118";
    };

    attachments = [
      {
        unit = "access-multi";
        kind = "tenant";
        name = "multi-client";
      }
      {
        unit = "access-ordered";
        kind = "tenant";
        name = "ordered-client";
      }
    ];

    domains = {
      externals = [
        {
          kind = "external";
          name = "isp-dual";
        }
        {
          kind = "external";
          name = "isp-v4";
        }
        {
          kind = "external";
          name = "isp-v6";
        }
      ];
      tenants = [
        {
          kind = "tenant";
          name = "multi-client";
          ipv4 = "10.81.20.0/24";
          ipv6 = "fd42:481:20::/64";
        }
        {
          kind = "tenant";
          name = "ordered-client";
          ipv4 = "10.81.21.0/24";
          ipv6 = "fd42:481:21::/64";
        }
      ];
    };

    communicationContract = {
      relations = [
        {
          id = "FS-481-HDS-010-SDS-010-SMS-010__multi-family-client-egress";
          priority = 100;
          from = {
            kind = "tenant";
            name = "multi-client";
          };
          to = { kind = "external"; scope = "isp-dual"; };
          trafficType = "any";
          action = "allow";
          returnBehavior = "symmetric";
        }
        {
          id = "FS-481-HDS-010-SDS-010-SMS-010__ordered-client-egress";
          priority = 110;
          from = {
            kind = "tenant";
            name = "ordered-client";
          };
          to = { kind = "external"; scope = "isp-v6"; };
          trafficType = "any";
          action = "allow";
          returnBehavior = "symmetric";
        }
      ];

      trafficTypes = [
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
          name = "multi-client";
          dnsDomain = "lan.";
          ipv4 = "10.81.20.0/24";
          ipv6 = "fd42:481:20::/64";
        }
        {
          kind = "tenant";
          name = "ordered-client";
          dnsDomain = "lan.";
          ipv4 = "10.81.21.0/24";
          ipv6 = "fd42:481:21::/64";
        }
      ];
    };

    pools = {
      loopback = {
        ipv4 = "10.81.0.0/24";
        ipv6 = "fd42:481:ff::/118";
      };
      p2p = {
        ipv4 = "10.81.1.0/24";
        ipv6 = "fd42:481:fe::/118";
      };
    };

    topology = {
      links = [
        [
          "access-multi"
          "downstream-selector"
        ]
        [
          "access-ordered"
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
          "core-dual"
        ]
        [
          "upstream-selector"
          "core-v4"
        ]
        [
          "upstream-selector"
          "core-v6"
        ]
      ];
      nodes = {
        access-multi = {
          role = "access";
          attachments = [
            {
              kind = "tenant";
              name = "multi-client";
            }
          ];
        };
        access-ordered = {
          role = "access";
          attachments = [
            {
              kind = "tenant";
              name = "ordered-client";
            }
          ];
        };
        downstream-selector.role = "downstream-selector";
        policy.role = "policy";
        upstream-selector.role = "upstream-selector";
        core-dual = {
          role = "core";
          uplinks = {
            isp-dual = {
              ipv4 = [ "0.0.0.0/0" ];
              ipv6 = [ "::/0" ];
            };
          };
        };
        core-v4 = {
          role = "core";
          uplinks = {
            isp-v4 = {
              ipv4 = [ "0.0.0.0/0" ];
              ipv6 = [ ];
            };
          };
        };
        core-v6 = {
          role = "core";
          uplinks = {
            isp-v6 = {
              ipv4 = [ ];
              ipv6 = [ "::/0" ];
            };
          };
        };
      };
    };
  };
}
