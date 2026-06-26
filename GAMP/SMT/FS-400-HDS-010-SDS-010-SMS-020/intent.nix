{
  "mini-smt" = {
    "ula-nat66-selection" = {
      communicationContract = {
        interfaceTags = {
          external-wan = "wan";
          tenant-residential = "residential";
        };
        relations = [
          {
            id = "FS-400-HDS-010-SDS-010-SMS-020__mini-ula-nat66-tenant-to-wan";
            action = "allow";
            from = {
              kind = "tenant";
              name = "residential";
            };
            to = {
              kind = "external";
              name = "wan";
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
      topology = {
        links = [
          [
            "residential-edge"
            "wan-edge"
          ]
        ];
        nodes = {
          residential-edge = {
            role = "access";
            attachments = [
              {
                kind = "tenant";
                name = "residential";
              }
            ];
          };
          wan-edge = {
            role = "external";
            external = "wan";
          };
        };
      };
      tenants = {
        residential = {
          name = "residential";
          prefixAssignments = {
            ipv6 = {
              ula = {
                prefix = "fd42:dead:beef::/48";
                internetMode = "nat66";
                nat66EgressPrefix = "2001:db8:abcd::/48";
              };
            };
          };
        };
      };
      externals = {
        wan = {
          name = "wan";
          kind = "wan";
          uplink = {
            ipv6 = {
              method = "slaac";
              egressAuthority = true;
              nat66Egress = {
                prefix = "2001:db8:abcd::/48";
              };
            };
          };
        };
      };
    };
  };
}
