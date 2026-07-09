let
  source = import ../GAMP/SMT/FS-760-HDS-040-SDS-010-SMS-010/inventory-test-clients.nix;
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
  deployment = source.deployment or { };
  baseDeploymentHosts = (deployment.hosts or { }) // (source.deploymentHosts or { });
  testClientHost = baseDeploymentHosts.s-router-test-clients or { };
  managedTestClientHost = testClientHost // {
    uplinks = (testClientHost.uplinks or { }) // {
      management = managementVlan2;
    };
  };
  deploymentHosts = baseDeploymentHosts // {
    s-router-test-clients = managedTestClientHost;
  };
in
source // {
  inherit deploymentHosts;
  deployment = deployment // {
    hosts = (deployment.hosts or { }) // deploymentHosts;
  };
  realization = (source.realization or { }) // {
    nodes = ((source.realization or { }).nodes or { });
  };
}
