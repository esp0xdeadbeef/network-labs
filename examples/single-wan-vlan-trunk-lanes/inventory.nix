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

  deployment = {
    hosts = {
      lab-host = {
        uplinks = {
          trunk = {
            parent = "eno1";
            bridge = "br-trunk";
            mode = "trunk";
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
          br-site-a-downstream-client = { };
          br-site-a-downstream-admin = { };
          br-site-a-downstream-mgmt = { };
          tr100 = { };
          tr101 = { };
          tr102 = { };
          tr200 = { };
          tr201 = { };
          tr202 = { };
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
        containers = {
          default = {
            runtimeName = "default";
          };
        };
        ports = {
          upstream-selector = {
            link = "p2p-s-router-core-wan-s-router-upstream-selector";
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-core-wan-upstream-selector";
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
              bridge = "br-trunk";
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
            link = "p2p-s-router-core-wan-s-router-upstream-selector";
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-upstream-selector-core";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-core-upstream";
            };
            interface = {
              name = "ens3";
            };
          };

          policy-access-client-wan = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-client--uplink-wan";
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-upstream-selector-policy-access-client-wan";
            attach.kind = "bridge";
            attach.bridge = "tr100";
            interface.name = "ens4";
          };

          policy-access-admin-wan = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-admin--uplink-wan";
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-upstream-selector-policy-access-admin-wan";
            attach.kind = "bridge";
            attach.bridge = "tr101";
            interface.name = "ens5";
          };

          policy-access-mgmt-wan = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-mgmt--uplink-wan";
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-upstream-selector-policy-access-mgmt-wan";
            attach.kind = "bridge";
            attach.bridge = "tr102";
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
          upstream-access-client-wan = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-client--uplink-wan";
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-policy-upstream-access-client-wan";
            attach.kind = "bridge";
            attach.bridge = "tr100";
            interface.name = "ens3";
          };

          upstream-access-admin-wan = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-admin--uplink-wan";
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-policy-upstream-access-admin-wan";
            attach.kind = "bridge";
            attach.bridge = "tr101";
            interface.name = "ens4";
          };

          upstream-access-mgmt-wan = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-mgmt--uplink-wan";
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-policy-upstream-access-mgmt-wan";
            attach.kind = "bridge";
            attach.bridge = "tr102";
            interface.name = "ens5";
          };

          downstream-access-client = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-client";
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-policy-downstream-access-client";
            attach.kind = "bridge";
            attach.bridge = "tr200";
            interface.name = "ens6";
          };

          downstream-access-admin = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-admin";
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-policy-downstream-access-admin";
            attach.kind = "bridge";
            attach.bridge = "tr201";
            interface.name = "ens7";
          };

          downstream-access-mgmt = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-mgmt";
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-policy-downstream-access-mgmt";
            attach.kind = "bridge";
            attach.bridge = "tr202";
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
          policy-access-client = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-client";
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-downstream-selector-policy-access-client";
            attach.kind = "bridge";
            attach.bridge = "tr200";
            interface.name = "ens3";
          };

          policy-access-admin = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-admin";
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-downstream-selector-policy-access-admin";
            attach.kind = "bridge";
            attach.bridge = "tr201";
            interface.name = "ens4";
          };

          policy-access-mgmt = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-mgmt";
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-downstream-selector-policy-access-mgmt";
            attach.kind = "bridge";
            attach.bridge = "tr202";
            interface.name = "ens5";
          };

          access-client = {
            link = "p2p-s-router-access-client-s-router-downstream-selector";
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-downstream-selector-access-client";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-downstream-client";
            };
            interface = {
              name = "ens6";
            };
          };

          access-admin = {
            link = "p2p-s-router-access-admin-s-router-downstream-selector";
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-downstream-selector-access-admin";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-downstream-admin";
            };
            interface = {
              name = "ens7";
            };
          };

          access-mgmt = {
            link = "p2p-s-router-access-mgmt-s-router-downstream-selector";
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-downstream-selector-access-mgmt";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-downstream-mgmt";
            };
            interface = {
              name = "ens8";
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
        containers = {
          default = {
            runtimeName = "default";
          };
        };
        ports = {
          transit-downstream-selector = {
            link = "p2p-s-router-access-client-s-router-downstream-selector";
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-access-client-transit-downstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-downstream-client";
            };
            interface = {
              name = "ens3";
            };
          };
        };
        advertisements = {
          dhcp4 = {
            tenant-client = {
              pool = {
                start = "10.20.20.100";
                end = "10.20.20.200";
              };
              dnsServers = [ "router-self" ];
              domain = "lan.";
            };
          };
          ipv6Ra = {
            tenant-client = {
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
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-access-admin-transit-downstream-selector";
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
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-access-mgmt-transit-downstream-selector";
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
    };
  };
}
