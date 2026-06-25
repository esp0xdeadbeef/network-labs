{
  control_plane_model = {
    meta = { };
    endpoints = { };
    deployment.hosts.hypervisor-a = {
      uplinks = { };
      bridgeNetworks = { };
    };
    render.hosts.lab-host.deploymentHost = "hypervisor-a";
    realization.nodes = { };
    data.acme.lab = {
      enterprise = "acme";
      siteName = "acme.lab";
      runtimeTargets.poc-router = {
        placement.host = "hypervisor-a";
        logicalNode = {
          enterprise = "acme";
          site = "lab";
          name = "poc-router";
        };
        role = "access";
        containers = [
          {
            name = "default";
            container = "poc-router";
          }
        ];
        effectiveRuntimeRealization.interfaces = { };
      };
    };
  };
}
