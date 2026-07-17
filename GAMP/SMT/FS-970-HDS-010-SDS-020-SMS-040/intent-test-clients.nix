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
    uplinks = (inventory.deploymentHosts.s-router-test-clients.uplinks or { }) // {
      management = managementVlan2;
    };
  };
  endpointAssignment = {
    reservation-probe = {
      mode = "dhcp";
      name = "reservation-probe";
      bridge = "rsv970";
      tenant = "client";
      owningSubstrate = "s-router-test-clients";
      namespaceOwner = "s-router-test-clients";
      dhcp = {
        servedPrefix4 = "10.3.202.0/24";
        servedPrefix6 = "fd42:03ca:50::/64";
      };
      gampIds = [ "FS-970-HDS-010-SDS-020-SMS-040" ];
    };
  };
in
rec {
  inherit endpointAssignment;
  bridgeNetworks = testClientHost.bridgeNetworks;

  control_plane_model = {
    meta = {
      traceId = "FS-970-HDS-010-SDS-020-SMS-040";
      source = "network-labs protected-reservation live test-client";
    };
    deployment.hosts.s-router-test-clients = testClientHost;
    render.hosts.s-router-test-clients.deploymentHost = "s-router-test-clients";
    realization.nodes = { };
    data."mini-smt"."FS-970-HDS-010-SDS-020-SMS-040" = {
      enterprise = "mini-smt";
      siteName = "FS-970-HDS-010-SDS-020-SMS-040";
      runtimeTargets = { };
      inherit endpointAssignment;
    };
  };

  deploymentHosts = control_plane_model.deployment.hosts;
  deployment = control_plane_model.deployment;
  realization = control_plane_model.realization;
}
