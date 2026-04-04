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
      enterprise-a-site-a-s-router-core = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "enterprise-a";
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
        };
      };

      enterprise-a-site-a-s-router-upstream-selector = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "enterprise-a";
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

      enterprise-a-site-a-s-router-policy = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "enterprise-a";
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
            link = "p2p-s-router-policy-s-router-downstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens4";
            };
          };
        };
      };

      enterprise-a-site-a-s-router-downstream-selector = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "enterprise-a";
          site = "site-a";
          name = "s-router-downstream-selector";
        };
        ports = {
          policy = {
            link = "p2p-s-router-policy-s-router-downstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens3";
            };
          };

          access = {
            link = "p2p-s-router-access-s-router-downstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens4";
            };
          };
        };
      };

      enterprise-a-site-a-s-router-access = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "enterprise-a";
          site = "site-a";
          name = "s-router-access";
        };
        ports = {
          transit-downstream-selector = {
            link = "p2p-s-router-access-s-router-downstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens3";
            };
          };
        };
      };

      enterprise-b-site-b-s-router-core = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "enterprise-b";
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
        };
      };

      enterprise-b-site-b-s-router-upstream-selector = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "enterprise-b";
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

      enterprise-b-site-b-s-router-policy = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "enterprise-b";
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
            link = "p2p-s-router-policy-s-router-downstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens14";
            };
          };
        };
      };

      enterprise-b-site-b-s-router-downstream-selector = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "enterprise-b";
          site = "site-b";
          name = "s-router-downstream-selector";
        };
        ports = {
          policy = {
            link = "p2p-s-router-policy-s-router-downstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens13";
            };
          };

          access = {
            link = "p2p-s-router-access-s-router-downstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens14";
            };
          };
        };
      };

      enterprise-b-site-b-s-router-access = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "enterprise-b";
          site = "site-b";
          name = "s-router-access";
        };
        ports = {
          transit-downstream-selector = {
            link = "p2p-s-router-access-s-router-downstream-selector";
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
