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
  meta = {
    traceId = "FS-166-HDS-010-SDS-010-SMS-900";
    evidenceBoundary = "construction-only";
    constructionOnly = true;
  };
  activeLabConstructionOnly = {
    traceId = "FS-166-HDS-010-SDS-010-SMS-900";
    rowDirectory = ../GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900;
    evidenceBoundary = "construction-only";
  };
  deployment = {
    hosts = {
      s-router-nixos = {
        uplinks.management = managementVlan2;
        bridgeNetworks = { };
      };
      s-router-clab = {
        uplinks.management = managementVlan2;
        bridgeNetworks = { };
      };
      s-router-test-clients = {
        uplinks.management = managementVlan2;
        bridgeNetworks = { };
      };
    };
  };
  deploymentHosts = deployment.hosts;
  endpoints = { };
  realization = { nodes = { }; };
  clients = { };
}
