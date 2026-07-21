let
  inventory = import ./inventory-test-clients.nix;
  testClientHost = (inventory.deploymentHosts or { }).s-router-test-clients or { };
  traceId = "FS-540-HDS-010-SDS-010-SMS-020";
  endpoint =
    {
      name,
      bridge,
    }:
    {
      inherit bridge name;
      enterprise = "mini-smt";
      family = "dual";
      gampIds = [
        traceId
        "FS-720-HDS-030-SDS-010-SMS-041"
        "FS-983-HDS-010-SDS-010-SMS-010"
      ];
      mode = "static";
      namespaceOwner = "access-dns";
      owningSubstrate = "s-router-test-clients";
      site = traceId;
      tenant = "client";
      static = {
        address = "10.54.10.10";
        address6 = "fd42:540::10";
        gateway4 = "10.54.10.1";
        gateway6 = "fd42:540::1";
        prefixLength = 24;
        prefixLength6 = 64;
        dnsServers = [
          "10.54.10.1"
          "fd42:540::1"
        ];
      };
    };
in
rec {
  control_plane_model = {
    meta = {
      inherit traceId;
      source = "network-labs ${traceId} row-local test-client endpoint CPM source";
      layerEntry = {
        repo = "network-labs";
        entryBoundary = "row-local-test-client-renderer-input";
        inputTreatment = "endpoint-only-pass-through";
      };
    };
    deployment.hosts.s-router-test-clients = testClientHost // {
      bridgeNetworks = testClientHost.bridgeNetworks or { };
    };
    render.hosts.s-router-test-clients.deploymentHost = "s-router-test-clients";
    realization.nodes = { };
    data."mini-smt"."${traceId}" = {
      enterprise = "mini-smt";
      siteName = traceId;
      runtimeTargets = { };
      endpointAssignment = {
        dns-resolver-nixos-client = endpoint {
          name = "dns-resolver-nixos-client";
          bridge = "dns540n";
        };
        dns-resolver-clab-client = endpoint {
          name = "dns-resolver-clab-client";
          bridge = "dns540c";
        };
      };
    };
  };
  deployment = control_plane_model.deployment;
  deploymentHosts = control_plane_model.deployment.hosts;
  realization = control_plane_model.realization;
  render = control_plane_model.render;
}
