let
  traceId = "FS-230-HDS-010-SDS-010-SMS-040";
  inventory = import ./inventory-test-clients.nix;
  testClientHost = inventory.deploymentHosts.s-router-test-clients;
  mkEndpoint = name: bridge: tenant: address: address6: gateway4: gateway6: {
    inherit
      name
      bridge
      tenant
      ;
    enterprise = "mini-smt";
    site = traceId;
    family = "dual";
    mode = "static";
    owningSubstrate = "s-router-test-clients";
    namespaceOwner = tenant;
    gampIds = [
      traceId
      "FS-720-HDS-030-SDS-010-SMS-041"
      "FS-983-HDS-010-SDS-010-SMS-010"
    ];
    static = {
      inherit
        address
        address6
        gateway4
        gateway6
        ;
      prefixLength = 24;
      prefixLength6 = 64;
    };
  };
  endpointAssignment = {
    fs230-nixos-public =
      mkEndpoint "fs230-nixos-public" "f230nwan" "external-lab-wan" "10.230.40.2" "fd42:0230:40:1::2" "10.230.40.1" "fd42:0230:40:1::1";
    fs230-nixos-service =
      (mkEndpoint "fs230-nixos-service" "f230ndmz" "lab-dmz" "10.2.30.42" "fd42:0230:40::42" "10.2.30.1" "fd42:0230:40::1")
      // {
        runtimeAddressAssignments = [
          {
            family = "ipv6";
            sourceClass = "protected";
            sourceFile = "/run/secrets/fs230-lab-dmz-ipv6-prefix";
            delegatedPrefixLength = 48;
            perTenantPrefixLength = 64;
            slot = 35;
            interfaceIdentifier = "0000:0000:0000:4242";
            prefixLength = 128;
            interfaceName = "eth0";
          }
        ];
      };
    fs230-clab-public =
      mkEndpoint "fs230-clab-public" "f230cwan" "external-lab-wan" "10.230.40.2" "fd42:0230:40:1::2" "10.230.40.1" "fd42:0230:40:1::1";
    fs230-clab-service =
      (mkEndpoint "fs230-clab-service" "f230cdmz" "lab-dmz" "10.2.30.42" "fd42:0230:40::42" "10.2.30.1" "fd42:0230:40::1")
      // {
        runtimeAddressAssignments = [
          {
            family = "ipv6";
            sourceClass = "protected";
            sourceFile = "/run/secrets/fs230-lab-dmz-ipv6-prefix";
            delegatedPrefixLength = 48;
            perTenantPrefixLength = 64;
            slot = 35;
            interfaceIdentifier = "0000:0000:0000:4242";
            prefixLength = 128;
            interfaceName = "eth0";
          }
        ];
      };
  };
in
rec {
  control_plane_model = {
    meta = {
      inherit traceId;
      source = "network-labs ${traceId} isolated public-ingress endpoints";
    };
    deployment.hosts.s-router-test-clients = testClientHost;
    render.hosts.s-router-test-clients.deploymentHost = "s-router-test-clients";
    realization.nodes = { };
    data."mini-smt"."${traceId}" = {
      enterprise = "mini-smt";
      siteName = traceId;
      runtimeTargets = { };
      inherit endpointAssignment;
    };
  };
  inherit endpointAssignment;
  deployment = control_plane_model.deployment;
  deploymentHosts = control_plane_model.deployment.hosts;
  realization = control_plane_model.realization;
  render = control_plane_model.render;
}
