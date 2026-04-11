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

          wan = {
            upstream = "uplink0";
            link = "wan";
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

      esp0xdeadbeef-site-stable-s-router-policy = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-stable";
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
            link = "p2p-s-router-downstream-selector-s-router-policy";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens4";
            };
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
        ports = {
          policy = {
            link = "p2p-s-router-downstream-selector-s-router-policy";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens3";
            };
          };

          access-mgmt = {
            link = "p2p-s-router-access-mgmt-s-router-downstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens4";
            };
          };

          access-admin = {
            link = "p2p-s-router-access-admin-s-router-downstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens5";
            };
          };

          access-clients = {
            link = "p2p-s-router-access-clients-s-router-downstream-selector";
            attach = {
              kind = "direct";
            };
            interface = {
              name = "ens6";
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
        ports = {
          transit-downstream-selector = {
            link = "p2p-s-router-access-mgmt-s-router-downstream-selector";
            attach = {
              kind = "direct";
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
              dnsServers = [ "10.20.10.1" ];
              domain = "lan.";
            };
          };
          ipv6Ra = {
            tenant-mgmt = {
              rdnss = [ "fd42:dead:beef:10::1" ];
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
        ports = {
          transit-downstream-selector = {
            link = "p2p-s-router-access-admin-s-router-downstream-selector";
            attach = {
              kind = "direct";
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
              dnsServers = [ "10.20.15.1" ];
              domain = "lan.";
            };
          };
          ipv6Ra = {
            tenant-admin = {
              rdnss = [ "fd42:dead:beef:15::1" ];
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
        ports = {
          transit-downstream-selector = {
            link = "p2p-s-router-access-clients-s-router-downstream-selector";
            attach = {
              kind = "direct";
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
              dnsServers = [ "10.20.20.1" ];
              domain = "lan.";
            };
          };
          ipv6Ra = {
            tenant-clients = {
              rdnss = [ "fd42:dead:beef:20::1" ];
              dnssl = [ "lan." ];
            };
          };
        };
      };
    };
  };
}
