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
  activeLabConstructionOnly = {
    traceId = "FS-100-HDS-010-SDS-010-SMS-050";
    rowDirectory = ../GAMP/SMT/FS-100-HDS-010-SDS-010-SMS-050;
    evidenceBoundary = "construction-only";
    note = "This active-lab selection has no runtime topology. Run tests/run-active-lab-mini-smt.sh FS-100-HDS-010-SDS-010-SMS-050 for the owning construction check.";
  };

  control_plane_model = {
    meta = {
      traceId = "FS-100-HDS-010-SDS-010-SMS-050";
      source = "network-labs current-lab construction-only renderer-input stub";
      evidenceBoundary = "construction-only";
      expectedRuntimeTargets = [ ];
      constructionOnly = true;
    };

    endpoints = { };
    deployment.hosts = {
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
    render.hosts = {
      s-router-nixos.deploymentHost = "s-router-nixos";
      s-router-clab.deploymentHost = "s-router-clab";
      s-router-test-clients.deploymentHost = "s-router-test-clients";
    };
    realization.nodes = { };
    data.active-lab.construction-only = {
      enterprise = "active-lab";
      siteName = "construction-only";
      runtimeTargets = { };
    };
  };

  deploymentHosts = control_plane_model.deployment.hosts;
  deployment = control_plane_model.deployment;
  realization = control_plane_model.realization;
}
