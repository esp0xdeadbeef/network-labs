{
  mini-smt = {
    FS-800-HDS-030-SDS-030-SMS-010 = {
      communicationContract = {
        interfaceTags = {
          pppoe-customer = "pppoe-client";
          pppoe-provider = "pppoe-provider";
        };
        relations = [
          {
            id = "FS-800-HDS-030-SDS-030-SMS-010__mini-pppoe-client-to-provider";
            action = "allow";
            from = {
              kind = "pppoe-customer";
              name = "pppoe-client";
            };
            to = {
              kind = "pppoe-provider";
              name = "pppoe-provider";
              uplinks = [ "pppoe-provider" ];
            };
            trafficType = "pppoe-session";
            priority = 100;
          }
        ];
        services = [ ];
        trafficTypes = [
          {
            name = "pppoe-session";
            match = [
              {
                family = "any";
                proto = "any";
              }
            ];
          }
        ];
      };
      pppoePairs = {
        primary = {
          provider = {
            target = "pppoe-provider";
            handoff = "pppoe";
            routeDeliveryClass = "connected";
          };
          customer = {
            target = "pppoe-client";
            coreInterface = "wan0";
            runtimeInterface = "ppp0";
            routeAuthority = "connected";
          };
          fallback = false;
          transportClassification = "pppoe";
        };
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
            "pppoe-client"
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
            "pppoe-provider"
          ]
        ];
        nodes = {
          pppoe-client = {
            role = "pppoe-client";
            interface = "wan0";
            runtimeInterface = "ppp0";
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
          pppoe-provider = {
            role = "pppoe-provider";
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
