{
  pocKind = "synthetic-control-plane-input";
  schema = "network-labs.layer-entry-poc.control-plane-input.v1";
  traceId = "FS-166-HDS-010-SDS-010-SMS-900__allow-client-to-testnet-host-isp";
  note = "Synthetic CPM-entry input: precomputed NFM output plus explicit realization inventory.";

  forwardingModel = builtins.fromJSON (builtins.readFile ./minimal-forwarding-model.json);

  inventory = {
    deployment.hosts.lab-host = {
      bridgeNetworks = {
        br-layer-entry-access-downstream = { };
        br-layer-entry-downstream-policy = { };
        br-layer-entry-policy-upstream = { };
        br-layer-entry-core-upstream = { };
      };
      uplinks.uplink0 = {
        bridge = "br-layer-entry-wan";
        parent = "eth0";
        mode = "nat";
        ipv4 = {
          method = "static";
          address = "198.51.100.1/24";
        };
        ipv6 = {
          method = "static";
          address = "2001:db8:166::1/64";
        };
      };
    };

    realization.nodes = {
      esp0xdeadbeef-site-a-access-client = {
        host = "lab-host";
        advertisements = {
          dhcp4.tenant-client = {
            dnsServers = [ "router-self" ];
            domain = "layer-entry.test.";
          };
          ipv6Ra.tenant-client = {
            rdnss = [ "router-self" ];
            dnssl = [ "layer-entry.test." ];
          };
        };
        services.dns = { };
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-a";
          name = "access-client";
        };
        ports.transit-downstream = {
          adapterName = "adp-layer-entry-access-downstream";
          link = "p2p-access-client-downstream";
          attach = {
            kind = "bridge";
            bridge = "br-layer-entry-access-downstream";
          };
          interface.name = "ens3";
        };
      };

      esp0xdeadbeef-site-a-downstream = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-a";
          name = "downstream";
        };
        ports = {
          access-client = {
            adapterName = "adp-layer-entry-downstream-access";
            link = "p2p-access-client-downstream";
            attach = {
              kind = "bridge";
              bridge = "br-layer-entry-access-downstream";
            };
            interface.name = "ens3";
          };
          policy-access-client = {
            adapterName = "adp-layer-entry-downstream-policy";
            link = "p2p-downstream-policy--access-access-client";
            attach = {
              kind = "bridge";
              bridge = "br-layer-entry-downstream-policy";
            };
            interface.name = "ens4";
          };
        };
      };

      esp0xdeadbeef-site-a-policy = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-a";
          name = "policy";
        };
        ports = {
          downstream-access-client = {
            adapterName = "adp-layer-entry-policy-downstream";
            link = "p2p-downstream-policy--access-access-client";
            attach = {
              kind = "bridge";
              bridge = "br-layer-entry-downstream-policy";
            };
            interface.name = "ens3";
          };
          upstream-access-client-wan = {
            adapterName = "adp-layer-entry-policy-upstream";
            link = "p2p-policy-upstream--access-access-client--uplink-wan";
            attach = {
              kind = "bridge";
              bridge = "br-layer-entry-policy-upstream";
            };
            interface.name = "ens4";
          };
        };
      };

      esp0xdeadbeef-site-a-upstream = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-a";
          name = "upstream";
        };
        ports = {
          policy-access-client-wan = {
            adapterName = "adp-layer-entry-upstream-policy";
            link = "p2p-policy-upstream--access-access-client--uplink-wan";
            attach = {
              kind = "bridge";
              bridge = "br-layer-entry-policy-upstream";
            };
            interface.name = "ens3";
          };
          core-wan = {
            adapterName = "adp-layer-entry-upstream-core";
            link = "p2p-core-wan-upstream";
            attach = {
              kind = "bridge";
              bridge = "br-layer-entry-core-upstream";
            };
            interface.name = "ens4";
          };
        };
      };

      esp0xdeadbeef-site-a-core-wan = {
        host = "lab-host";
        platform = "linux";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          site = "site-a";
          name = "core-wan";
        };
        ports = {
          upstream-selector = {
            adapterName = "adp-layer-entry-core-upstream";
            link = "p2p-core-wan-upstream";
            attach = {
              kind = "bridge";
              bridge = "br-layer-entry-core-upstream";
            };
            interface.name = "ens3";
          };
          wan = {
            external = true;
            uplink = "wan";
            attach = {
              kind = "bridge";
              bridge = "br-layer-entry-wan";
            };
            interface.name = "ens4";
          };
        };
      };
    };
  };
}
