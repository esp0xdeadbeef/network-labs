{
  controlPlane = {
    sites = {
      enterpriseA = {
        "site-a" = {
          overlays.east-west = {
            provider = "nebula";
            nodes = {
              s-router-core-isp-b = {
                addr4 = "100.96.10.1/32";
                addr6 = "fd42:dead:beef:ee::1/128";
              };

              nebula-core = {
                addr4 = "100.96.10.10/32";
                addr6 = "fd42:dead:beef:ee::10/128";
              };
            };
            nebula = {
              role = "core-client";
              lighthouse = {
                endpoint = "nebula01";
                port = 4242;
              };
            };
          };
        };
      };

      enterpriseB = {
        "site-b" = {
          overlays.east-west = {
            provider = "nebula";
            nodes = {
              b-router-core = {
                addr4 = "100.96.10.2/32";
                addr6 = "fd42:dead:beef:ee::2/128";
              };

              branch-node01 = {
                addr4 = "100.96.10.20/32";
                addr6 = "fd42:dead:beef:ee::20/128";
              };
            };
            nebula = {
              role = "core-client";
              lighthouse = {
                endpoint = "nebula01";
                port = 4242;
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
            upstream = "isp-a";
            ipv4.method = "dhcp";
            ipv6.method = "slaac";
          };

          uplink1 = {
            parent = "eno2";
            bridge = "br-uplink1";
            upstream = "isp-b";
            ipv4.method = "dhcp";
            ipv6.method = "slaac";
          };
        };

        bridgeNetworks = {
          br-site-a-core-isp-a-upstream = { };
          br-site-a-core-isp-b-upstream = { };

          br-site-a-policy-upstream-access-admin-isp-a = { };
          br-site-a-policy-upstream-access-admin-isp-b = { };
          br-site-a-policy-upstream-access-admin-east-west = { };
          br-site-a-policy-upstream-access-client-isp-a = { };
          br-site-a-policy-upstream-access-client-isp-b = { };
          br-site-a-policy-upstream-access-client-east-west = { };
          br-site-a-policy-upstream-access-mgmt-isp-a = { };
          br-site-a-policy-upstream-access-mgmt-isp-b = { };
          br-site-a-policy-upstream-access-mgmt-east-west = { };
          br-site-a-policy-upstream-access-dmz-isp-a = { };
          br-site-a-policy-upstream-access-dmz-isp-b = { };

          br-site-a-downstream-policy-access-admin = { };
          br-site-a-downstream-policy-access-client = { };
          br-site-a-downstream-policy-access-mgmt = { };
          br-site-a-downstream-policy-access-dmz = { };

          br-site-a-downstream-admin = { };
          br-site-a-downstream-client = { };
          br-site-a-downstream-mgmt = { };
          br-site-a-downstream-dmz = { };

          br-site-b-core-upstream = { };
          br-site-b-policy-upstream-access-branch-wan = { };
          br-site-b-policy-upstream-access-branch-east-west = { };
          br-site-b-downstream-policy-access-branch = { };
          br-site-b-downstream-branch = { };
        };
      };
    };
  };

  realization = {
    nodes = {
      enterpriseA-site-a-s-router-core-isp-a = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "enterpriseA";
          site = "site-a";
          name = "s-router-core-isp-a";
        };
        containers.default.runtimeName = "default";
        ports = {
          upstream-selector = {
            link = "p2p-s-router-core-isp-a-s-router-upstream-selector";
            adapterName = "adp-enterprisea-site-a-s-router-core-isp-a-upstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-core-isp-a-upstream";
            };
            interface.name = "ens3";
          };

          isp-a = {
            uplink = "isp-a";
            external = true;
            attach = {
              kind = "bridge";
              bridge = "br-uplink0";
            };
            interface.name = "ens4";
          };
        };
      };

      enterpriseA-site-a-s-router-core-isp-b = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "enterpriseA";
          site = "site-a";
          name = "s-router-core-isp-b";
        };
        containers.default.runtimeName = "default";
        ports = {
          upstream-selector = {
            link = "p2p-s-router-core-isp-b-s-router-upstream-selector";
            adapterName = "adp-enterprisea-site-a-s-router-core-isp-b-upstream-selector";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-core-isp-b-upstream";
            };
            interface.name = "ens3";
          };

          isp-b = {
            uplink = "isp-b";
            external = true;
            attach = {
              kind = "bridge";
              bridge = "br-uplink1";
            };
            interface.name = "ens4";
          };
        };
      };

      enterpriseA-site-a-s-router-upstream-selector = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "enterpriseA";
          site = "site-a";
          name = "s-router-upstream-selector";
        };
        containers.default.runtimeName = "default";
        ports = {
          core-isp-a = {
            link = "p2p-s-router-core-isp-a-s-router-upstream-selector";
            adapterName = "adp-enterprisea-site-a-s-router-upstream-selector-core-isp-a";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-core-isp-a-upstream";
            };
            interface.name = "ens3";
          };

          core-isp-b = {
            link = "p2p-s-router-core-isp-b-s-router-upstream-selector";
            adapterName = "adp-enterprisea-site-a-s-router-upstream-selector-core-isp-b";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-core-isp-b-upstream";
            };
            interface.name = "ens4";
          };

          policy-admin-east-west = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-admin--uplink-east-west";
            adapterName = "adp-enterprisea-site-a-s-router-upstream-selector-policy-admin-east-west";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-admin-east-west";
            interface.name = "ens5";
          };

          policy-admin-isp-a = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-admin--uplink-isp-a";
            adapterName = "adp-enterprisea-site-a-s-router-upstream-selector-policy-admin-isp-a";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-admin-isp-a";
            interface.name = "ens6";
          };

          policy-admin-isp-b = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-admin--uplink-isp-b";
            adapterName = "adp-enterprisea-site-a-s-router-upstream-selector-policy-admin-isp-b";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-admin-isp-b";
            interface.name = "ens7";
          };

          policy-client-east-west = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-client--uplink-east-west";
            adapterName = "adp-enterprisea-site-a-s-router-upstream-selector-policy-client-east-west";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-client-east-west";
            interface.name = "ens8";
          };

          policy-client-isp-a = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-client--uplink-isp-a";
            adapterName = "adp-enterprisea-site-a-s-router-upstream-selector-policy-client-isp-a";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-client-isp-a";
            interface.name = "ens9";
          };

          policy-client-isp-b = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-client--uplink-isp-b";
            adapterName = "adp-enterprisea-site-a-s-router-upstream-selector-policy-client-isp-b";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-client-isp-b";
            interface.name = "ens10";
          };

          policy-mgmt-east-west = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-mgmt--uplink-east-west";
            adapterName = "adp-enterprisea-site-a-s-router-upstream-selector-policy-mgmt-east-west";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-mgmt-east-west";
            interface.name = "ens11";
          };

          policy-mgmt-isp-a = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-mgmt--uplink-isp-a";
            adapterName = "adp-enterprisea-site-a-s-router-upstream-selector-policy-mgmt-isp-a";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-mgmt-isp-a";
            interface.name = "ens12";
          };

          policy-mgmt-isp-b = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-mgmt--uplink-isp-b";
            adapterName = "adp-enterprisea-site-a-s-router-upstream-selector-policy-mgmt-isp-b";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-mgmt-isp-b";
            interface.name = "ens13";
          };

          policy-dmz-isp-a = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-dmz--uplink-isp-a";
            adapterName = "adp-enterprisea-site-a-s-router-upstream-selector-policy-dmz-isp-a";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-dmz-isp-a";
            interface.name = "ens14";
          };

          policy-dmz-isp-b = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-dmz--uplink-isp-b";
            adapterName = "adp-enterprisea-site-a-s-router-upstream-selector-policy-dmz-isp-b";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-dmz-isp-b";
            interface.name = "ens15";
          };
        };
      };

      enterpriseA-site-a-s-router-policy = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "enterpriseA";
          site = "site-a";
          name = "s-router-policy";
        };
        containers.default.runtimeName = "default";
        ports = {
          upstream-admin-east-west = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-admin--uplink-east-west";
            adapterName = "adp-enterprisea-site-a-s-router-policy-upstream-admin-east-west";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-admin-east-west";
            interface.name = "ens3";
          };

          upstream-admin-isp-a = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-admin--uplink-isp-a";
            adapterName = "adp-enterprisea-site-a-s-router-policy-upstream-admin-isp-a";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-admin-isp-a";
            interface.name = "ens4";
          };

          upstream-admin-isp-b = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-admin--uplink-isp-b";
            adapterName = "adp-enterprisea-site-a-s-router-policy-upstream-admin-isp-b";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-admin-isp-b";
            interface.name = "ens5";
          };

          upstream-client-east-west = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-client--uplink-east-west";
            adapterName = "adp-enterprisea-site-a-s-router-policy-upstream-client-east-west";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-client-east-west";
            interface.name = "ens6";
          };

          upstream-client-isp-a = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-client--uplink-isp-a";
            adapterName = "adp-enterprisea-site-a-s-router-policy-upstream-client-isp-a";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-client-isp-a";
            interface.name = "ens7";
          };

          upstream-client-isp-b = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-client--uplink-isp-b";
            adapterName = "adp-enterprisea-site-a-s-router-policy-upstream-client-isp-b";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-client-isp-b";
            interface.name = "ens8";
          };

          upstream-mgmt-east-west = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-mgmt--uplink-east-west";
            adapterName = "adp-enterprisea-site-a-s-router-policy-upstream-mgmt-east-west";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-mgmt-east-west";
            interface.name = "ens9";
          };

          upstream-mgmt-isp-a = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-mgmt--uplink-isp-a";
            adapterName = "adp-enterprisea-site-a-s-router-policy-upstream-mgmt-isp-a";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-mgmt-isp-a";
            interface.name = "ens10";
          };

          upstream-mgmt-isp-b = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-mgmt--uplink-isp-b";
            adapterName = "adp-enterprisea-site-a-s-router-policy-upstream-mgmt-isp-b";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-mgmt-isp-b";
            interface.name = "ens11";
          };

          upstream-dmz-isp-a = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-dmz--uplink-isp-a";
            adapterName = "adp-enterprisea-site-a-s-router-policy-upstream-dmz-isp-a";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-dmz-isp-a";
            interface.name = "ens12";
          };

          upstream-dmz-isp-b = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-dmz--uplink-isp-b";
            adapterName = "adp-enterprisea-site-a-s-router-policy-upstream-dmz-isp-b";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-dmz-isp-b";
            interface.name = "ens13";
          };

          downstream-admin = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-admin";
            adapterName = "adp-enterprisea-site-a-s-router-policy-downstream-admin";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-downstream-policy-access-admin";
            interface.name = "ens14";
          };

          downstream-client = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-client";
            adapterName = "adp-enterprisea-site-a-s-router-policy-downstream-client";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-downstream-policy-access-client";
            interface.name = "ens15";
          };

          downstream-mgmt = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-mgmt";
            adapterName = "adp-enterprisea-site-a-s-router-policy-downstream-mgmt";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-downstream-policy-access-mgmt";
            interface.name = "ens16";
          };

          downstream-dmz = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-dmz";
            adapterName = "adp-enterprisea-site-a-s-router-policy-downstream-dmz";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-downstream-policy-access-dmz";
            interface.name = "ens17";
          };
        };
      };

      enterpriseA-site-a-s-router-downstream-selector = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "enterpriseA";
          site = "site-a";
          name = "s-router-downstream-selector";
        };
        containers.default.runtimeName = "default";
        ports = {
          policy-admin = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-admin";
            adapterName = "adp-enterprisea-site-a-s-router-downstream-selector-policy-admin";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-downstream-policy-access-admin";
            interface.name = "ens3";
          };

          policy-client = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-client";
            adapterName = "adp-enterprisea-site-a-s-router-downstream-selector-policy-client";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-downstream-policy-access-client";
            interface.name = "ens4";
          };

          policy-mgmt = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-mgmt";
            adapterName = "adp-enterprisea-site-a-s-router-downstream-selector-policy-mgmt";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-downstream-policy-access-mgmt";
            interface.name = "ens5";
          };

          policy-dmz = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-dmz";
            adapterName = "adp-enterprisea-site-a-s-router-downstream-selector-policy-dmz";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-downstream-policy-access-dmz";
            interface.name = "ens6";
          };

          access-admin = {
            link = "p2p-s-router-access-admin-s-router-downstream-selector";
            adapterName = "adp-enterprisea-site-a-s-router-downstream-selector-access-admin";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-downstream-admin";
            };
            interface.name = "ens7";
          };

          access-client = {
            link = "p2p-s-router-access-client-s-router-downstream-selector";
            adapterName = "adp-enterprisea-site-a-s-router-downstream-selector-access-client";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-downstream-client";
            };
            interface.name = "ens8";
          };

          access-mgmt = {
            link = "p2p-s-router-access-mgmt-s-router-downstream-selector";
            adapterName = "adp-enterprisea-site-a-s-router-downstream-selector-access-mgmt";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-downstream-mgmt";
            };
            interface.name = "ens9";
          };

          access-dmz = {
            link = "p2p-s-router-access-dmz-s-router-downstream-selector";
            adapterName = "adp-enterprisea-site-a-s-router-downstream-selector-access-dmz";
            attach = {
              kind = "bridge";
              bridge = "br-site-a-downstream-dmz";
            };
            interface.name = "ens10";
          };
        };
      };

      enterpriseA-site-a-s-router-access-admin = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "enterpriseA";
          site = "site-a";
          name = "s-router-access-admin";
        };
        containers.default.runtimeName = "default";
        ports.transit-downstream-selector = {
          link = "p2p-s-router-access-admin-s-router-downstream-selector";
          adapterName = "adp-enterprisea-site-a-s-router-access-admin-transit-downstream-selector";
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

      enterpriseA-site-a-s-router-access-client = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "enterpriseA";
          site = "site-a";
          name = "s-router-access-client";
        };
        containers.default.runtimeName = "default";
        ports.transit-downstream-selector = {
          link = "p2p-s-router-access-client-s-router-downstream-selector";
          adapterName = "adp-enterprisea-site-a-s-router-access-client-transit-downstream-selector";
          attach = {
            kind = "bridge";
            bridge = "br-site-a-downstream-client";
          };
          interface.name = "ens3";
        };
        advertisements = {
          dhcp4.tenant-client = {
            pool = {
              start = "10.20.20.100";
              end = "10.20.20.200";
            };
            dnsServers = [ "router-self" ];
            domain = "lan.";
          };
          ipv6Ra.tenant-client = {
            rdnss = [ "router-self" ];
            dnssl = [ "lan." ];
          };
        };
      };

      enterpriseA-site-a-s-router-access-mgmt = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "enterpriseA";
          site = "site-a";
          name = "s-router-access-mgmt";
        };
        containers.default.runtimeName = "default";
        ports.transit-downstream-selector = {
          link = "p2p-s-router-access-mgmt-s-router-downstream-selector";
          adapterName = "adp-enterprisea-site-a-s-router-access-mgmt-transit-downstream-selector";
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

      enterpriseA-site-a-s-router-access-dmz = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "enterpriseA";
          site = "site-a";
          name = "s-router-access-dmz";
        };
        containers.default.runtimeName = "default";
        ports.transit-downstream-selector = {
          link = "p2p-s-router-access-dmz-s-router-downstream-selector";
          adapterName = "adp-enterprisea-site-a-s-router-access-dmz-transit-downstream-selector";
          attach = {
            kind = "bridge";
            bridge = "br-site-a-downstream-dmz";
          };
          interface.name = "ens3";
        };
        advertisements = {
          dhcp4.tenant-dmz = {
            pool = {
              start = "10.20.30.100";
              end = "10.20.30.200";
            };
            dnsServers = [ "router-self" ];
            domain = "lan.";
          };
          ipv6Ra.tenant-dmz = {
            rdnss = [ "router-self" ];
            dnssl = [ "lan." ];
          };
        };
      };

      enterpriseB-site-b-b-router-core = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "enterpriseB";
          site = "site-b";
          name = "b-router-core";
        };
        containers.default.runtimeName = "default";
        ports = {
          upstream-selector = {
            link = "p2p-b-router-core-b-router-upstream-selector";
            adapterName = "adp-enterpriseb-site-b-b-router-core-upstream-selector";
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
              bridge = "br-uplink1";
            };
            interface.name = "ens4";
          };
        };
      };

      enterpriseB-site-b-b-router-upstream-selector = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "enterpriseB";
          site = "site-b";
          name = "b-router-upstream-selector";
        };
        containers.default.runtimeName = "default";
        ports = {
          core = {
            link = "p2p-b-router-core-b-router-upstream-selector";
            adapterName = "adp-enterpriseb-site-b-b-router-upstream-selector-core";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-core-upstream";
            };
            interface.name = "ens3";
          };

          policy-branch-east-west = {
            link = "p2p-b-router-policy-b-router-upstream-selector--access-b-router-access-branch--uplink-east-west";
            adapterName = "adp-enterpriseb-site-b-b-router-upstream-selector-policy-branch-east-west";
            attach.kind = "bridge";
            attach.bridge = "br-site-b-policy-upstream-access-branch-east-west";
            interface.name = "ens4";
          };

          policy-branch-wan = {
            link = "p2p-b-router-policy-b-router-upstream-selector--access-b-router-access-branch--uplink-wan";
            adapterName = "adp-enterpriseb-site-b-b-router-upstream-selector-policy-branch-wan";
            attach.kind = "bridge";
            attach.bridge = "br-site-b-policy-upstream-access-branch-wan";
            interface.name = "ens5";
          };
        };
      };

      enterpriseB-site-b-b-router-policy = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "enterpriseB";
          site = "site-b";
          name = "b-router-policy";
        };
        containers.default.runtimeName = "default";
        ports = {
          upstream-branch-east-west = {
            link = "p2p-b-router-policy-b-router-upstream-selector--access-b-router-access-branch--uplink-east-west";
            adapterName = "adp-enterpriseb-site-b-b-router-policy-upstream-branch-east-west";
            attach.kind = "bridge";
            attach.bridge = "br-site-b-policy-upstream-access-branch-east-west";
            interface.name = "ens3";
          };

          upstream-branch-wan = {
            link = "p2p-b-router-policy-b-router-upstream-selector--access-b-router-access-branch--uplink-wan";
            adapterName = "adp-enterpriseb-site-b-b-router-policy-upstream-branch-wan";
            attach.kind = "bridge";
            attach.bridge = "br-site-b-policy-upstream-access-branch-wan";
            interface.name = "ens4";
          };

          downstream-branch = {
            link = "p2p-b-router-downstream-selector-b-router-policy--access-b-router-access-branch";
            adapterName = "adp-enterpriseb-site-b-b-router-policy-downstream-branch";
            attach.kind = "bridge";
            attach.bridge = "br-site-b-downstream-policy-access-branch";
            interface.name = "ens5";
          };
        };
      };

      enterpriseB-site-b-b-router-downstream-selector = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "enterpriseB";
          site = "site-b";
          name = "b-router-downstream-selector";
        };
        containers.default.runtimeName = "default";
        ports = {
          policy-branch = {
            link = "p2p-b-router-downstream-selector-b-router-policy--access-b-router-access-branch";
            adapterName = "adp-enterpriseb-site-b-b-router-downstream-selector-policy-branch";
            attach.kind = "bridge";
            attach.bridge = "br-site-b-downstream-policy-access-branch";
            interface.name = "ens3";
          };

          access-branch = {
            link = "p2p-b-router-access-branch-b-router-downstream-selector";
            adapterName = "adp-enterpriseb-site-b-b-router-downstream-selector-access-branch";
            attach = {
              kind = "bridge";
              bridge = "br-site-b-downstream-branch";
            };
            interface.name = "ens4";
          };
        };
      };

      enterpriseB-site-b-b-router-access-branch = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "enterpriseB";
          site = "site-b";
          name = "b-router-access-branch";
        };
        containers.default.runtimeName = "default";
        ports.transit-downstream-selector = {
          link = "p2p-b-router-access-branch-b-router-downstream-selector";
          adapterName = "adp-enterpriseb-site-b-b-router-access-branch-transit-downstream-selector";
          attach = {
            kind = "bridge";
            bridge = "br-site-b-downstream-branch";
          };
          interface.name = "ens3";
        };
        advertisements = {
          dhcp4.tenant-branch = {
            pool = {
              start = "10.60.10.100";
              end = "10.60.10.200";
            };
            dnsServers = [ "router-self" ];
            domain = "lan.";
          };
          ipv6Ra.tenant-branch = {
            rdnss = [ "router-self" ];
            dnssl = [ "lan." ];
          };
        };
      };
    };
  };
}
