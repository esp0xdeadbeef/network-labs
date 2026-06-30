{
  meta = {
    traceId = "FS-380-HDS-020-SDS-010-SMS-050";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-380-HDS-020-SDS-010-SMS-050-renderer-internet-mode-verification.md";
    renderer = "clab";
    scope = "mini-smt-internet-mode-verification-source-fixture";
    evidenceBoundary = "source-fixture";
  };
  containerlab = {
    capabilities = {
      labEmulation = true;
    };
    labEmulation = {
      scope = "harness";
      requests = [
        {
          providerEmulationMode = "fake-provider";
          name = "fs380-internet-mode-provider";
          handoffVlan = 11;
          liveUpstreamVlan = 4;
          dhcp4 = {
            address = "10.20.0.1/24";
            router = "10.20.0.1";
            clientAddress = "10.20.0.20";
            rangeStart = "10.20.0.20";
            rangeEnd = "10.20.0.99";
            leaseTime = "5m";
            sourcePrefix = "10.20.0.0/24";
          };
          nat44 = {
            enabled = true;
            sourcePrefix = "10.20.0.0/24";
          };
        }
      ];
    };
  };
  hosts = { };
  deploymentHosts = {
    s-router-clab = {
      accessHandoff = {
        kind = "pppoe";
        server = "emulated-isp";
      };
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
