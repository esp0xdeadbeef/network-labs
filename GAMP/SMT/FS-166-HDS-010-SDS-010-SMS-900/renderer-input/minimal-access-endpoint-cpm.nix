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
  mkRuntimeTarget = host: name: {
    placement.host = host;
    logicalNode = {
      enterprise = "acme";
      site = "site-a";
      inherit name;
    };
    role = "access";
    containers = [
      {
        name = "default";
        container = name;
      }
    ];
    effectiveRuntimeRealization.interfaces = { };
  };
in
rec {
  control_plane_model = {
    meta = {
      traceId = "FS-166-HDS-010-SDS-010-SMS-900__mini-renderer-nixos-clients";
      source = "network-labs layer-entry renderer-input POC";
    };
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
        bridgeNetworks.client = { };
      };
    };
    render.hosts = {
      s-router-nixos.deploymentHost = "s-router-nixos";
      s-router-clab.deploymentHost = "s-router-clab";
      s-router-test-clients.deploymentHost = "s-router-test-clients";
    };
    data.acme.site-a = {
      enterprise = "acme";
      siteName = "site-a";
      runtimeTargets = {
        compile-nixos = mkRuntimeTarget "s-router-nixos" "compile-nixos";
        compile-clab = mkRuntimeTarget "s-router-clab" "compile-clab";
        compile-test-client = mkRuntimeTarget "s-router-test-clients" "compile-test-client";
      };
      endpointAssignment.poc-client = {
        mode = "static";
        name = "poc-client";
        tenant = "client";
        bridge = "client";
        static = {
          address = "10.50.20.10";
          address6 = "fd42:50:20::10";
          prefixLength = 24;
          prefixLength6 = 64;
          gateway4 = "10.50.20.1";
          gateway6 = "fd42:50:20::1";
        };
      };
    };
  };

  deploymentHosts = control_plane_model.deployment.hosts;

  controlPlane = {
    inherit control_plane_model deploymentHosts;
  };

  rendererInventory = {
    deployment.hosts.s-router-test-clients = {
      bridgeNetworks.client = { };
      hat.endpointClients = { };
    };
  };
}
