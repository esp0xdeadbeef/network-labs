{
  mini-smt.FS-260-HDS-010-SDS-010-SMS-010 = {
    communicationContract = {
      interfaceTags = {
        external-internet-vlan4 = "internet-vlan4";
        tenant-source = "source";
        tenant-destination = "destination";
      };
      relations = [
        {
          id = "FS-260-HDS-010-SDS-010-SMS-010__deny-reverse-new-flow";
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
          id = "FS-260-HDS-010-SDS-010-SMS-010__policy-required-access-return";
          priority = 100;
          from = {
            kind = "tenant";
            name = "source";
          };
          to = {
            kind = "tenant";
            name = "destination";
          };
          trafficType = "any";
          action = "allow";
          returnBehavior = "symmetric";
        }
        {
          id = "FS-260-HDS-010-SDS-010-SMS-010__source-to-test-uplink";
          priority = 200;
          from = {
            kind = "tenant";
            name = "source";
          };
          to = {
            kind = "external";
            uplinks = [ "internet-vlan4" ];
          };
          trafficType = "any";
          action = "allow";
          returnBehavior = "symmetric";
        }
      ];
      services = [ ];
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
    ownership.prefixes = [
      {
        kind = "tenant";
        name = "source";
        ipv4 = "10.2.60.0/24";
        ipv6 = "fd42:0104:60::/64";
      }
      {
        kind = "tenant";
        name = "destination";
        ipv4 = "10.2.61.0/24";
        ipv6 = "fd42:0104:61::/64";
      }
    ];
    pools = {
      loopback = {
        ipv4 = "10.2.0.0/24";
        ipv6 = "fd42:0104:ff::/118";
      };
      p2p = {
        ipv4 = "10.2.255.0/24";
        ipv6 = "fd42:0104:fe::/118";
      };
    };
    topology = {
      links = [
        [ "access-source" "downstream-selector" ]
        [ "access-destination" "downstream-selector" ]
        [ "downstream-selector" "policy" ]
        [ "policy" "upstream-selector" ]
        [ "upstream-selector" "core-vlan4" ]
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
