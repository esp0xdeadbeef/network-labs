{
  deployment = {
    hosts = {
      lab-host = {
        uplinks = {
          uplink0 = {
            parent = "eno1";
            bridge = "br-uplink0";
            ipv4 = {
              method = "dhcp";
            };
            ipv6 = {
              method = "slaac";
            };
          };
        };
      };
    };
  };

  realization = {
    nodes = {
      esp0xdeadbeef-site-a-s-router-core = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-a";
          name = "s-router-core";
        };
        ports = {
          upstream-selector = {
            link = "p2p-s-router-core-s-router-upstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens3";
            };
          };

          wan = {
            upstream = "uplink0";
            link = "wan";
            attach = {
              kind = "bridge";
              bridge = "br-uplink0";
            };
            interface = {
              name = "ens4";
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
          core = {
            link = "p2p-s-router-core-s-router-upstream-selector";
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

          downstream-selector = {
            link = "p2p-s-router-downstream-selector-s-router-policy";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens4";
            };
          };
        };
      };

      esp0xdeadbeef-site-a-s-router-downstream-selector = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-a";
          name = "s-router-downstream-selector";
        };
        ports = {
          policy = {
            link = "p2p-s-router-downstream-selector-s-router-policy";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens3";
            };
          };

          access-mgmt = {
            link = "p2p-s-router-access-mgmt-s-router-downstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens4";
            };
          };

          access-admin = {
            link = "p2p-s-router-access-admin-s-router-downstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens5";
            };
          };

          access-clients = {
            link = "p2p-s-router-access-clients-s-router-downstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens6";
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
          transit-downstream-selector = {
            link = "p2p-s-router-access-mgmt-s-router-downstream-selector";
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
          transit-downstream-selector = {
            link = "p2p-s-router-access-admin-s-router-downstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens3";
            };
          };
        };
      };

      esp0xdeadbeef-site-a-s-router-access-clients = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-a";
          name = "s-router-access-clients";
        };
        ports = {
          transit-downstream-selector = {
            link = "p2p-s-router-access-clients-s-router-downstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens3";
            };
          };
        };
      };

      esp0xdeadbeef-2-site-b-s-router-core = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef-2";
          site = "site-b";
          name = "s-router-core";
        };
        ports = {
          upstream-selector = {
            link = "p2p-s-router-core-s-router-upstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens13";
            };
          };

          wan = {
            upstream = "uplink0";
            link = "wan";
            attach = {
              kind = "bridge";
              bridge = "br-uplink0";
            };
            interface = {
              name = "ens14";
            };
          };
        };
      };

      esp0xdeadbeef-2-site-b-s-router-upstream-selector = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef-2";
          site = "site-b";
          name = "s-router-upstream-selector";
        };
        ports = {
          core = {
            link = "p2p-s-router-core-s-router-upstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens13";
            };
          };

          policy = {
            link = "p2p-s-router-policy-s-router-upstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens14";
            };
          };
        };
      };

      esp0xdeadbeef-2-site-b-s-router-policy = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef-2";
          site = "site-b";
          name = "s-router-policy";
        };
        ports = {
          upstream-selector = {
            link = "p2p-s-router-policy-s-router-upstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens13";
            };
          };

          downstream-selector = {
            link = "p2p-s-router-downstream-selector-s-router-policy";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens14";
            };
          };
        };
      };

      esp0xdeadbeef-2-site-b-s-router-downstream-selector = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef-2";
          site = "site-b";
          name = "s-router-downstream-selector";
        };
        ports = {
          policy = {
            link = "p2p-s-router-downstream-selector-s-router-policy";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens13";
            };
          };

          access-mgmt = {
            link = "p2p-s-router-access-mgmt-s-router-downstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens14";
            };
          };

          access-admin = {
            link = "p2p-s-router-access-admin-s-router-downstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens15";
            };
          };

          access-clients = {
            link = "p2p-s-router-access-clients-s-router-downstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens16";
            };
          };
        };
      };

      esp0xdeadbeef-2-site-b-s-router-access-mgmt = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef-2";
          site = "site-b";
          name = "s-router-access-mgmt";
        };
        ports = {
          transit-downstream-selector = {
            link = "p2p-s-router-access-mgmt-s-router-downstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens13";
            };
          };
        };
      };

      esp0xdeadbeef-2-site-b-s-router-access-admin = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef-2";
          site = "site-b";
          name = "s-router-access-admin";
        };
        ports = {
          transit-downstream-selector = {
            link = "p2p-s-router-access-admin-s-router-downstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens13";
            };
          };
        };
      };

      esp0xdeadbeef-2-site-b-s-router-access-clients = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef-2";
          site = "site-b";
          name = "s-router-access-clients";
        };
        ports = {
          transit-downstream-selector = {
            link = "p2p-s-router-access-clients-s-router-downstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens13";
            };
          };
        };
      };
    };
  };
}
