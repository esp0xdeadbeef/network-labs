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
in
{
  controlPlane = {
    control_plane_model = {
      meta = {
        traceId = "FS-166-HDS-010-SDS-010-SMS-900__mini-renderer-nixos-clients";
        source = "network-labs layer-entry renderer-input POC";
      };
      deployment.hosts.s-router-test-clients = {
        uplinks.management = managementVlan2;
        bridgeNetworks.client = { };
      };
      render.hosts.s-router-test-clients.deploymentHost = "s-router-test-clients";
      data.acme.site-a = {
        enterprise = "acme";
        siteName = "site-a";
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
    deploymentHosts.s-router-test-clients = {
      uplinks.management = managementVlan2;
      bridgeNetworks.client = { };
    };
  };

  rendererInventory = {
    deployment.hosts.s-router-test-clients = {
      bridgeNetworks.client = { };
      hat.endpointClients = { };
    };
  };
}
