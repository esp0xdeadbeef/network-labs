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

          uplink1 = {
            parent = "eno2";
            bridge = "br-uplink1";
            ipv4 = {
              method = "dhcp";
            };
            ipv6 = {
              method = "slaac";
            };
          };
        };

        bridgeNetworks = {
          br-site-a-core-isp-a-upstream = { };
          br-site-a-core-isp-b-upstream = { };
          br-site-a-upstream-policy = { };
          br-site-a-policy-downstream = { };
          br-site-a-downstream-adm = { };
          br-site-a-downstream-mgmt = { };

          br-site-b-core-isp-a-upstream = { };
          br-site-b-core-isp-b-upstream = { };
          br-site-b-upstream-policy = { };
          br-site-b-policy-downstream = { };
          br-site-b-downstream-access = { };
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
        containers = {
          default = {
            runtimeName = "default";
          };
        };
        ports = {
          upstream-selector = {
            link = "p2p-s-router-core-isp-a-s-router-upstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-core-isp-a-upstream";
            };
            interface = {
              name = "ens3";
            };
          };

          isp-a = {
            uplink = "isp-a";
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

      esp0xdeadbeef-site-a-s-router-core-isp-b = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-a";
          name = "s-router-core-isp-b";
        };
        containers = {
          default = {
            runtimeName = "default";
          };
        };
        ports = {
          upstream-selector = {
            link = "p2p-s-router-core-isp-b-s-router-upstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-core-isp-b-upstream";
            };
            interface = {
              name = "ens3";
            };
          };

          isp-b = {
            uplink = "isp-b";
            external = true;
            attach = {
              kind = "bridge";
              bridge = "br-uplink1";
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
          core-isp-a = {
            link = "p2p-s-router-core-isp-a-s-router-upstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-core-isp-a-upstream";
            };
            interface = {
              name = "ens3";
            };
          };

          core-isp-b = {
            link = "p2p-s-router-core-isp-b-s-router-upstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-core-isp-b-upstream";
            };
            interface = {
              name = "ens4";
            };
          };

          policy = {
            link = "p2p-s-router-policy-s-router-upstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-upstream-policy";
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

          access-adm = {
            link = "p2p-s-router-access-adm-s-router-downstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-downstream-adm";
            };
            interface = {
              name = "ens4";
            };
          };

          access-mgmt = {
            link = "p2p-s-router-access-mgmt-s-router-downstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-downstream-mgmt";
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
        containers = {
          default = {
            runtimeName = "default";
          };
        };
        ports = {
          transit-downstream-selector = {
            link = "p2p-s-router-access-adm-s-router-downstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-downstream-adm";
            };
            interface = {
              name = "ens3";
            };
          };
        };
        advertisements = {
          dhcp4 = {
            tenant-adm = {
              pool = {
                start = "10.21.10.100";
                end = "10.21.10.200";
              };
              dnsServers = [ "router-self" ];
              domain = "lan.";
            };
          };
          ipv6Ra = {
            tenant-adm = {
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

      esp0xdeadbeef-site-b-s-router-core-isp-a = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-b";
          name = "s-router-core-isp-a";
        };
        containers = {
          default = {
            runtimeName = "default";
          };
        };
        ports = {
          upstream-selector = {
            link = "p2p-s-router-core-isp-a-s-router-upstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-core-isp-a-upstream";
            };
            interface = {
              name = "ens13";
            };
          };

          isp-a = {
            uplink = "isp-a";
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

      esp0xdeadbeef-site-b-s-router-core-isp-b = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-b";
          name = "s-router-core-isp-b";
        };
        containers = {
          default = {
            runtimeName = "default";
          };
        };
        ports = {
          upstream-selector = {
            link = "p2p-s-router-core-isp-b-s-router-upstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-core-isp-b-upstream";
            };
            interface = {
              name = "ens13";
            };
          };

          isp-b = {
            uplink = "isp-b";
            external = true;
            attach = {
              kind = "bridge";
              bridge = "br-uplink1";
            };
            interface = {
              name = "ens14";
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
        containers = {
          default = {
            runtimeName = "default";
          };
        };
        ports = {
          core-isp-a = {
            link = "p2p-s-router-core-isp-a-s-router-upstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-core-isp-a-upstream";
            };
            interface = {
              name = "ens13";
            };
          };

          core-isp-b = {
            link = "p2p-s-router-core-isp-b-s-router-upstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-core-isp-b-upstream";
            };
            interface = {
              name = "ens14";
            };
          };

          policy = {
            link = "p2p-s-router-policy-s-router-upstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-upstream-policy";
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

      esp0xdeadbeef-site-b-s-router-downstream-selector = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
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

      esp0xdeadbeef-site-b-s-router-access = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
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
