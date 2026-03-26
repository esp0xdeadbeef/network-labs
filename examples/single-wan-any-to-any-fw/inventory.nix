{
  deployment = {
    hosts = {
      lab-host = {
        uplinks = {
          uplink0 = {
            parent = "eno1";
            bridge = "br-uplink0";
          };
        };
      };
    };
  };

  realization = {
    nodes = {
      esp0xdeadbeef-site-a-s-router-core-wan = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-a";
          name = "s-router-core-wan";
        };
        ports = {
          upstream-selector = {
            link = "p2p-s-router-core-wan-s-router-upstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens3";
            };
          };
        };
      };

      esp0xdeadbeef-site-a-s-router-upstream-selector = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-a";
          name = "s-router-upstream-selector";
        };
        ports = {
          core-wan = {
            link = "p2p-s-router-core-wan-s-router-upstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens3";
            };
          };

          policy = {
            link = "p2p-s-router-policy-s-router-upstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens4";
            };
          };
        };
      };

      esp0xdeadbeef-site-a-s-router-policy = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-a";
          name = "s-router-policy";
        };
        ports = {
          upstream-selector = {
            link = "p2p-s-router-policy-s-router-upstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens3";
            };
          };

          access-client = {
            link = "p2p-s-router-access-client-s-router-policy";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens4";
            };
          };

          access-admin = {
            link = "p2p-s-router-access-admin-s-router-policy";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens5";
            };
          };

          access-mgmt = {
            link = "p2p-s-router-access-mgmt-s-router-policy";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens6";
            };
          };
        };
      };

      esp0xdeadbeef-site-a-s-router-access-client = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-a";
          name = "s-router-access-client";
        };
        ports = {
          transit-policy = {
            link = "p2p-s-router-access-client-s-router-policy";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens3";
            };
          };
        };
      };

      esp0xdeadbeef-site-a-s-router-access-admin = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-a";
          name = "s-router-access-admin";
        };
        ports = {
          transit-policy = {
            link = "p2p-s-router-access-admin-s-router-policy";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens3";
            };
          };
        };
      };

      esp0xdeadbeef-site-a-s-router-access-mgmt = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-a";
          name = "s-router-access-mgmt";
        };
        ports = {
          transit-policy = {
            link = "p2p-s-router-access-mgmt-s-router-policy";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens3";
            };
          };
        };
      };
    };
  };
}
