let
  source = import ../GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/renderer-input/minimal-access-endpoint-cpm.nix;
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
  sourceHosts =
    (source.deploymentHosts or { })
    // (((source.control_plane_model or { }).deployment or { }).hosts or { });
  sourceTestClientHost = sourceHosts.s-router-test-clients or { };
  testClientHost = sourceTestClientHost // {
    uplinks = (sourceTestClientHost.uplinks or { }) // {
      management = managementVlan2;
    };
  };
in
{
  meta = {
    traceId = "FS-166-HDS-010-SDS-010-SMS-903";
    renderer = "test-clients";
    scope = "active-lab-current-selection";
  };
  clients = { };
  deploymentHosts = {
    s-router-test-clients = testClientHost;
  };
  deployment.hosts = {
    s-router-test-clients = testClientHost;
  };
}
