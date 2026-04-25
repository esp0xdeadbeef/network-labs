{
  controlPlane = {
    sites = {
      "enterprise-a" = {
        "site-a" = {
          overlays = {
            "east-west" = {
              provider = "nebula";
              nodes = {
                "s-router-core-nebula" = {
                  addr4 = "100.64.100.1/32";
                };
              };
            };
          };
        };
      };

      "enterprise-b" = {
        "site-b" = {
          overlays = {
            "east-west" = {
              provider = "nebula";
              nodes = {
                "s-router-core-nebula" = {
                  addr4 = "100.64.100.2/32";
                };
              };
            };
          };
        };
      };
    };
  };

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

          east-west-site-a = {
            parent = "eno2";
            bridge = "br-site-a-core-nebula-east-west";
            ipv4.method = "dhcp";
            ipv6.method = "slaac";
          };

          east-west-site-b = {
            parent = "eno3";
            bridge = "br-site-b-core-nebula-east-west";
            ipv4.method = "dhcp";
            ipv6.method = "slaac";
          };
        };

        bridgeNetworks = {
          br-site-a-core-wan-upstream = { };
          br-site-a-core-nebula-upstream = { };
          br-site-a-policy-upstream-access-east-west = { };
          br-site-a-downstream-policy-access = { };
          br-site-a-downstream-access = { };

          br-site-b-core-wan-upstream = { };
          br-site-b-core-nebula-upstream = { };
          br-site-b-policy-upstream-access-east-west = { };
          br-site-b-downstream-policy-access = { };
          br-site-b-downstream-access = { };
        };
      };
    };
  };

  realization = {
    nodes = {
      enterprise-a-site-a-s-router-core-wan = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "enterprise-a";
          site = "site-a";
          name = "s-router-core-wan";
        };
        containers = {
          default = {
            runtimeName = "default";
          };
        };
        ports = {
          upstream-selector = {
            link = "p2p-s-router-core-wan-s-router-upstream-selector";
            adapterName = "adp-enterprise-a-site-a-s-router-core-wan-upstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-core-wan-upstream";
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

      enterprise-a-site-a-s-router-core-nebula = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "enterprise-a";
          site = "site-a";
          name = "s-router-core-nebula";
        };
        containers.default.runtimeName = "default";
        ports = {
          upstream-selector = {
            link = "p2p-s-router-core-nebula-s-router-upstream-selector";
            adapterName = "adp-enterprise-a-site-a-s-router-core-nebula-upstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-core-nebula-upstream";
            };
            interface.name = "ens3";
          };

          east-west = {
            uplink = "east-west";
            external = true;
            attach = {
              kind = "bridge";
              bridge = "br-site-a-core-nebula-east-west";
            };
            interface.name = "ens4";
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
          core-wan = {
            link = "p2p-s-router-core-wan-s-router-upstream-selector";
            adapterName = "adp-enterprise-a-site-a-s-router-upstream-selector-core-wan";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-core-wan-upstream";
            };
            interface = {
              name = "ens3";
            };
          };

          core-nebula = {
            link = "p2p-s-router-core-nebula-s-router-upstream-selector";
            adapterName = "adp-enterprise-a-site-a-s-router-upstream-selector-core-nebula";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-core-nebula-upstream";
            };
            interface.name = "ens5";
          };

          policy-access-east-west = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access--uplink-east-west";
            adapterName = "adp-enterprise-a-site-a-s-router-upstream-selector-policy-access-east-west";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-east-west";
            interface.name = "ens4";
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
          upstream-access-east-west = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access--uplink-east-west";
            adapterName = "adp-enterprise-a-site-a-s-router-policy-upstream-access-east-west";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-east-west";
            interface.name = "ens3";
          };

          downstream-access = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access";
            adapterName = "adp-enterprise-a-site-a-s-router-policy-downstream-access";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-downstream-policy-access";
            interface.name = "ens4";
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
          policy-access = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access";
            adapterName = "adp-enterprise-a-site-a-s-router-downstream-selector-policy-access";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-downstream-policy-access";
            interface.name = "ens3";
          };

          access = {
            link = "p2p-s-router-access-s-router-downstream-selector";
            adapterName = "adp-enterprise-a-site-a-s-router-downstream-selector-access";
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
            adapterName = "adp-enterprise-a-site-a-s-router-access-transit-downstream-selector";
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

      enterprise-b-site-b-s-router-core-wan = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "enterprise-b";
          site = "site-b";
          name = "s-router-core-wan";
        };
        containers = {
          default = {
            runtimeName = "default";
          };
        };
        ports = {
          upstream-selector = {
            link = "p2p-s-router-core-wan-s-router-upstream-selector";
            adapterName = "adp-enterprise-b-site-b-s-router-core-wan-upstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-core-wan-upstream";
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

      enterprise-b-site-b-s-router-core-nebula = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "enterprise-b";
          site = "site-b";
          name = "s-router-core-nebula";
        };
        containers.default.runtimeName = "default";
        ports = {
          upstream-selector = {
            link = "p2p-s-router-core-nebula-s-router-upstream-selector";
            adapterName = "adp-enterprise-b-site-b-s-router-core-nebula-upstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-core-nebula-upstream";
            };
            interface.name = "ens13";
          };

          east-west = {
            uplink = "east-west";
            external = true;
            attach = {
              kind = "bridge";
              bridge = "br-site-b-core-nebula-east-west";
            };
            interface.name = "ens14";
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
          core-wan = {
            link = "p2p-s-router-core-wan-s-router-upstream-selector";
            adapterName = "adp-enterprise-b-site-b-s-router-upstream-selector-core-wan";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-core-wan-upstream";
            };
            interface = {
              name = "ens13";
            };
          };

          core-nebula = {
            link = "p2p-s-router-core-nebula-s-router-upstream-selector";
            adapterName = "adp-enterprise-b-site-b-s-router-upstream-selector-core-nebula";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-core-nebula-upstream";
            };
            interface.name = "ens15";
          };

          policy-access-east-west = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access--uplink-east-west";
            adapterName = "adp-enterprise-b-site-b-s-router-upstream-selector-policy-access-east-west";
            attach.kind = "bridge";
            attach.bridge = "br-site-b-policy-upstream-access-east-west";
            interface.name = "ens14";
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
          upstream-access-east-west = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access--uplink-east-west";
            adapterName = "adp-enterprise-b-site-b-s-router-policy-upstream-access-east-west";
            attach.kind = "bridge";
            attach.bridge = "br-site-b-policy-upstream-access-east-west";
            interface.name = "ens13";
          };

          downstream-access = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access";
            adapterName = "adp-enterprise-b-site-b-s-router-policy-downstream-access";
            attach.kind = "bridge";
            attach.bridge = "br-site-b-downstream-policy-access";
            interface.name = "ens14";
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
          policy-access = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access";
            adapterName = "adp-enterprise-b-site-b-s-router-downstream-selector-policy-access";
            attach.kind = "bridge";
            attach.bridge = "br-site-b-downstream-policy-access";
            interface.name = "ens13";
          };

          access = {
            link = "p2p-s-router-access-s-router-downstream-selector";
            adapterName = "adp-enterprise-b-site-b-s-router-downstream-selector-access";
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
            adapterName = "adp-enterprise-b-site-b-s-router-access-transit-downstream-selector";
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
