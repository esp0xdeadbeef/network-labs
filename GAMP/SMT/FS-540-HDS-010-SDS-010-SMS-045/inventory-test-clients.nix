{
  meta = {
    traceId = "FS-540-HDS-010-SDS-010-SMS-045";
    scope = "isolated-dual-stack-dns-client-attachments";
  };
  deploymentHosts.s-router-test-clients.bridgeNetworks = {
    dns545nr = {
      mode = "vlan";
      parent = "eth0";
      vlan = 413;
    };
    dns545nl = {
      mode = "vlan";
      parent = "eth0";
      vlan = 414;
    };
    dns545cr = {
      mode = "vlan";
      parent = "eth0";
      vlan = 415;
    };
    dns545cl = {
      mode = "vlan";
      parent = "eth0";
      vlan = 416;
    };
  };
}
