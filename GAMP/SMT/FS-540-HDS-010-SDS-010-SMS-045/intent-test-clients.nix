let
  inventory = import ./inventory-test-clients.nix;
  testClientHost = (inventory.deploymentHosts or { }).s-router-test-clients or { };
  traceId = "FS-540-HDS-010-SDS-010-SMS-045";
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
      endpointAssignment."prod-like-dns-client01" = {
        bridge = "dnsclient";
        enterprise = "mini-smt";
        family = "dual";
        gampIds = [
          "FS-540-HDS-010-SDS-010-SMS-045"
          "FS-720-HDS-030-SDS-010-SMS-041"
          "FS-983-HDS-010-SDS-010-SMS-010"
        ];
        mode = "static";
        name = "prod-like-dns-client01";
        namespaceOwner = "access-vlan2";
        owningSubstrate = "s-router-test-clients";
        site = traceId;
        static = {
          address = "10.54.45.10";
          address6 = "fd42:540:45::10";
          gateway4 = "10.54.45.1";
          gateway6 = "fd42:540:45::1";
          prefixLength = 24;
          prefixLength6 = 64;
          dnsServers = [ "10.54.45.1" ];
        };
        tenant = "client";
      };
      endpointAssignment."prod-like-dns-clab-client01" = {
        bridge = "dnsclab";
        enterprise = "mini-smt";
        family = "dual";
        gampIds = [
          "FS-540-HDS-010-SDS-010-SMS-045"
          "FS-720-HDS-030-SDS-010-SMS-041"
          "FS-983-HDS-010-SDS-010-SMS-010"
        ];
        mode = "static";
        name = "prod-like-dns-clab-client01";
        namespaceOwner = "access-vlan2";
        owningSubstrate = "s-router-test-clients";
        site = traceId;
        static = {
          address = "10.54.45.10";
          address6 = "fd42:540:45::10";
          gateway4 = "10.54.45.1";
          gateway6 = "fd42:540:45::1";
          prefixLength = 24;
          prefixLength6 = 64;
          dnsServers = [ "10.54.45.1" ];
        };
        tenant = "client";
      };
    };
  };
  deployment = control_plane_model.deployment;
  deploymentHosts = control_plane_model.deployment.hosts;
  realization = control_plane_model.realization;
  render = control_plane_model.render;
}
