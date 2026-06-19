{
  deployment.hosts.template-on-prem-host = {
    bridgeNetworks = { };
    uplinks.management = {
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
      vlan = 2;
    };
  };
}
