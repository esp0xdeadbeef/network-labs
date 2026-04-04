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
      esp0xdeadbeef-site-a-s-router-core-isp-a = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-a";
          name = "s-router-core-isp-a";
        };
        ports = {
          upstream-selector = {
            link = "p2p-s-router-core-isp-a-s-router-upstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens3";
            };
          };
        };
      };

      esp0xdeadbeef-site-a-s-router-core-isp-b = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-a";
          name = "s-router-core-isp-b";
        };
        ports = {
          upstream-selector = {
            link = "p2p-s-router-core-isp-b-s-router-upstream-selector";
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
          core-isp-a = {
            link = "p2p-s-router-core-isp-a-s-router-upstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens3";
            };
          };

          core-isp-b = {
            link = "p2p-s-router-core-isp-b-s-router-upstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens4";
            };
          };

          policy = {
            link = "p2p-s-router-policy-s-router-upstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens5";
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

          access-adm = {
            link = "p2p-s-router-access-adm-s-router-policy";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens4";
            };
          };

          access-mgmt = {
            link = "p2p-s-router-access-mgmt-s-router-policy";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens5";
            };
          };
        };
      };

      esp0xdeadbeef-site-a-s-router-access-adm = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-a";
          name = "s-router-access-adm";
        };
        ports = {
          transit-policy = {
            link = "p2p-s-router-access-adm-s-router-policy";
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

      esp0xdeadbeef-site-b-s-router-core-isp-a = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-b";
          name = "s-router-core-isp-a";
        };
        ports = {
          upstream-selector = {
            link = "p2p-s-router-core-isp-a-s-router-upstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens13";
            };
          };
        };
      };

      esp0xdeadbeef-site-b-s-router-core-isp-b = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-b";
          name = "s-router-core-isp-b";
        };
        ports = {
          upstream-selector = {
            link = "p2p-s-router-core-isp-b-s-router-upstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens13";
            };
          };
        };
      };

      esp0xdeadbeef-site-b-s-router-upstream-selector = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-b";
          name = "s-router-upstream-selector";
        };
        ports = {
          core-isp-a = {
            link = "p2p-s-router-core-isp-a-s-router-upstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens13";
            };
          };

          core-isp-b = {
            link = "p2p-s-router-core-isp-b-s-router-upstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens14";
            };
          };

          policy = {
            link = "p2p-s-router-policy-s-router-upstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens15";
            };
          };
        };
      };

      esp0xdeadbeef-site-b-s-router-policy = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
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

          access = {
            link = "p2p-s-router-access-s-router-policy";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens14";
            };
          };
        };
      };

      esp0xdeadbeef-site-b-s-router-access = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-b";
          name = "s-router-access";
        };
        ports = {
          transit-policy = {
            link = "p2p-s-router-access-s-router-policy";
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
