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
    traceId = "FS-270-HDS-010-SDS-010-SMS-020";
    scope = "isolated-access-service-policy-state-owner-test-clients";
  };
  deploymentHosts.s-router-test-clients = {
    bridgeNetworks = {
      f270nsrc = {
        mode = "vlan";
        parent = "eth0";
        vlan = 407;
      };
      f270ndst = {
        mode = "vlan";
        parent = "eth0";
        vlan = 408;
      };
      f270csrc = {
        mode = "vlan";
        parent = "eth0";
        vlan = 409;
      };
      f270cdst = {
        mode = "vlan";
        parent = "eth0";
        vlan = 410;
      };
    };
    uplinks.management = managementVlan2;
  };
}
