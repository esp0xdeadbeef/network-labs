{
  control_plane_model = {
    meta.traceId = "FS-166-HDS-010-SDS-010-SMS-900__allow-client-to-testnet-host-isp";
    data.acme.lab = {
      siteName = "acme.lab";
      runtimeTargets = {
        edge-a = {
          placement.host = "s-router-clab";
          logicalNode = {
            enterprise = "acme";
            site = "lab";
            name = "edge-a";
          };
          role = "core";
          routingDomain = "core";
          routingMode = "static";
          containers = [ "edge-a" ];
          effectiveRuntimeRealization = {
            loopback = {
              addr4 = "10.255.90.1/32";
              addr6 = "2001:db8:90::1/128";
            };
            interfaces.edge-a-b = {
              sourceKind = "p2p";
              runtimeIfName = "eth1";
              addr4 = "192.0.2.0/31";
              addr6 = "2001:db8:9000::/127";
              backingRef.name = "edge-a-b";
              attach.bridge = "br-layer-entry";
            };
          };
        };

        edge-b = {
          placement.host = "s-router-clab";
          logicalNode = {
            enterprise = "acme";
            site = "lab";
            name = "edge-b";
          };
          role = "core";
          routingDomain = "core";
          routingMode = "static";
          containers = [ "edge-b" ];
          effectiveRuntimeRealization = {
            loopback = {
              addr4 = "10.255.90.2/32";
              addr6 = "2001:db8:90::2/128";
            };
            interfaces.edge-a-b = {
              sourceKind = "p2p";
              runtimeIfName = "eth1";
              addr4 = "192.0.2.1/31";
              addr6 = "2001:db8:9000::1/127";
              backingRef.name = "edge-a-b";
              attach.bridge = "br-layer-entry";
            };
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
}
