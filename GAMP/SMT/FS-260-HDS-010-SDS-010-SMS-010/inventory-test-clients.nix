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
    traceId = "FS-260-HDS-010-SDS-010-SMS-010";
    scope = "isolated-policy-required-access-return-test-clients";
  };
  deploymentHosts.s-router-test-clients = {
    bridgeNetworks = {
      f260nsrc = {
        mode = "vlan";
        parent = "eth0";
        vlan = 393;
      };
      f260ndst = {
        mode = "vlan";
        parent = "eth0";
        vlan = 394;
      };
      f260csrc = {
        mode = "vlan";
        parent = "eth0";
        vlan = 395;
      };
      f260cdst = {
        mode = "vlan";
        parent = "eth0";
        vlan = 396;
      };
    };
    uplinks.management = managementVlan2;
  };
}
