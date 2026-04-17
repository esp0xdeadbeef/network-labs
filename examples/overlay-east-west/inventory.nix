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

        bridgeNetworks = {
          br-site-a-core-upstream = { };
          br-site-a-upstream-policy = { };
          br-site-a-policy-downstream = { };
          br-site-a-downstream-access = { };

          br-site-b-core-upstream = { };
          br-site-b-upstream-policy = { };
          br-site-b-policy-downstream = { };
          br-site-b-downstream-access = { };
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
        containers = {
          default = {
            runtimeName = "default";
          };
        };
        ports = {
          upstream-selector = {
            link = "p2p-s-router-core-s-router-upstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-core-upstream";
            };
            interface = {
              name = "ens3";
            };
          };

          isp = {
            uplink = "isp";
            external = true;
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

      enterprise-a-site-a-s-router-upstream-selector = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "enterprise-a";
          site = "site-a";
          name = "s-router-upstream-selector";
        };
        containers = {
          default = {
            runtimeName = "default";
          };
        };
        ports = {
          core = {
            link = "p2p-s-router-core-s-router-upstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-core-upstream";
            };
            interface = {
              name = "ens3";
            };
          };

          policy = {
            link = "p2p-s-router-policy-s-router-upstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-upstream-policy";
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
        containers = {
          default = {
            runtimeName = "default";
          };
        };
        ports = {
          upstream-selector = {
            link = "p2p-s-router-policy-s-router-upstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-upstream-policy";
            };
            interface = {
              name = "ens3";
            };
          };

          downstream-selector = {
            link = "p2p-s-router-downstream-selector-s-router-policy";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-policy-downstream";
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
        containers = {
          default = {
            runtimeName = "default";
          };
        };
        ports = {
          policy = {
            link = "p2p-s-router-downstream-selector-s-router-policy";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-policy-downstream";
            };
            interface = {
              name = "ens3";
            };
          };

          access = {
            link = "p2p-s-router-access-s-router-downstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-downstream-access";
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
        containers = {
          default = {
            runtimeName = "default";
          };
        };
        ports = {
          transit-downstream-selector = {
            link = "p2p-s-router-access-s-router-downstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-downstream-access";
            };
            interface = {
              name = "ens3";
            };
          };
        };
        advertisements = {
          dhcp4 = {
            tenant-mgmt = {
              pool = {
                start = "10.20.10.100";
                end = "10.20.10.200";
              };
              dnsServers = [ "router-self" ];
              domain = "lan.";
            };
          };
          ipv6Ra = {
            tenant-mgmt = {
              rdnss = [ "router-self" ];
              dnssl = [ "lan." ];
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
        containers = {
          default = {
            runtimeName = "default";
          };
        };
        ports = {
          upstream-selector = {
            link = "p2p-s-router-core-s-router-upstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-core-upstream";
            };
            interface = {
              name = "ens13";
            };
          };

          isp = {
            uplink = "isp";
            external = true;
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

      enterprise-b-site-b-s-router-upstream-selector = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "enterprise-b";
          site = "site-b";
          name = "s-router-upstream-selector";
        };
        containers = {
          default = {
            runtimeName = "default";
          };
        };
        ports = {
          core = {
            link = "p2p-s-router-core-s-router-upstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-core-upstream";
            };
            interface = {
              name = "ens13";
            };
          };

          policy = {
            link = "p2p-s-router-policy-s-router-upstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-upstream-policy";
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
        containers = {
          default = {
            runtimeName = "default";
          };
        };
        ports = {
          upstream-selector = {
            link = "p2p-s-router-policy-s-router-upstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-upstream-policy";
            };
            interface = {
              name = "ens13";
            };
          };

          downstream-selector = {
            link = "p2p-s-router-downstream-selector-s-router-policy";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-policy-downstream";
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
        containers = {
          default = {
            runtimeName = "default";
          };
        };
        ports = {
          policy = {
            link = "p2p-s-router-downstream-selector-s-router-policy";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-policy-downstream";
            };
            interface = {
              name = "ens13";
            };
          };

          access = {
            link = "p2p-s-router-access-s-router-downstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-downstream-access";
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
        containers = {
          default = {
            runtimeName = "default";
          };
        };
        ports = {
          transit-downstream-selector = {
            link = "p2p-s-router-access-s-router-downstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-downstream-access";
            };
            interface = {
              name = "ens13";
            };
          };
        };
        advertisements = {
          dhcp4 = {
            tenant-mgmt = {
              pool = {
                start = "10.30.10.100";
                end = "10.30.10.200";
              };
              dnsServers = [ "router-self" ];
              domain = "lan.";
            };
          };
          ipv6Ra = {
            tenant-mgmt = {
              rdnss = [ "router-self" ];
              dnssl = [ "lan." ];
            };
          };
        };
      };
    };
  };
}
