let
  traceId = "FS-166-HDS-010-SDS-010-SMS-900__active-lab-mini-runtime-p2p";
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

  layerEntry = {
    entryBoundary = "renderer-input";
    skippedUpstreamLayers = [
      "intent-source"
      "network-compiler"
      "network-forwarding-model"
      "network-control-plane-model"
    ];
    warnings = [
      { code = "WARN_LAYER_ENTRY_SKIPS_NETWORK_LABS_INTENT_SOURCE"; }
      { code = "WARN_LAYER_ENTRY_SKIPS_NETWORK_COMPILER"; }
      { code = "WARN_LAYER_ENTRY_SKIPS_NFM"; }
      { code = "WARN_LAYER_ENTRY_SKIPS_CPM"; }
    ];
  };

  mkP2pInterface =
    {
      address4,
      address6,
      peer4,
      peer6,
      route4,
      route6,
    }:
    {
      sourceKind = "p2p";
      runtimeIfName = "eth1";
      addr4 = address4;
      addr6 = address6;
      addresses = [
        address4
        address6
      ];
      backingRef = {
        kind = "bridge";
        id = "edge-a-b";
        name = "edge-a-b";
      };
      attach.bridge = "br-layer-entry";
      routes = {
        ipv4 = [
          {
            dst = route4;
            via4 = peer4;
          }
        ];
        ipv6 = [
          {
            dst = route6;
            via6 = peer6;
          }
        ];
      };
    };
in
rec {
  control_plane_model = {
    meta = {
      inherit traceId layerEntry;
      source = "network-labs active-lab mini-SMT renderer-input";
      scope = "two-container NixOS p2p runtime materialization POC; not HAT/SAT approval";
      expectedRuntimeTargets = [
        "edge-a"
        "edge-b"
      ];
    };

    endpoints = { };

    deployment.hosts.s-router-nixos = {
      uplinks.management = managementVlan2;
      bridgeNetworks = { };
    };

    deployment.hosts.s-router-clab = {
      uplinks.management = managementVlan2;
      bridgeNetworks = { };
    };

    deployment.hosts.s-router-test-clients = {
      uplinks.management = managementVlan2;
      bridgeNetworks = { };
    };

    render.hosts.s-router-nixos.deploymentHost = "s-router-nixos";
    render.hosts.s-router-clab.deploymentHost = "s-router-clab";
    render.hosts.s-router-test-clients.deploymentHost = "s-router-test-clients";

    realization.nodes = { };

    data.acme.lab = {
      enterprise = "acme";
      siteName = "acme.lab";
      runtimeTargets = {
        edge-a = {
          placement.host = "s-router-nixos";
          logicalNode = {
            enterprise = "acme";
            site = "lab";
            name = "edge-a";
          };
          role = "core";
          routingMode = "static";
          provenance = {
            inherit traceId;
            miniSmt = true;
          };
          containers = [ "edge-a" ];
          effectiveRuntimeRealization.interfaces.edge-a-b = mkP2pInterface {
            address4 = "192.0.2.0/31";
            address6 = "2001:db8:9000::/127";
            peer4 = "192.0.2.1";
            peer6 = "2001:db8:9000::1";
            route4 = "10.20.2.0/24";
            route6 = "2001:db8:902b::/64";
          };
        };

        edge-b = {
          placement.host = "s-router-nixos";
          logicalNode = {
            enterprise = "acme";
            site = "lab";
            name = "edge-b";
          };
          role = "core";
          routingMode = "static";
          provenance = {
            inherit traceId;
            miniSmt = true;
          };
          containers = [ "edge-b" ];
          effectiveRuntimeRealization.interfaces.edge-a-b = mkP2pInterface {
            address4 = "192.0.2.1/31";
            address6 = "2001:db8:9000::1/127";
            peer4 = "192.0.2.0";
            peer6 = "2001:db8:9000::";
            route4 = "10.20.1.0/24";
            route6 = "2001:db8:902a::/64";
          };
        };
      };

      transit.adjacencies = [
        {
          name = "edge-a-b";
          link = "edge-a-b";
          kind = "p2p";
          endpoints = [
            { unit = "edge-a"; }
            { unit = "edge-b"; }
          ];
        }
      ];
    };
  };

  deploymentHosts = control_plane_model.deployment.hosts;
}
