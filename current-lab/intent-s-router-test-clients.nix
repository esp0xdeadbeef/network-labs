let
  source = import ../GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-045/intent-test-clients.nix;
  inventory = import ./inventory-test-clients.nix;
  sourceCpm = source.control_plane_model or source;
  sourceDeployment = sourceCpm.deployment or { };
  testClientHost = inventory.deploymentHosts.s-router-test-clients;
  managedDeployment = sourceDeployment // {
    hosts = (sourceDeployment.hosts or { }) // {
      s-router-test-clients = testClientHost;
    };
  };
  managedCpm = sourceCpm // {
    deployment = managedDeployment;
  };
in
source // {
  control_plane_model = managedCpm;
  deployment = managedDeployment;
  deploymentHosts = managedDeployment.hosts;
}
