{
  controlPlane = {
    sites = {
      "enterprise-a" = {
        "site-a" = {
          overlays = {
            "east-west" = {
              provider = "nebula";
              addr4 = "100.64.100.1/32";
            };
          };
        };
      };

      "enterprise-b" = {
        "site-b" = {
          overlays = {
            "east-west" = {
              provider = "nebula";
              addr4 = "100.64.100.2/32";
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
        };

        bridgeNetworks = {
          br-site-a-core-upstream = { };
          br-site-a-policy-upstream-access-east-west = { };
          br-site-a-downstream-policy-access = { };
          br-site-a-downstream-access = { };

          br-site-b-core-upstream = { };
          br-site-b-policy-upstream-access-east-west = { };
          br-site-b-downstream-policy-access = { };
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

          policy-access-east-west = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access--uplink-east-west";
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
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-east-west";
            interface.name = "ens3";
          };

          downstream-access = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access";
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
            attach.kind = "bridge";
            attach.bridge = "br-site-a-downstream-policy-access";
            interface.name = "ens3";
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

          policy-access-east-west = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access--uplink-east-west";
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
            attach.kind = "bridge";
            attach.bridge = "br-site-b-policy-upstream-access-east-west";
            interface.name = "ens13";
          };

          downstream-access = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access";
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
            attach.kind = "bridge";
            attach.bridge = "br-site-b-downstream-policy-access";
            interface.name = "ens13";
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
