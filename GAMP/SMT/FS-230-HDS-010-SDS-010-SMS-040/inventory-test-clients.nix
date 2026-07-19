let
  managementVlan2 = {
    bridge = "vlan2";
    mode = "vlan";
    parent = "eth0";
    vlan = 2;
    role = "management";
    ipv4 = {
      enable = true;
      dhcp = true;
      method = "dhcp";
    };
    ipv6 = {
      enable = false;
      dhcp = false;
      dhcpv6PD = false;
      acceptRA = false;
      method = "none";
    };
  };
in
{
  meta = {
    traceId = "FS-230-HDS-010-SDS-010-SMS-040";
    scope = "isolated-protected-ipv6-public-ingress-test-clients";
  };
  deploymentHosts.s-router-test-clients = {
    bridgeNetworks = {
      f230nwan = {
        mode = "vlan";
        parent = "eth0";
        vlan = 401;
      };
      f230ndmz = {
        mode = "vlan";
        parent = "eth0";
        vlan = 402;
      };
      f230cwan = {
        mode = "vlan";
        parent = "eth0";
        vlan = 403;
      };
      f230cdmz = {
        mode = "vlan";
        parent = "eth0";
        vlan = 404;
      };
    };
    uplinks.management = managementVlan2;
  };
}
