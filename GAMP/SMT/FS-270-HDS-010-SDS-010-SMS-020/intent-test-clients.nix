let
  traceId = "FS-270-HDS-010-SDS-010-SMS-020";
  inventory = import ./inventory-test-clients.nix;
  testClientHost = inventory.deploymentHosts.s-router-test-clients;
  mkEndpoint = name: bridge: tenant: address: address6: gateway4: gateway6: {
    inherit
      name
      bridge
      tenant
      ;
    enterprise = "mini-smt";
    site = traceId;
    family = "dual";
    mode = "static";
    owningSubstrate = "s-router-test-clients";
    namespaceOwner = "access-${tenant}";
    gampIds = [
      traceId
      "FS-720-HDS-030-SDS-010-SMS-041"
      "FS-983-HDS-010-SDS-010-SMS-010"
    ];
    static = {
      inherit
        address
        address6
        gateway4
        gateway6
        ;
      prefixLength = 24;
      prefixLength6 = 64;
    };
  };
  endpointAssignment = {
    fs270-nixos-source =
      mkEndpoint "fs270-nixos-source" "f270nsrc" "source" "10.27.70.20" "fd42:270:70::20" "10.27.70.1"
        "fd42:270:70::1";
    fs270-nixos-destination =
      mkEndpoint "fs270-nixos-destination" "f270ndst" "destination" "10.27.71.10" "fd42:270:71::10"
        "10.27.71.1"
        "fd42:270:71::1";
    fs270-clab-source =
      mkEndpoint "fs270-clab-source" "f270csrc" "source" "10.27.70.20" "fd42:270:70::20" "10.27.70.1"
        "fd42:270:70::1";
    fs270-clab-destination =
      mkEndpoint "fs270-clab-destination" "f270cdst" "destination" "10.27.71.10" "fd42:270:71::10"
        "10.27.71.1"
        "fd42:270:71::1";
  };
in
rec {
  control_plane_model = {
    meta = {
      inherit traceId;
      source = "network-labs ${traceId} isolated access-service endpoints";
    };
    deployment.hosts.s-router-test-clients = testClientHost;
    render.hosts.s-router-test-clients.deploymentHost = "s-router-test-clients";
    realization.nodes = { };
    data."mini-smt"."${traceId}" = {
      enterprise = "mini-smt";
      siteName = traceId;
      runtimeTargets = { };
      inherit endpointAssignment;
    };
  };
  inherit endpointAssignment;
  deployment = control_plane_model.deployment;
  deploymentHosts = control_plane_model.deployment.hosts;
  realization = control_plane_model.realization;
  render = control_plane_model.render;
}
