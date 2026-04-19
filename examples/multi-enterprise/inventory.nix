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
          br-site-a-policy-upstream-access-mgmt-wan = { };
          br-site-a-policy-upstream-access-admin-wan = { };
          br-site-a-policy-upstream-access-clients-wan = { };

          br-site-a-downstream-policy-access-mgmt = { };
          br-site-a-downstream-policy-access-admin = { };
          br-site-a-downstream-policy-access-clients = { };

          br-site-a-downstream-mgmt = { };
          br-site-a-downstream-admin = { };
          br-site-a-downstream-clients = { };

          br-site-b-core-upstream = { };
          br-site-b-policy-upstream-access-mgmt-wan = { };
          br-site-b-policy-upstream-access-admin-wan = { };
          br-site-b-policy-upstream-access-clients-wan = { };

          br-site-b-downstream-policy-access-mgmt = { };
          br-site-b-downstream-policy-access-admin = { };
          br-site-b-downstream-policy-access-clients = { };

          br-site-b-downstream-mgmt = { };
          br-site-b-downstream-admin = { };
          br-site-b-downstream-clients = { };
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

          wan = {
            uplink = "wan";
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

      esp0xdeadbeef-site-a-s-router-upstream-selector = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
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

          policy-access-mgmt-wan = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-mgmt--uplink-wan";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-mgmt-wan";
            interface.name = "ens4";
          };

          policy-access-admin-wan = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-admin--uplink-wan";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-admin-wan";
            interface.name = "ens5";
          };

          policy-access-clients-wan = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-clients--uplink-wan";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-clients-wan";
            interface.name = "ens6";
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
        containers = {
          default = {
            runtimeName = "default";
          };
        };
        ports = {
          upstream-access-mgmt-wan = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-mgmt--uplink-wan";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-mgmt-wan";
            interface.name = "ens3";
          };

          upstream-access-admin-wan = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-admin--uplink-wan";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-admin-wan";
            interface.name = "ens4";
          };

          upstream-access-clients-wan = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-clients--uplink-wan";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-clients-wan";
            interface.name = "ens5";
          };

          downstream-access-mgmt = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-mgmt";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-downstream-policy-access-mgmt";
            interface.name = "ens6";
          };

          downstream-access-admin = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-admin";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-downstream-policy-access-admin";
            interface.name = "ens7";
          };

          downstream-access-clients = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-clients";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-downstream-policy-access-clients";
            interface.name = "ens8";
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
        containers = {
          default = {
            runtimeName = "default";
          };
        };
        ports = {
          policy-access-mgmt = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-mgmt";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-downstream-policy-access-mgmt";
            interface.name = "ens3";
          };

          policy-access-admin = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-admin";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-downstream-policy-access-admin";
            interface.name = "ens4";
          };

          policy-access-clients = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-clients";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-downstream-policy-access-clients";
            interface.name = "ens5";
          };

          access-mgmt = {
            link = "p2p-s-router-access-mgmt-s-router-downstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-downstream-mgmt";
            };
            interface = {
              name = "ens6";
            };
          };

          access-admin = {
            link = "p2p-s-router-access-admin-s-router-downstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-downstream-admin";
            };
            interface = {
              name = "ens7";
            };
          };

          access-clients = {
            link = "p2p-s-router-access-clients-s-router-downstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-downstream-clients";
            };
            interface = {
              name = "ens8";
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
        containers = {
          default = {
            runtimeName = "default";
          };
        };
        ports = {
          transit-downstream-selector = {
            link = "p2p-s-router-access-mgmt-s-router-downstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-downstream-mgmt";
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

      esp0xdeadbeef-site-a-s-router-access-admin = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-a";
          name = "s-router-access-admin";
        };
        containers = {
          default = {
            runtimeName = "default";
          };
        };
        ports = {
          transit-downstream-selector = {
            link = "p2p-s-router-access-admin-s-router-downstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-downstream-admin";
            };
            interface = {
              name = "ens3";
            };
          };
        };
        advertisements = {
          dhcp4 = {
            tenant-admin = {
              pool = {
                start = "10.20.15.100";
                end = "10.20.15.200";
              };
              dnsServers = [ "router-self" ];
              domain = "lan.";
            };
          };
          ipv6Ra = {
            tenant-admin = {
              rdnss = [ "router-self" ];
              dnssl = [ "lan." ];
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
        containers = {
          default = {
            runtimeName = "default";
          };
        };
        ports = {
          transit-downstream-selector = {
            link = "p2p-s-router-access-clients-s-router-downstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-downstream-clients";
            };
            interface = {
              name = "ens3";
            };
          };
        };
        advertisements = {
          dhcp4 = {
            tenant-clients = {
              pool = {
                start = "10.20.20.100";
                end = "10.20.20.200";
              };
              dnsServers = [ "router-self" ];
              domain = "lan.";
            };
          };
          ipv6Ra = {
            tenant-clients = {
              rdnss = [ "router-self" ];
              dnssl = [ "lan." ];
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

          wan = {
            uplink = "wan";
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

      esp0xdeadbeef-2-site-b-s-router-upstream-selector = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef-2";
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

          policy-access-mgmt-wan = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-mgmt--uplink-wan";
            attach.kind = "bridge";
            attach.bridge = "br-site-b-policy-upstream-access-mgmt-wan";
            interface.name = "ens14";
          };

          policy-access-admin-wan = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-admin--uplink-wan";
            attach.kind = "bridge";
            attach.bridge = "br-site-b-policy-upstream-access-admin-wan";
            interface.name = "ens15";
          };

          policy-access-clients-wan = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-clients--uplink-wan";
            attach.kind = "bridge";
            attach.bridge = "br-site-b-policy-upstream-access-clients-wan";
            interface.name = "ens16";
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
        containers = {
          default = {
            runtimeName = "default";
          };
        };
        ports = {
          upstream-access-mgmt-wan = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-mgmt--uplink-wan";
            attach.kind = "bridge";
            attach.bridge = "br-site-b-policy-upstream-access-mgmt-wan";
            interface.name = "ens13";
          };

          upstream-access-admin-wan = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-admin--uplink-wan";
            attach.kind = "bridge";
            attach.bridge = "br-site-b-policy-upstream-access-admin-wan";
            interface.name = "ens14";
          };

          upstream-access-clients-wan = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-clients--uplink-wan";
            attach.kind = "bridge";
            attach.bridge = "br-site-b-policy-upstream-access-clients-wan";
            interface.name = "ens15";
          };

          downstream-access-mgmt = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-mgmt";
            attach.kind = "bridge";
            attach.bridge = "br-site-b-downstream-policy-access-mgmt";
            interface.name = "ens16";
          };

          downstream-access-admin = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-admin";
            attach.kind = "bridge";
            attach.bridge = "br-site-b-downstream-policy-access-admin";
            interface.name = "ens17";
          };

          downstream-access-clients = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-clients";
            attach.kind = "bridge";
            attach.bridge = "br-site-b-downstream-policy-access-clients";
            interface.name = "ens18";
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
        containers = {
          default = {
            runtimeName = "default";
          };
        };
        ports = {
          policy-access-mgmt = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-mgmt";
            attach.kind = "bridge";
            attach.bridge = "br-site-b-downstream-policy-access-mgmt";
            interface.name = "ens13";
          };

          policy-access-admin = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-admin";
            attach.kind = "bridge";
            attach.bridge = "br-site-b-downstream-policy-access-admin";
            interface.name = "ens14";
          };

          policy-access-clients = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-clients";
            attach.kind = "bridge";
            attach.bridge = "br-site-b-downstream-policy-access-clients";
            interface.name = "ens15";
          };

          access-mgmt = {
            link = "p2p-s-router-access-mgmt-s-router-downstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-downstream-mgmt";
            };
            interface = {
              name = "ens16";
            };
          };

          access-admin = {
            link = "p2p-s-router-access-admin-s-router-downstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-downstream-admin";
            };
            interface = {
              name = "ens17";
            };
          };

          access-clients = {
            link = "p2p-s-router-access-clients-s-router-downstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-downstream-clients";
            };
            interface = {
              name = "ens18";
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
        containers = {
          default = {
            runtimeName = "default";
          };
        };
        ports = {
          transit-downstream-selector = {
            link = "p2p-s-router-access-mgmt-s-router-downstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-downstream-mgmt";
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

      esp0xdeadbeef-2-site-b-s-router-access-admin = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef-2";
          site = "site-b";
          name = "s-router-access-admin";
        };
        containers = {
          default = {
            runtimeName = "default";
          };
        };
        ports = {
          transit-downstream-selector = {
            link = "p2p-s-router-access-admin-s-router-downstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-downstream-admin";
            };
            interface = {
              name = "ens13";
            };
          };
        };
        advertisements = {
          dhcp4 = {
            tenant-admin = {
              pool = {
                start = "10.30.15.100";
                end = "10.30.15.200";
              };
              dnsServers = [ "router-self" ];
              domain = "lan.";
            };
          };
          ipv6Ra = {
            tenant-admin = {
              rdnss = [ "router-self" ];
              dnssl = [ "lan." ];
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
        containers = {
          default = {
            runtimeName = "default";
          };
        };
        ports = {
          transit-downstream-selector = {
            link = "p2p-s-router-access-clients-s-router-downstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-downstream-clients";
            };
            interface = {
              name = "ens13";
            };
          };
        };
        advertisements = {
          dhcp4 = {
            tenant-clients = {
              pool = {
                start = "10.30.20.100";
                end = "10.30.20.200";
              };
              dnsServers = [ "router-self" ];
              domain = "lan.";
            };
          };
          ipv6Ra = {
            tenant-clients = {
              rdnss = [ "router-self" ];
              dnssl = [ "lan." ];
            };
          };
        };
      };
    };
  };
}
