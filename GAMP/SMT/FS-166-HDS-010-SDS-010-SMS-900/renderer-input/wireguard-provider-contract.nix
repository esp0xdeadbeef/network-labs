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
      site = "lab";
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
  id = "layer-entry-poc-wireguard-provider";
  provenance = {
    requested = {
      scope.traceId = "FS-166-HDS-010-SDS-010-SMS-900__mini-renderer-wireguard";
      target = {
        renderer = "wireguard";
        role = "renderer-output";
      };
    };
    sourceClasses = {
      userIntent.kind = "network-labs-layer-entry-poc";
      publicInventory.kind = "synthetic-public-provider-contract";
      protectedInventory.kind = "synthetic-protected-provider-contract";
    };
    controlledBaseline = "network-labs-layer-entry-poc";
  };
  provider = {
    class = "commercial-imported";
    mode = "egress-only";
    prefixAuthority = "none";
  };
  interfaces = {
    wan = "uplink0";
    lan = "lan0";
    vpn = "wg-layer-entry";
  };
  profile = {
    mode = "profile-import";
    path = "/run/network-renderer-wireguard/layer-entry-poc.conf";
    format = "wireguard";
  };
  dns.mode = "default";
  firewall = {
    mode = "dedicated-gateway";
    allowLanToVpn = true;
    denyLanToWan = true;
    denyWanToLan = true;
  };
  runtime.uuidFile = "/run/network-renderer-wireguard/layer-entry-poc.uuid";
  publicIngress = [ ];
  portForwards = [ ];
  lan = {
    ipv4.address = "10.66.90.1/24";
    ipv6.address = "fd42:66:90::1/64";
  };
  nat = {
    ipv4 = {
      enable = false;
      sourceCidrs = [ ];
    };
    ipv6 = {
      enable = false;
      sourceCidrs = [ ];
    };
  };
  services = {
    dhcp4.enable = false;
    ra.enable = false;
    healthCheck.enable = false;
  };
  control_plane_model = {
    meta = {
      traceId = "FS-166-HDS-010-SDS-010-SMS-900__mini-renderer-wireguard";
      source = "network-labs layer-entry renderer-input POC";
      scope = "WireGuard provider renderer contract plus NixOS active-lab compile shim";
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
        bridgeNetworks = { };
      };
    };
    render.hosts = {
      s-router-nixos.deploymentHost = "s-router-nixos";
      s-router-clab.deploymentHost = "s-router-clab";
      s-router-test-clients.deploymentHost = "s-router-test-clients";
    };
    data.acme.lab = {
      enterprise = "acme";
      siteName = "acme.lab";
      runtimeTargets = {
        compile-nixos = mkRuntimeTarget "s-router-nixos" "compile-nixos";
        compile-clab = mkRuntimeTarget "s-router-clab" "compile-clab";
        compile-test-client = mkRuntimeTarget "s-router-test-clients" "compile-test-client";
      };
    };
  };

  deploymentHosts = control_plane_model.deployment.hosts;
}
