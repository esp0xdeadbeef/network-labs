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
          br-site-stable-core-upstream = { };
          br-site-stable-policy-upstream-access-mgmt-wan = { };
          br-site-stable-policy-upstream-access-admin-wan = { };
          br-site-stable-policy-upstream-access-clients-wan = { };

          br-site-stable-downstream-policy-access-mgmt = { };
          br-site-stable-downstream-policy-access-admin = { };
          br-site-stable-downstream-policy-access-clients = { };

          br-site-stable-downstream-mgmt = { };
          br-site-stable-downstream-admin = { };
          br-site-stable-downstream-clients = { };
        };
      };
    };
  };

  realization = {
    nodes = {
      esp0xdeadbeef-site-stable-s-router-core = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-stable";
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
            adapterName = "adp-esp0xdeadbeef-site-stable-s-router-core-upstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-stable-core-upstream";
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

      esp0xdeadbeef-site-stable-s-router-upstream-selector = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-stable";
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
            adapterName = "adp-esp0xdeadbeef-site-stable-s-router-upstream-selector-core";
            attach = {
              kind = "bridge";
              bridge = "br-site-stable-core-upstream";
            };
            interface = {
              name = "ens3";
            };
          };

          policy-access-admin-wan = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-admin--uplink-wan";
            adapterName = "adp-esp0xdeadbeef-site-stable-s-router-upstream-selector-policy-access-admin-wan";
            attach.kind = "bridge";
            attach.bridge = "br-site-stable-policy-upstream-access-admin-wan";
            interface.name = "ens4";
          };
        };
      };

      esp0xdeadbeef-site-stable-s-router-policy = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-stable";
          name = "s-router-policy";
        };
        containers = {
          default = {
            runtimeName = "default";
          };
        };
        ports = {
          upstream-access-admin-wan = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-admin--uplink-wan";
            adapterName = "adp-esp0xdeadbeef-site-stable-s-router-policy-upstream-access-admin-wan";
            attach.kind = "bridge";
            attach.bridge = "br-site-stable-policy-upstream-access-admin-wan";
            interface.name = "ens3";
          };

          downstream-access-mgmt = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-mgmt";
            adapterName = "adp-esp0xdeadbeef-site-stable-s-router-policy-downstream-access-mgmt";
            attach.kind = "bridge";
            attach.bridge = "br-site-stable-downstream-policy-access-mgmt";
            interface.name = "ens4";
          };

          downstream-access-admin = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-admin";
            adapterName = "adp-esp0xdeadbeef-site-stable-s-router-policy-downstream-access-admin";
            attach.kind = "bridge";
            attach.bridge = "br-site-stable-downstream-policy-access-admin";
            interface.name = "ens5";
          };

          downstream-access-clients = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-clients";
            adapterName = "adp-esp0xdeadbeef-site-stable-s-router-policy-downstream-access-clients";
            attach.kind = "bridge";
            attach.bridge = "br-site-stable-downstream-policy-access-clients";
            interface.name = "ens6";
          };
        };
      };

      esp0xdeadbeef-site-stable-s-router-downstream-selector = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-stable";
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
            adapterName = "adp-esp0xdeadbeef-site-stable-s-router-downstream-selector-policy-access-mgmt";
            attach.kind = "bridge";
            attach.bridge = "br-site-stable-downstream-policy-access-mgmt";
            interface.name = "ens3";
          };

          policy-access-admin = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-admin";
            adapterName = "adp-esp0xdeadbeef-site-stable-s-router-downstream-selector-policy-access-admin";
            attach.kind = "bridge";
            attach.bridge = "br-site-stable-downstream-policy-access-admin";
            interface.name = "ens4";
          };

          policy-access-clients = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-clients";
            adapterName = "adp-esp0xdeadbeef-site-stable-s-router-downstream-selector-policy-access-clients";
            attach.kind = "bridge";
            attach.bridge = "br-site-stable-downstream-policy-access-clients";
            interface.name = "ens5";
          };

          access-mgmt = {
            link = "p2p-s-router-access-mgmt-s-router-downstream-selector";
            adapterName = "adp-esp0xdeadbeef-site-stable-s-router-downstream-selector-access-mgmt";
            attach = {
              kind = "bridge";
              bridge = "br-site-stable-downstream-mgmt";
            };
            interface = {
              name = "ens6";
            };
          };

          access-admin = {
            link = "p2p-s-router-access-admin-s-router-downstream-selector";
            adapterName = "adp-esp0xdeadbeef-site-stable-s-router-downstream-selector-access-admin";
            attach = {
              kind = "bridge";
              bridge = "br-site-stable-downstream-admin";
            };
            interface = {
              name = "ens7";
            };
          };

          access-clients = {
            link = "p2p-s-router-access-clients-s-router-downstream-selector";
            adapterName = "adp-esp0xdeadbeef-site-stable-s-router-downstream-selector-access-clients";
            attach = {
              kind = "bridge";
              bridge = "br-site-stable-downstream-clients";
            };
            interface = {
              name = "ens8";
            };
          };
        };
      };

      esp0xdeadbeef-site-stable-s-router-access-mgmt = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-stable";
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
            adapterName = "adp-esp0xdeadbeef-site-stable-s-router-access-mgmt-transit-downstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-stable-downstream-mgmt";
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

      esp0xdeadbeef-site-stable-s-router-access-admin = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-stable";
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
            adapterName = "adp-esp0xdeadbeef-site-stable-s-router-access-admin-transit-downstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-stable-downstream-admin";
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

      esp0xdeadbeef-site-stable-s-router-access-clients = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-stable";
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
            adapterName = "adp-esp0xdeadbeef-site-stable-s-router-access-clients-transit-downstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-stable-downstream-clients";
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
    };
  };
}
