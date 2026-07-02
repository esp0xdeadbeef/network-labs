{
  mini-smt = {
    FS-800-HDS-010-SDS-020-SMS-040 = {
      communicationContract = {
        interfaceTags = {
          external-isp = "isp";
          external-pppoe-provider = "pppoe-provider";
          tenant-provider-handoff-a = "provider-handoff-a";
        };
        relations = [
          {
            id = "FS-800-HDS-010-SDS-020-SMS-040__mini-provider-handoff-to-internet";
            action = "allow";
            from = {
              kind = "tenant";
              name = "provider-handoff-a";
            };
            to = {
              kind = "external";
              uplinks = [ "isp" ];
            };
            trafficType = "any";
            priority = 100;
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
      ownership = {
        prefixes = [
          {
            kind = "tenant";
            name = "provider-handoff-a";
            ipv4 = "203.0.113.0/24";
            ipv6 = "2001:db8:800:20::/64";
          }
        ];
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
          [
            "provider-handoff-access-a"
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
            "fabric-core"
          ]
          [
            "upstream-selector"
            "pppoe-core"
          ]
        ];
        nodes = {
          provider-handoff-access-a = {
            role = "access";
            attachments = [
              {
                kind = "tenant";
                name = "provider-handoff-a";
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
          fabric-core = {
            role = "core";
            external = "isp";
            uplinks = {
              isp = {
                ipv4 = [ "0.0.0.0/0" ];
                ipv6 = [ "::/0" ];
              };
            };
          };
          pppoe-core = {
            role = "core";
            external = "pppoe-provider";
            uplinks = {
              pppoe-provider = {
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
