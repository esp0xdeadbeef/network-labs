{
  controlPlane = {
    sites = {
      esp0xdeadbeef = {
        site-a = {
          routing = {
            mode = "bgp";
            bgp = {
              asn = 65001;
            };
          };
        };
      };

      esp0xdeadbeef-2 = {
        site-b = {
          routing = {
            mode = "bgp";
            bgp = {
              asn = 65002;
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
          vlan4 = {
            parent = "eno1";
            vlan = 4;
            bridge = "br-vlan4";
            upstream = "wan";
            ipv4.method = "dhcp";
            ipv6.method = "slaac";
          };

          vlan5 = {
            parent = "eno1";
            vlan = 5;
            bridge = "br-vlan5";
            upstream = "wan";
            ipv4.method = "dhcp";
            ipv6.method = "slaac";
          };
        };

        wanGroupToUplink = {
          "esp0xdeadbeef::site-a::s-router-core" = "vlan4";
          "esp0xdeadbeef-2::site-b::s-router-core" = "vlan5";
        };

        bridgeNetworks = {
          br-site-a-core-upstream = { };
          br-site-a-policy-upstream-access-clients-wan = { };
          br-site-a-downstream-policy-access-admin = { };
          br-site-a-downstream-policy-access-clients = { };
          br-site-a-downstream-policy-access-mgmt = { };
          br-site-a-downstream-admin = { };
          br-site-a-downstream-clients = { };
          br-site-a-downstream-mgmt = { };

          br-site-b-core-upstream = { };
          br-site-b-policy-upstream-access-clients-wan = { };
          br-site-b-downstream-policy-access-admin = { };
          br-site-b-downstream-policy-access-clients = { };
          br-site-b-downstream-policy-access-mgmt = { };
          br-site-b-downstream-admin = { };
          br-site-b-downstream-clients = { };
          br-site-b-downstream-mgmt = { };
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
        containers.default.runtimeName = "default";
        ports = {
          upstream-selector = {
            link = "p2p-s-router-core-s-router-upstream-selector";
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-core-upstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-core-upstream";
            };
            interface.name = "ens3";
          };

          wan = {
            uplink = "wan";
            external = true;
            attach = {
              kind = "bridge";
              bridge = "br-vlan4";
            };
            interface.name = "ens4";
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
        containers.default.runtimeName = "default";
        ports = {
          core = {
            link = "p2p-s-router-core-s-router-upstream-selector";
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-upstream-selector-core";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-core-upstream";
            };
            interface.name = "ens3";
          };

          policy-clients-wan = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-clients--uplink-wan";
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-upstream-selector-policy-clients-wan";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-policy-upstream-access-clients-wan";
            };
            interface.name = "ens4";
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
        containers.default.runtimeName = "default";
        ports = {
          upstream-clients-wan = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-clients--uplink-wan";
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-policy-upstream-clients-wan";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-policy-upstream-access-clients-wan";
            };
            interface.name = "ens3";
          };

          downstream-admin = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-admin";
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-policy-downstream-admin";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-downstream-policy-access-admin";
            };
            interface.name = "ens4";
          };

          downstream-clients = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-clients";
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-policy-downstream-clients";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-downstream-policy-access-clients";
            };
            interface.name = "ens5";
          };

          downstream-mgmt = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-mgmt";
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-policy-downstream-mgmt";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-downstream-policy-access-mgmt";
            };
            interface.name = "ens6";
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
        containers.default.runtimeName = "default";
        ports = {
          policy-admin = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-admin";
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-downstream-selector-policy-admin";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-downstream-policy-access-admin";
            };
            interface.name = "ens3";
          };

          policy-clients = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-clients";
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-downstream-selector-policy-clients";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-downstream-policy-access-clients";
            };
            interface.name = "ens4";
          };

          policy-mgmt = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-mgmt";
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-downstream-selector-policy-mgmt";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-downstream-policy-access-mgmt";
            };
            interface.name = "ens5";
          };

          access-admin = {
            link = "p2p-s-router-access-admin-s-router-downstream-selector";
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-downstream-selector-access-admin";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-downstream-admin";
            };
            interface.name = "ens6";
          };

          access-clients = {
            link = "p2p-s-router-access-clients-s-router-downstream-selector";
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-downstream-selector-access-clients";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-downstream-clients";
            };
            interface.name = "ens7";
          };

          access-mgmt = {
            link = "p2p-s-router-access-mgmt-s-router-downstream-selector";
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-downstream-selector-access-mgmt";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-downstream-mgmt";
            };
            interface.name = "ens8";
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
        containers.default.runtimeName = "default";
        ports.transit-downstream-selector = {
          link = "p2p-s-router-access-admin-s-router-downstream-selector";
          adapterName = "adp-esp0xdeadbeef-site-a-s-router-access-admin-transit-downstream-selector";
          attach = {
            kind = "bridge";
            bridge = "br-site-a-downstream-admin";
          };
          interface.name = "ens3";
        };
        advertisements = {
          dhcp4.tenant-admin = {
            pool = {
              start = "10.20.15.100";
              end = "10.20.15.200";
            };
            dnsServers = [ "router-self" ];
            domain = "lan.";
          };
          ipv6Ra.tenant-admin = {
            rdnss = [ "router-self" ];
            dnssl = [ "lan." ];
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
        containers.default.runtimeName = "default";
        ports.transit-downstream-selector = {
          link = "p2p-s-router-access-clients-s-router-downstream-selector";
          adapterName = "adp-esp0xdeadbeef-site-a-s-router-access-clients-transit-downstream-selector";
          attach = {
            kind = "bridge";
            bridge = "br-site-a-downstream-clients";
          };
          interface.name = "ens3";
        };
        advertisements = {
          dhcp4.tenant-clients = {
            pool = {
              start = "10.20.20.100";
              end = "10.20.20.200";
            };
            dnsServers = [ "router-self" ];
            domain = "lan.";
          };
          ipv6Ra.tenant-clients = {
            rdnss = [ "router-self" ];
            dnssl = [ "lan." ];
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
        containers.default.runtimeName = "default";
        ports.transit-downstream-selector = {
          link = "p2p-s-router-access-mgmt-s-router-downstream-selector";
          adapterName = "adp-esp0xdeadbeef-site-a-s-router-access-mgmt-transit-downstream-selector";
          attach = {
            kind = "bridge";
            bridge = "br-site-a-downstream-mgmt";
          };
          interface.name = "ens3";
        };
        advertisements = {
          dhcp4.tenant-mgmt = {
            pool = {
              start = "10.20.10.100";
              end = "10.20.10.200";
            };
            dnsServers = [ "router-self" ];
            domain = "lan.";
          };
          ipv6Ra.tenant-mgmt = {
            rdnss = [ "router-self" ];
            dnssl = [ "lan." ];
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
        containers.default.runtimeName = "default";
        ports = {
          upstream-selector = {
            link = "p2p-s-router-core-s-router-upstream-selector";
            adapterName = "adp-esp0xdeadbeef-2-site-b-s-router-core-upstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-core-upstream";
            };
            interface.name = "ens3";
          };

          wan = {
            uplink = "wan";
            external = true;
            attach = {
              kind = "bridge";
              bridge = "br-vlan5";
            };
            interface.name = "ens4";
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
        containers.default.runtimeName = "default";
        ports = {
          core = {
            link = "p2p-s-router-core-s-router-upstream-selector";
            adapterName = "adp-esp0xdeadbeef-2-site-b-s-router-upstream-selector-core";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-core-upstream";
            };
            interface.name = "ens3";
          };

          policy-clients-wan = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-clients--uplink-wan";
            adapterName = "adp-esp0xdeadbeef-2-site-b-s-router-upstream-selector-policy-clients-wan";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-policy-upstream-access-clients-wan";
            };
            interface.name = "ens4";
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
        containers.default.runtimeName = "default";
        ports = {
          upstream-clients-wan = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-clients--uplink-wan";
            adapterName = "adp-esp0xdeadbeef-2-site-b-s-router-policy-upstream-clients-wan";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-policy-upstream-access-clients-wan";
            };
            interface.name = "ens3";
          };

          downstream-admin = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-admin";
            adapterName = "adp-esp0xdeadbeef-2-site-b-s-router-policy-downstream-admin";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-downstream-policy-access-admin";
            };
            interface.name = "ens4";
          };

          downstream-clients = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-clients";
            adapterName = "adp-esp0xdeadbeef-2-site-b-s-router-policy-downstream-clients";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-downstream-policy-access-clients";
            };
            interface.name = "ens5";
          };

          downstream-mgmt = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-mgmt";
            adapterName = "adp-esp0xdeadbeef-2-site-b-s-router-policy-downstream-mgmt";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-downstream-policy-access-mgmt";
            };
            interface.name = "ens6";
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
        containers.default.runtimeName = "default";
        ports = {
          policy-admin = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-admin";
            adapterName = "adp-esp0xdeadbeef-2-site-b-s-router-downstream-selector-policy-admin";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-downstream-policy-access-admin";
            };
            interface.name = "ens3";
          };

          policy-clients = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-clients";
            adapterName = "adp-esp0xdeadbeef-2-site-b-s-router-downstream-selector-policy-clients";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-downstream-policy-access-clients";
            };
            interface.name = "ens4";
          };

          policy-mgmt = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-mgmt";
            adapterName = "adp-esp0xdeadbeef-2-site-b-s-router-downstream-selector-policy-mgmt";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-downstream-policy-access-mgmt";
            };
            interface.name = "ens5";
          };

          access-admin = {
            link = "p2p-s-router-access-admin-s-router-downstream-selector";
            adapterName = "adp-esp0xdeadbeef-2-site-b-s-router-downstream-selector-access-admin";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-downstream-admin";
            };
            interface.name = "ens6";
          };

          access-clients = {
            link = "p2p-s-router-access-clients-s-router-downstream-selector";
            adapterName = "adp-esp0xdeadbeef-2-site-b-s-router-downstream-selector-access-clients";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-downstream-clients";
            };
            interface.name = "ens7";
          };

          access-mgmt = {
            link = "p2p-s-router-access-mgmt-s-router-downstream-selector";
            adapterName = "adp-esp0xdeadbeef-2-site-b-s-router-downstream-selector-access-mgmt";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-downstream-mgmt";
            };
            interface.name = "ens8";
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
        containers.default.runtimeName = "default";
        ports.transit-downstream-selector = {
          link = "p2p-s-router-access-admin-s-router-downstream-selector";
          adapterName = "adp-esp0xdeadbeef-2-site-b-s-router-access-admin-transit-downstream-selector";
          attach = {
            kind = "bridge";
            bridge = "br-site-b-downstream-admin";
          };
          interface.name = "ens3";
        };
        advertisements = {
          dhcp4.tenant-admin = {
            pool = {
              start = "10.30.15.100";
              end = "10.30.15.200";
            };
            dnsServers = [ "router-self" ];
            domain = "lan.";
          };
          ipv6Ra.tenant-admin = {
            rdnss = [ "router-self" ];
            dnssl = [ "lan." ];
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
        containers.default.runtimeName = "default";
        ports.transit-downstream-selector = {
          link = "p2p-s-router-access-clients-s-router-downstream-selector";
          adapterName = "adp-esp0xdeadbeef-2-site-b-s-router-access-clients-transit-downstream-selector";
          attach = {
            kind = "bridge";
            bridge = "br-site-b-downstream-clients";
          };
          interface.name = "ens3";
        };
        advertisements = {
          dhcp4.tenant-clients = {
            pool = {
              start = "10.30.20.100";
              end = "10.30.20.200";
            };
            dnsServers = [ "router-self" ];
            domain = "lan.";
          };
          ipv6Ra.tenant-clients = {
            rdnss = [ "router-self" ];
            dnssl = [ "lan." ];
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
        containers.default.runtimeName = "default";
        ports.transit-downstream-selector = {
          link = "p2p-s-router-access-mgmt-s-router-downstream-selector";
          adapterName = "adp-esp0xdeadbeef-2-site-b-s-router-access-mgmt-transit-downstream-selector";
          attach = {
            kind = "bridge";
            bridge = "br-site-b-downstream-mgmt";
          };
          interface.name = "ens3";
        };
        advertisements = {
          dhcp4.tenant-mgmt = {
            pool = {
              start = "10.30.10.100";
              end = "10.30.10.200";
            };
            dnsServers = [ "router-self" ];
            domain = "lan.";
          };
          ipv6Ra.tenant-mgmt = {
            rdnss = [ "router-self" ];
            dnssl = [ "lan." ];
          };
        };
      };
    };
  };
}
