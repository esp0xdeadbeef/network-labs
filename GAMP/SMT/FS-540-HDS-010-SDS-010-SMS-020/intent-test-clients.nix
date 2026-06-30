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
  tenantBridge = "br-mini-smt-dns-resolver-config-tenant-client";
in
rec {
  control_plane_model = {
    meta = {
      traceId = "FS-540-HDS-010-SDS-010-SMS-020__test-clients-endpoint-only";
      source = "network-labs FS-540 row-local test-client endpoint-only CPM source";
      layerEntry = {
        repo = "network-labs";
        entryBoundary = "row-local-test-client-renderer-input";
        inputTreatment = "endpoint-only-pass-through";
      };
    };
    deployment.hosts.s-router-test-clients = {
      bridgeNetworks.${tenantBridge} = { };
      uplinks.management = managementVlan2;
    };
    render.hosts.s-router-test-clients.deploymentHost = "s-router-test-clients";
    realization.nodes = { };
    data."mini-smt"."dns-resolver-config" = {
      enterprise = "mini-smt";
      siteName = "dns-resolver-config";
      runtimeTargets = { };
      endpointAssignment."dns-resolver-config-access-dns" = {
        bridge = tenantBridge;
        enterprise = "mini-smt";
        family = "dual";
        gampIds = [
          "FS-720-HDS-010-SDS-025-SMS-010"
          "FS-983"
          "FS-540-HDS-010-SDS-010-SMS-020"
        ];
        mode = "static";
        name = "access-dns";
        namespaceOwner = "dns-resolver-config-access-client";
        owningSubstrate = "s-router-test-clients";
        site = "dns-resolver-config";
        static = {
          address = "10.54.10.1";
          address6 = "fd42:540::1";
          gateway4 = "10.54.10.1";
          gateway6 = "fd42:540::1";
          prefixLength = 24;
          prefixLength6 = 64;
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
