{
  endpoints = {
    web01 = {
      ipv4 = [ "10.20.15.10" ];
      ipv6 = [ "fd42:dead:beef:15::10" ];
    };

    s-sigma = {
      ipv4 = [ "10.20.10.10" ];
      ipv6 = [ "fd42:dead:beef:10::10" ];
    };
  };

  fabric = {
    s-router-access-admin = {
      platform = "linux";
      ports = {
        transit-policy = {
          kind = "p2p";
          link = "p2p-s-router-access-admin-s-router-policy";
          vlan = 100;
        };

        tenant-admin = {
          attachment = {
            kind = "tenant";
            name = "admin";
          };
          hosts = [ "web01" ];
        };
      };
    };

    s-router-access-client = {
      platform = "linux";
      ports = {
        transit-policy = {
          kind = "p2p";
          link = "p2p-s-router-access-client-s-router-policy";
          vlan = 102;
        };
      };
    };

    s-router-access-mgmt = {
      platform = "linux";
      ports = {
        transit-policy = {
          kind = "p2p";
          link = "p2p-s-router-access-mgmt-s-router-policy";
          vlan = 101;
        };

        tenant-mgmt = {
          attachment = {
            kind = "tenant";
            name = "mgmt";
          };
          hosts = [ "s-sigma" ];
        };
      };
    };

    s-router-policy = {
      platform = "linux";
      ports = {
        transit-admin = {
          kind = "p2p";
          link = "p2p-s-router-access-admin-s-router-policy";
          vlan = 100;
        };

        transit-client = {
          kind = "p2p";
          link = "p2p-s-router-access-client-s-router-policy";
          vlan = 102;
        };

        transit-mgmt = {
          kind = "p2p";
          link = "p2p-s-router-access-mgmt-s-router-policy";
          vlan = 101;
        };

        upstream-selector = {
          kind = "p2p";
          link = "p2p-s-router-policy-s-router-upstream-selector";
          vlan = 201;
        };
      };
    };

    s-router-core-wan = {
      platform = "linux";
      ports = {
        upstream-selector = {
          kind = "p2p";
          link = "p2p-s-router-core-wan-s-router-upstream-selector";
          vlan = 200;
        };

        wan = {
          attachment = {
            kind = "external";
            name = "wan";
          };
        };
      };
    };

    s-router-upstream-selector = {
      platform = "linux";
      ports = {
        core = {
          kind = "p2p";
          link = "p2p-s-router-core-wan-s-router-upstream-selector";
          vlan = 200;
        };

        policy = {
          kind = "p2p";
          link = "p2p-s-router-policy-s-router-upstream-selector";
          vlan = 201;
        };
      };
    };
  };
}
