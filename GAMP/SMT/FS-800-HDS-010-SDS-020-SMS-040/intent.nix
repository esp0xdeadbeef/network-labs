# Row-local mini-SMT intent fixture for FS-800-HDS-010-SDS-020-SMS-040
# Provider-Access Fabric Gateway Routing — self-contained topology fixture
# This replaces the former staged mini-SMT import per row-local-only policy.

{
  "mini-smt" = {
    "FS-800-HDS-010-SDS-020-SMS-040" = {
      communicationContract = {
        interfaceTags = {
          external-isp = "isp";
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
            ipv6 = "2001:db8:800:113::/64";
          }
        ];
      };
      pools = {
        loopback = {
          ipv4 = "10.80.0.0/24";
          ipv6 = "fd42:800:20:ff::/118";
        };
        p2p = {
          ipv4 = "10.80.255.0/24";
          ipv6 = "fd42:800:20:fe::/118";
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
            uplinks = {
              isp = {
                ipv4 = [ "0.0.0.0/0" ];
                ipv6 = [ "::/0" ];
              };
            };
          };
          pppoe-core = {
            role = "core";
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
