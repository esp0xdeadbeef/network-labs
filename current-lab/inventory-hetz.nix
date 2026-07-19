let
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
    vlan = 2;
  };
in
rec {
  activeLabInventoryStub = {
    kind = "unsupported-runtime-host-stub";
    traceId = "FS-560-HDS-010-SDS-010-SMS-050";
    hostName = "s-router-hetz";
  };
  deployment.hosts."s-router-hetz" = {
    uplinks.management = managementVlan2;
    bridgeNetworks = { };
  };
  deploymentHosts = deployment.hosts;
  realization.nodes = { };
  endpoints = { };
  clients = { };
}
