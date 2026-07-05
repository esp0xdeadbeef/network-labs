{
  mini-smt = {
    FS-030-HDS-010-SDS-030-SMS-010 = {
      communicationContract = {
        interfaceTags = {
          external-east-west = "east-west";
          external-testnet = "testnet";
          tenant-client = "client";
        };
        relations = [
          {
            id = "FS-030-HDS-010-SDS-030-SMS-010__overlay-payload";
            action = "allow";
            from = {
              kind = "tenant";
              name = "client";
            };
            to = {
              kind = "external";
              name = "east-west";
            };
            trafficType = "any";
            priority = 100;
          }
          {
            id = "FS-030-HDS-010-SDS-030-SMS-010__overlay-underlay";
            action = "allow";
            from = {
              kind = "external";
              name = "east-west";
            };
            to = {
              kind = "external";
              uplinks = [ "testnet" ];
            };
            trafficType = "nebula";
            priority = 110;
          }
          {
            id = "FS-030-HDS-010-SDS-030-SMS-010__underlay-access-egress";
            action = "allow";
            from = {
              kind = "tenant";
              name = "client";
            };
            to = {
              kind = "external";
              uplinks = [ "testnet" ];
            };
            trafficType = "nebula";
            priority = 105;
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
          {
            name = "nebula";
            match = [
              {
                family = "any";
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
            name = "client";
            ipv4 = "10.0.30.0/24";
            ipv6 = "fd42:001e:50::/64";
          }
        ];
      };
      pools = {
        loopback = {
          ipv4 = "10.0.0.0/24";
          ipv6 = "fd42:001e:ff::/118";
        };
        p2p = {
          ipv4 = "10.0.255.0/24";
          ipv6 = "fd42:001e:fe::/118";
        };
      };
      topology = {
        links = [
          [ "client-edge" "downstream-selector" ]
          [ "downstream-selector" "policy" ]
          [ "policy" "upstream-selector" ]
          [ "upstream-selector" "overlay-core" ]
          [ "upstream-selector" "vlan4-client-dhcp-slaac" ]
        ];
        nodes = {
          client-edge = {
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
          overlay-core = {
            role = "core";
            uplinks = {
              east-west = {
                ipv4 = [ "100.96.30.0/24" ];
                ipv6 = [ "fd42:001e:ee::/64" ];
              };
            };
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
      transport = {
        overlays = [
          {
            name = "east-west";
            peerSite = "mini-smt.peer";
            terminateOn = "overlay-core";
            underlayAccess = {
              kind = "tenant";
              name = "client";
            };
            underlayTrafficTypes = [ "nebula" ];
            mustTraverse = [ "policy" ];
          }
        ];
      };
    };
  };
}
