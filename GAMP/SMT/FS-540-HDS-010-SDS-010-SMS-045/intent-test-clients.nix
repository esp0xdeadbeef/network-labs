let
  inventory = import ./inventory-test-clients.nix;
  testClientHost = (inventory.deploymentHosts or { }).s-router-test-clients or { };
  traceId = "FS-540-HDS-010-SDS-010-SMS-045";
  endpoint =
    {
      name,
      bridge,
      tenant,
      namespaceOwner,
      address4,
      address6,
      gateway4,
      gateway6,
      dns4,
      dns6,
    }:
    {
      inherit
        bridge
        name
        namespaceOwner
        tenant
        ;
      enterprise = "mini-smt";
      family = "dual";
      gampIds = [
        traceId
        "FS-720-HDS-030-SDS-010-SMS-041"
        "FS-983-HDS-010-SDS-010-SMS-010"
      ];
      mode = "static";
      owningSubstrate = "s-router-test-clients";
      site = traceId;
      static = {
        address = address4;
        address6 = address6;
        gateway4 = gateway4;
        gateway6 = gateway6;
        prefixLength = 24;
        prefixLength6 = 64;
        dnsServers = [
          dns4
          dns6
        ];
      };
    };
in
rec {
  control_plane_model = {
    meta = {
      inherit traceId;
      source = "network-labs ${traceId} row-local s-router-test-clients endpoint CPM source";
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
        recursive-dns-nixos-client = endpoint {
          name = "recursive-dns-nixos-client";
          bridge = "dns545nr";
          tenant = "recursive-client";
          namespaceOwner = "access-recursive";
          address4 = "10.54.45.10";
          address6 = "fd42:540:45::10";
          gateway4 = "10.54.45.1";
          gateway6 = "fd42:540:45::1";
          dns4 = "10.54.45.1";
          dns6 = "fd42:540:45::1";
        };
        local-dns-nixos-client = endpoint {
          name = "local-dns-nixos-client";
          bridge = "dns545nl";
          tenant = "local-client";
          namespaceOwner = "access-local";
          address4 = "10.54.46.10";
          address6 = "fd42:540:46::10";
          gateway4 = "10.54.46.1";
          gateway6 = "fd42:540:46::1";
          dns4 = "10.54.46.1";
          dns6 = "fd42:540:46::1";
        };
        recursive-dns-clab-client = endpoint {
          name = "recursive-dns-clab-client";
          bridge = "dns545cr";
          tenant = "recursive-client";
          namespaceOwner = "access-recursive";
          address4 = "10.54.45.10";
          address6 = "fd42:540:45::10";
          gateway4 = "10.54.45.1";
          gateway6 = "fd42:540:45::1";
          dns4 = "10.54.45.1";
          dns6 = "fd42:540:45::1";
        };
        local-dns-clab-client = endpoint {
          name = "local-dns-clab-client";
          bridge = "dns545cl";
          tenant = "local-client";
          namespaceOwner = "access-local";
          address4 = "10.54.46.10";
          address6 = "fd42:540:46::10";
          gateway4 = "10.54.46.1";
          gateway6 = "fd42:540:46::1";
          dns4 = "10.54.46.1";
          dns6 = "fd42:540:46::1";
        };
      };
    };
  };
  deployment = control_plane_model.deployment;
  deploymentHosts = control_plane_model.deployment.hosts;
  realization = control_plane_model.realization;
  render = control_plane_model.render;
}
