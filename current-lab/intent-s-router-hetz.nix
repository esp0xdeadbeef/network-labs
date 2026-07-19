let
  inventory = import ./inventory-hetz.nix;
  hetzHost = (inventory.deploymentHosts or { }).s-router-hetz or { };
in
rec {
  control_plane_model = {
    meta = {
      traceId = "FS-230-HDS-010-SDS-010-SMS-040";
      source = "network-labs current-lab SMT/SIT hetz-host no-runtime source";
    };
    deployment.hosts.s-router-hetz = hetzHost // {
      bridgeNetworks = hetzHost.bridgeNetworks or { };
    };
    render.hosts.s-router-hetz.deploymentHost = "s-router-hetz";
    realization.nodes = { };
    data.active-lab.hetz = {
      enterprise = "active-lab";
      siteName = "hetz";
      runtimeTargets = { };
    };
  };
  deploymentHosts = control_plane_model.deployment.hosts;
  deployment = control_plane_model.deployment;
  realization = control_plane_model.realization;
}
