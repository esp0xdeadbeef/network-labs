let
  internetUplinks = {
    isp = {
      bridge = "isp";
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
    pppoe-provider = {
      bridge = "pppoe-provider";
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
in
{
  meta = {
    traceId = "FS-380-HDS-020-SDS-010-SMS-050";
    scope = "internet-mode-emulated-isp";
  };
  hosts = { };
  deploymentHosts = {
    s-router-test-clients = {
      accessHandoff = {
        kind = "pppoe";
        server = "emulated-isp";
      };
      bridgeNetworks = {
        admin = { };
        branch = { };
        client = { };
      };
      uplinks = internetUplinks;
    };
  };
  realization.nodes = { };
}
