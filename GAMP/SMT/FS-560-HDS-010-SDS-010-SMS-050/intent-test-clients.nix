let
  inventory = import ./inventory-test-clients.nix;
  managementVlan2 = {
    bridge = "vlan2";
    mode = "vlan";
    parent = "eth0";
    vlan = 2;
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
  testClientHost = inventory.deploymentHosts.s-router-test-clients // {
    uplinks.management = managementVlan2;
  };
  endpointAssignment = {
    reservation-probe = {
      mode = "dhcp";
      name = "reservation-probe";
      bridge = "rsv560";
      tenant = "client";
      owningSubstrate = "s-router-test-clients";
      namespaceOwner = "s-router-test-clients";
      dhcp = {
        servedPrefix4 = "10.3.202.0/24";
        servedPrefix6 = "fd42:03ca:50::/64";
      };
      gampIds = [ "FS-560-HDS-010-SDS-010-SMS-050" ];
    };
    reservation-probe-clab = {
      mode = "dhcp";
      name = "reservation-probe-clab";
      bridge = "rsv560-clab";
      tenant = "client";
      owningSubstrate = "s-router-test-clients";
      namespaceOwner = "s-router-test-clients";
      dhcp = {
        servedPrefix4 = "10.3.202.0/24";
        servedPrefix6 = "fd42:03ca:50::/64";
      };
      gampIds = [ "FS-560-HDS-010-SDS-010-SMS-050" ];
    };
  };
in
rec {
  inherit endpointAssignment;
  bridgeNetworks = testClientHost.bridgeNetworks;

  control_plane_model = {
    meta = {
      traceId = "FS-560-HDS-010-SDS-010-SMS-050";
      source = "network-labs protected-reservation name-publication live test-client";
    };
    deployment.hosts.s-router-test-clients = testClientHost;
    render.hosts.s-router-test-clients.deploymentHost = "s-router-test-clients";
    realization.nodes = { };
    data."mini-smt".FS-560-HDS-010-SDS-010-SMS-050 = {
      enterprise = "mini-smt";
      siteName = "FS-560-HDS-010-SDS-010-SMS-050";
      runtimeTargets = { };
      inherit endpointAssignment;
    };
  };

  deploymentHosts = control_plane_model.deployment.hosts;
  deployment = control_plane_model.deployment;
  realization = control_plane_model.realization;
}
