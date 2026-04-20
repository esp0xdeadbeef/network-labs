{
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

          # Dedicated lane bridges (derived from policy intent).
          br-site-a-policy-upstream-access-adm-isp-a = { };
          br-site-a-policy-upstream-access-adm-isp-b = { };
          br-site-a-policy-upstream-access-mgmt-isp-a = { };
          br-site-a-policy-upstream-access-mgmt-isp-b = { };

          br-site-a-downstream-policy-access-adm = { };
          br-site-a-downstream-policy-access-mgmt = { };

          br-site-a-downstream-adm = { };
          br-site-a-downstream-mgmt = { };
        };
      };
    };
  };

  realization = {
    nodes = {
      esp0xdeadbeef-site-a-s-router-core-isp-a = {
        host = "lab-host";
        platform = "linux";
        logicalNode.enterprise = "esp0xdeadbeef";
        logicalNode.site = "site-a";
        logicalNode.name = "s-router-core-isp-a";
        containers.default.runtimeName = "default";

        ports = {
          upstream-selector = {
            link = "p2p-s-router-core-isp-a-s-router-upstream-selector";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-core-isp-a-upstream";
            interface.name = "ens3";
          };

          isp-a = {
            uplink = "isp-a";
            external = true;
            attach.kind = "bridge";
            attach.bridge = "br-uplink0";
            interface.name = "ens4";
          };
        };
      };

      esp0xdeadbeef-site-a-s-router-core-isp-b = {
        host = "lab-host";
        platform = "linux";
        logicalNode.enterprise = "esp0xdeadbeef";
        logicalNode.site = "site-a";
        logicalNode.name = "s-router-core-isp-b";
        containers.default.runtimeName = "default";

        ports = {
          upstream-selector = {
            link = "p2p-s-router-core-isp-b-s-router-upstream-selector";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-core-isp-b-upstream";
            interface.name = "ens3";
          };

          isp-b = {
            uplink = "isp-b";
            external = true;
            attach.kind = "bridge";
            attach.bridge = "br-uplink1";
            interface.name = "ens4";
          };
        };
      };

      esp0xdeadbeef-site-a-s-router-upstream-selector = {
        host = "lab-host";
        platform = "linux";
        logicalNode.enterprise = "esp0xdeadbeef";
        logicalNode.site = "site-a";
        logicalNode.name = "s-router-upstream-selector";
        containers.default.runtimeName = "default";

        ports = {
          core-isp-a = {
            link = "p2p-s-router-core-isp-a-s-router-upstream-selector";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-core-isp-a-upstream";
            interface.name = "ens3";
          };

          core-isp-b = {
            link = "p2p-s-router-core-isp-b-s-router-upstream-selector";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-core-isp-b-upstream";
            interface.name = "ens4";
          };

          policy-access-adm-isp-a = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-adm--uplink-isp-a";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-adm-isp-a";
            interface.name = "ens5";
          };

          policy-access-adm-isp-b = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-adm--uplink-isp-b";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-adm-isp-b";
            interface.name = "ens6";
          };

          policy-access-mgmt-isp-a = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-mgmt--uplink-isp-a";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-mgmt-isp-a";
            interface.name = "ens7";
          };

          policy-access-mgmt-isp-b = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-mgmt--uplink-isp-b";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-mgmt-isp-b";
            interface.name = "ens8";
          };
        };
      };

      esp0xdeadbeef-site-a-s-router-policy = {
        host = "lab-host";
        platform = "linux";
        logicalNode.enterprise = "esp0xdeadbeef";
        logicalNode.site = "site-a";
        logicalNode.name = "s-router-policy";
        containers.default.runtimeName = "default";

        ports = {
          upstream-access-adm-isp-a = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-adm--uplink-isp-a";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-adm-isp-a";
            interface.name = "ens3";
          };

          upstream-access-adm-isp-b = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-adm--uplink-isp-b";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-adm-isp-b";
            interface.name = "ens4";
          };

          upstream-access-mgmt-isp-a = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-mgmt--uplink-isp-a";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-mgmt-isp-a";
            interface.name = "ens5";
          };

          upstream-access-mgmt-isp-b = {
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-mgmt--uplink-isp-b";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-policy-upstream-access-mgmt-isp-b";
            interface.name = "ens6";
          };

          downstream-access-adm = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-adm";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-downstream-policy-access-adm";
            interface.name = "ens7";
          };

          downstream-access-mgmt = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-mgmt";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-downstream-policy-access-mgmt";
            interface.name = "ens8";
          };
        };
      };

      esp0xdeadbeef-site-a-s-router-downstream-selector = {
        host = "lab-host";
        platform = "linux";
        logicalNode.enterprise = "esp0xdeadbeef";
        logicalNode.site = "site-a";
        logicalNode.name = "s-router-downstream-selector";
        containers.default.runtimeName = "default";

        ports = {
          policy-access-adm = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-adm";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-downstream-policy-access-adm";
            interface.name = "ens3";
          };

          policy-access-mgmt = {
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-mgmt";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-downstream-policy-access-mgmt";
            interface.name = "ens4";
          };

          access-adm = {
            link = "p2p-s-router-access-adm-s-router-downstream-selector";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-downstream-adm";
            interface.name = "ens5";
          };

          access-mgmt = {
            link = "p2p-s-router-access-mgmt-s-router-downstream-selector";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-downstream-mgmt";
            interface.name = "ens6";
          };
        };
      };

      esp0xdeadbeef-site-a-s-router-access-adm = {
        host = "lab-host";
        platform = "linux";
        logicalNode.enterprise = "esp0xdeadbeef";
        logicalNode.site = "site-a";
        logicalNode.name = "s-router-access-adm";
        containers.default.runtimeName = "default";

        ports = {
          transit-downstream-selector = {
            link = "p2p-s-router-access-adm-s-router-downstream-selector";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-downstream-adm";
            interface.name = "ens3";
          };
        };

        advertisements = {
          dhcp4.tenant-adm = {
            pool.start = "10.21.10.100";
            pool.end = "10.21.10.200";
            dnsServers = [ "router-self" ];
            domain = "lan.";
          };

          ipv6Ra.tenant-adm = {
            rdnss = [ "router-self" ];
            dnssl = [ "lan." ];
          };
        };
      };

      esp0xdeadbeef-site-a-s-router-access-mgmt = {
        host = "lab-host";
        platform = "linux";
        logicalNode.enterprise = "esp0xdeadbeef";
        logicalNode.site = "site-a";
        logicalNode.name = "s-router-access-mgmt";
        containers.default.runtimeName = "default";

        ports = {
          transit-downstream-selector = {
            link = "p2p-s-router-access-mgmt-s-router-downstream-selector";
            attach.kind = "bridge";
            attach.bridge = "br-site-a-downstream-mgmt";
            interface.name = "ens3";
          };
        };

        advertisements = {
          dhcp4.tenant-mgmt = {
            pool.start = "10.20.10.100";
            pool.end = "10.20.10.200";
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
