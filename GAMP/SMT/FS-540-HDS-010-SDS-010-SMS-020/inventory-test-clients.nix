{
  meta = {
    traceId = "FS-540-HDS-010-SDS-010-SMS-020";
    scope = "isolated-dual-stack-dns-client-attachments";
  };
  deploymentHosts.s-router-test-clients.bridgeNetworks = {
    dns540n = {
      mode = "vlan";
      parent = "eth0";
      vlan = 411;
    };
    dns540c = {
      mode = "vlan";
      parent = "eth0";
      vlan = 412;
    };
  };
}
