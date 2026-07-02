let
  inventory = import ./inventory-test-clients.nix;
  testClientHost = (inventory.deploymentHosts or { }).s-router-test-clients or { };
in
rec {
  control_plane_model = {
    meta = {
      traceId = "FS-140-HDS-010-SDS-010-SMS-010";
      source = "network-labs current-lab SMT/SIT client-host no-endpoint source";
    };
    deployment.hosts.s-router-test-clients = testClientHost // {
      bridgeNetworks = testClientHost.bridgeNetworks or { };
    };
    render.hosts.s-router-test-clients.deploymentHost = "s-router-test-clients";
    realization.nodes = { };
    data.active-lab.test-clients = {
      enterprise = "active-lab";
      siteName = "test-clients";
      runtimeTargets = { };
      endpointAssignment = { };
    };
  };
  deploymentHosts = control_plane_model.deployment.hosts;
  deployment = control_plane_model.deployment;
  realization = control_plane_model.realization;
}
