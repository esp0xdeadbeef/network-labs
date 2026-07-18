{
  mini-smt.FS-270-HDS-010-SDS-010-SMS-020 = {
    communicationContract = {
      interfaceTags = {
        tenant-source = "source";
        tenant-destination = "destination";
      };
      relations = [
        {
          id = "FS-270-HDS-010-SDS-010-SMS-020__deny-reverse-new-flow";
          priority = 90;
          from = {
            kind = "tenant";
            name = "destination";
          };
          to = {
            kind = "tenant";
            name = "source";
          };
          trafficType = "any";
          action = "deny";
        }
        {
          id = "FS-270-HDS-010-SDS-010-SMS-020__source-to-destination-icmp";
          priority = 100;
          from = {
            kind = "tenant";
            name = "source";
          };
          to = {
            kind = "service";
            name = "destination-icmp";
          };
          trafficType = "icmp";
          action = "allow";
          returnBehavior = "symmetric";
        }
      ];
      services = [
        {
          name = "destination-icmp";
          providers = [ "destination-endpoint" ];
          trafficType = "icmp";
        }
      ];
      trafficTypes = [
        {
          name = "icmp";
          match = [
            {
              family = "ipv4";
              proto = "icmp";
            }
            {
              family = "ipv6";
              proto = "icmpv6";
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
          name = "source";
          ipv4 = "10.27.70.0/24";
          ipv6 = "fd42:270:70::/64";
        }
        {
          kind = "tenant";
          name = "destination";
          ipv4 = "10.27.71.0/24";
          ipv6 = "fd42:270:71::/64";
        }
      ];
      endpoints = [
        {
          kind = "host";
          name = "destination-endpoint";
          tenant = "destination";
          ipv4 = [ "10.27.71.10" ];
          ipv6 = [ "fd42:270:71::10" ];
        }
      ];
    };
    pools = {
      loopback = {
        ipv4 = "10.27.0.0/24";
        ipv6 = "fd42:270:ff::/118";
      };
      p2p = {
        ipv4 = "10.27.255.0/24";
        ipv6 = "fd42:270:fe::/118";
      };
    };
    topology = {
      links = [
        [
          "access-source"
          "downstream-selector"
        ]
        [
          "access-destination"
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
          "core-vlan4"
        ]
      ];
      nodes = {
        access-source = {
          role = "access";
          attachments = [
            {
              kind = "tenant";
              name = "source";
            }
          ];
        };
        access-destination = {
          role = "access";
          attachments = [
            {
              kind = "tenant";
              name = "destination";
            }
          ];
        };
        downstream-selector.role = "downstream-selector";
        policy.role = "policy";
        upstream-selector.role = "upstream-selector";
        core-vlan4 = {
          role = "core";
          external = "internet-vlan4";
          uplinks.internet-vlan4 = {
            ipv4 = [ "0.0.0.0/0" ];
            ipv6 = [ "::/0" ];
          };
        };
      };
    };
  };
}
