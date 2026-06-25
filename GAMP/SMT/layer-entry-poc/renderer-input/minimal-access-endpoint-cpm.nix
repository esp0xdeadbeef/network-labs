{
  controlPlane = {
    control_plane_model = {
      meta = {
        traceId = "FS-166-HDS-010-SDS-010-SMS-900__allow-client-to-testnet-host-isp";
        source = "network-labs layer-entry renderer-input POC";
      };
      data.acme.site-a = {
        enterprise = "acme";
        siteName = "site-a";
        endpointAssignment.poc-client = {
          mode = "static";
          tenant = "client";
          bridge = "client";
          static = {
            address = "10.50.20.10";
            prefixLength = 24;
            gateway4 = "10.50.20.1";
          };
        };
      };
    };
  };

  rendererInventory = {
    deployment.hosts.s-router-test-clients = {
      bridgeNetworks.client = { };
      hat.endpointClients = { };
    };
  };
}
