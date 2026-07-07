let
  inventory = import ./inventory-clab.nix;
  clabHost = (inventory.deploymentHosts or { }).s-router-clab or { };
in
rec {
  control_plane_model = {
    meta = {
      traceId = "FS-166-HDS-010-SDS-010-SMS-902";
      source = "network-labs current-lab SMT/SIT clab-host no-runtime source";
    };
    deployment.hosts.s-router-clab = clabHost // {
      bridgeNetworks = clabHost.bridgeNetworks or { };
    };
    render.hosts.s-router-clab.deploymentHost = "s-router-clab";
    realization.nodes = { };
    data.active-lab.clab = {
      enterprise = "active-lab";
      siteName = "clab";
      runtimeTargets = { };
    };
  };
  deploymentHosts = control_plane_model.deployment.hosts;
  deployment = control_plane_model.deployment;
  realization = control_plane_model.realization;
}
