{
  meta = {
    traceId = "FS-380-HDS-020-SDS-010-SMS-050";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-380-HDS-020-SDS-010-SMS-050-renderer-internet-mode-verification.md";
    renderer = "test-clients";
    scope = "mini-smt-internet-mode-verification-source-fixture";
    evidenceBoundary = "source-fixture";
  };
  clients = { };
  deploymentHosts = {
    s-router-test-clients = {
      accessHandoff = {
        kind = "pppoe";
        server = "emulated-isp";
      };
      hat.endpointClients = { };
      uplinks = {
        internet-vlan4 = {
          bridge = "internet-vlan4";
          ipv4 = {
            dhcp = true;
            enable = true;
            method = "dhcp";
          };
          ipv6 = {
            acceptRA = true;
            dhcp = false;
            dhcpv6PD = false;
            enable = true;
            method = "slaac";
          };
          mode = "vlan";
          parent = "eth0";
          vlan = 4;
        };
        internet-vlan5 = {
          bridge = "internet-vlan5";
          ipv4 = {
            dhcp = true;
            enable = true;
            method = "dhcp";
          };
          ipv6 = {
            acceptRA = true;
            dhcp = false;
            dhcpv6PD = false;
            enable = true;
            method = "slaac";
          };
          mode = "vlan";
          parent = "eth0";
          vlan = 5;
        };
      };
    };
  };
}
