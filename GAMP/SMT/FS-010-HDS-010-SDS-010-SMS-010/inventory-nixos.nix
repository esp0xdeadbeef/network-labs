{
  meta = {
    traceId = "FS-010-HDS-010-SDS-010-SMS-010";
    scope = "mini-smt-auto";
  };
  hosts = {};
  deployment.hosts = {
    s-router-nixos = {
      bridgeNetworks = {
        admin = {};
        branch = {};
        client = {};
        br-p2p-client-edge-downstream-selector = {};
        br-p2p-downstream-selector-policy--access-client-edge = {};
        br-p2p-policy-upstream-selector--access-client-edge--uplink-internet-vlan4 = {};
        br-p2p-core-vlan4-client-dhcp-slaac-upstream-selector = {};
      };
      uplinks = {
        internet-vlan4 = {
          bridge = "internet-vlan4";
          parent = "eth0";
          vlan = 4;
          mode = "vlan";
          ipv4 = {
            enable = false;
            method = "none";
          };
          ipv6 = {
            enable = false;
            method = "none";
          };
        };
      };
    };
  };
  realization.nodes = {
    mini-smt-FS-010-HDS-010-SDS-010-SMS-010-client-edge = {
      advertisements = {
        dhcp4.tenant-client = {
          dnsServers = [ "router-self" ];
          domain = "lan.";
        };
        ipv6Ra.tenant-client = {
          dnssl = [ "lan." ];
          rdnss = [ "router-self" ];
        };
      };
      services.dns = {};
      host = "s-router-nixos";
      logicalNode = {
        enterprise = "mini-smt";
        site = "FS-010-HDS-010-SDS-010-SMS-010";
        name = "client-edge";
      };
      platform = "linux";
      ports.transit-downstream-selector = {
        link = "p2p-client-edge-downstream-selector";
        adapterName = "adp-mini-smt-fs010-client-edge-downstream-selector";
        attach = {
          kind = "bridge";
          bridge = "br-p2p-client-edge-downstream-selector";
        };
        interface.name = "ens3";
      };
    };
    mini-smt-FS-010-HDS-010-SDS-010-SMS-010-downstream-selector = {
      host = "s-router-nixos";
      logicalNode = {
        enterprise = "mini-smt";
        site = "FS-010-HDS-010-SDS-010-SMS-010";
        name = "downstream-selector";
      };
      platform = "linux";
      ports = {
        access-client = {
          link = "p2p-client-edge-downstream-selector";
          adapterName = "adp-mini-smt-fs010-downstream-selector-access-client";
          attach = {
            kind = "bridge";
            bridge = "br-p2p-client-edge-downstream-selector";
          };
          interface.name = "ens3";
        };
        policy-access-client = {
          link = "p2p-downstream-selector-policy--access-client-edge";
          adapterName = "adp-mini-smt-fs010-downstream-selector-policy-access-client";
          attach = {
            kind = "bridge";
            bridge = "br-p2p-downstream-selector-policy--access-client-edge";
          };
          interface.name = "ens4";
        };
      };
    };
    mini-smt-FS-010-HDS-010-SDS-010-SMS-010-policy = {
      host = "s-router-nixos";
      logicalNode = {
        enterprise = "mini-smt";
        site = "FS-010-HDS-010-SDS-010-SMS-010";
        name = "policy";
      };
      platform = "linux";
      ports = {
        downstream-access-client = {
          link = "p2p-downstream-selector-policy--access-client-edge";
          adapterName = "adp-mini-smt-fs010-policy-downstream-access-client";
          attach = {
            kind = "bridge";
            bridge = "br-p2p-downstream-selector-policy--access-client-edge";
          };
          interface.name = "ens3";
        };
        upstream-access-client-internet-vlan4 = {
          link = "p2p-policy-upstream-selector--access-client-edge--uplink-internet-vlan4";
          adapterName = "adp-mini-smt-fs010-policy-upstream-access-client-internet-vlan4";
          attach = {
            kind = "bridge";
            bridge = "br-p2p-policy-upstream-selector--access-client-edge--uplink-internet-vlan4";
          };
          interface.name = "ens4";
        };
      };
    };
    mini-smt-FS-010-HDS-010-SDS-010-SMS-010-upstream-selector = {
      host = "s-router-nixos";
      logicalNode = {
        enterprise = "mini-smt";
        site = "FS-010-HDS-010-SDS-010-SMS-010";
        name = "upstream-selector";
      };
      platform = "linux";
      ports = {
        policy-access-client-internet-vlan4 = {
          link = "p2p-policy-upstream-selector--access-client-edge--uplink-internet-vlan4";
          adapterName = "adp-mini-smt-fs010-upstream-selector-policy-access-client-internet-vlan4";
          attach = {
            kind = "bridge";
            bridge = "br-p2p-policy-upstream-selector--access-client-edge--uplink-internet-vlan4";
          };
          interface.name = "ens3";
        };
        core-internet-vlan4 = {
          link = "p2p-core-vlan4-client-dhcp-slaac-upstream-selector";
          adapterName = "adp-mini-smt-fs010-upstream-selector-core-internet-vlan4";
          attach = {
            kind = "bridge";
            bridge = "br-p2p-core-vlan4-client-dhcp-slaac-upstream-selector";
          };
          interface.name = "ens4";
        };
      };
    };
    mini-smt-FS-010-HDS-010-SDS-010-SMS-010-core-vlan4-client-dhcp-slaac = {
      host = "s-router-nixos";
      logicalNode = {
        enterprise = "mini-smt";
        site = "FS-010-HDS-010-SDS-010-SMS-010";
        name = "core-vlan4-client-dhcp-slaac";
      };
      platform = "linux";
      ports = {
        upstream-selector = {
          link = "p2p-core-vlan4-client-dhcp-slaac-upstream-selector";
          adapterName = "adp-mini-smt-fs010-core-vlan4-client-dhcp-slaac-upstream-selector";
          attach = {
            kind = "bridge";
            bridge = "br-p2p-core-vlan4-client-dhcp-slaac-upstream-selector";
          };
          interface.name = "ens3";
        };
        internet-vlan4 = {
          uplink = "internet-vlan4";
          external = true;
          attach = {
            kind = "bridge";
            bridge = "internet-vlan4";
          };
          interface.name = "ens4";
        };
      };
    };
  };
}
