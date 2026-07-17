let
  traceId = "FS-260-HDS-010-SDS-010-SMS-010";
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
    fs260-nixos-source =
      mkEndpoint "fs260-nixos-source" "f260nsrc" "source" "10.2.60.10" "fd42:0104:60::10" "10.2.60.1" "fd42:0104:60::1";
    fs260-nixos-destination =
      mkEndpoint "fs260-nixos-destination" "f260ndst" "destination" "10.2.61.10" "fd42:0104:61::10" "10.2.61.1" "fd42:0104:61::1";
    fs260-clab-source =
      mkEndpoint "fs260-clab-source" "f260csrc" "source" "10.2.60.10" "fd42:0104:60::10" "10.2.60.1" "fd42:0104:60::1";
    fs260-clab-destination =
      mkEndpoint "fs260-clab-destination" "f260cdst" "destination" "10.2.61.10" "fd42:0104:61::10" "10.2.61.1" "fd42:0104:61::1";
  };
in
rec {
  control_plane_model = {
    meta = {
      inherit traceId;
      source = "network-labs ${traceId} isolated access-return endpoints";
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
