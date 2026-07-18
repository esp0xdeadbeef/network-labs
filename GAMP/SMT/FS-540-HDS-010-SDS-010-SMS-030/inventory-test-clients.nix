{
  meta = {
    traceId = "FS-540-HDS-010-SDS-010-SMS-030";
    scope = "isolated-dns-client-attachments";
  };
  deploymentHosts.s-router-test-clients.bridgeNetworks = {
    dns530nr = {
      mode = "vlan";
      parent = "eth0";
      vlan = 403;
    };
    dns530nl = {
      mode = "vlan";
      parent = "eth0";
      vlan = 404;
    };
    dns530cr = {
      mode = "vlan";
      parent = "eth0";
      vlan = 405;
    };
    dns530cl = {
      mode = "vlan";
      parent = "eth0";
      vlan = 406;
    };
  };
}
