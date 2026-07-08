{
  mini-smt = {
    FS-800-HDS-010-SDS-020-SMS-010 = {
      communicationContract = {
        interfaceTags = {
          external-fake-isp = "fake-isp";
          tenant-client = "client";
        };
        relations = [
          {
            id = "FS-800-HDS-010-SDS-020-SMS-010__mini-verify";
            action = "allow";
            from = {
              kind = "tenant";
              name = "client";
            };
            to = {
              kind = "external";
              uplinks = [ "fake-isp" ];
            };
            trafficType = "any";
            priority = 100;
          }
        ];
        services = [ ];
        trafficTypes = [ {
            name = "any";
            match = [ {
                family = "any";
                proto = "any";
              } ];
          } ];
      };
      ownership = {
        prefixes = [ {
            kind = "tenant";
            name = "client";
            ipv4 = "10.3.32.0/24";
            ipv6 = "fd42:0320:50::/64";
          } ];
      };
      pools = {
        loopback = {
          ipv4 = "10.3.0.0/24";
          ipv6 = "fd42:0320:ff::/118";
        };
        p2p = {
          ipv4 = "10.3.255.0/24";
          ipv6 = "fd42:0320:fe::/118";
        };
      };
      topology = {
        links = [
          [ "client-edge" "downstream-selector" ]
          [ "downstream-selector" "policy" ]
          [ "policy" "upstream-selector" ]
          [ "upstream-selector" "core-fake-isp" ]
        ];
        nodes = {
          client-edge = {
            role = "access";
            attachments = [ {
                kind = "tenant";
                name = "client";
              } ];
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
          core-fake-isp = {
            role = "core";
            external = "fake-isp";
            uplinks = {
              fake-isp = {
                ipv4 = [ "203.0.113.1/32" ];
                ipv6 = [ "2001:db8:113::1/128" ];
              };
            };
          };
        };
      };
    };
  };
}
