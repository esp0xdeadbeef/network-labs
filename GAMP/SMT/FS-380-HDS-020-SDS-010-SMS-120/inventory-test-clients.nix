let
  clientBridge = "client";
  clientVlan = 302;
  managementVlan2 = {
    bridge = "vlan2";
    ipv4 = {
      dhcp = true;
      enable = true;
      method = "dhcp";
    };
    ipv6 = {
      acceptRA = false;
      dhcp = false;
      dhcpv6PD = false;
      enable = false;
      method = "none";
    };
    mode = "vlan";
    parent = "eth0";
    role = "management";
    vlan = 2;
  };
in
{
  meta = {
    traceId = "FS-380-HDS-020-SDS-010-SMS-120";
    scope = "prod-like-ipv4-vlan4-client-egress-test-client";
  };
  clients = { };
  hosts = { };
  deploymentHosts = {
    s-router-test-clients = {
      bridgeNetworks = {
        ${clientBridge} = {
          mode = "vlan";
          parent = "eth0";
          vlan = clientVlan;
        };
      };
      uplinks.management = managementVlan2;
    };
  };
  realization.nodes = { };
}
