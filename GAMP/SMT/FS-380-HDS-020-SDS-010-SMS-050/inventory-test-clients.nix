{
  meta = {
    traceId = "FS-380-HDS-020-SDS-010-SMS-050";
    renderer = "test-clients";
    scope = "row-local-smt-sit-test-client-inventory-stub";
    evidenceBoundary = "source-stub-only";
  };
  clients = { };
  deploymentHosts = {
    s-router-test-clients = {
      accessHandoff = {
        kind = "pppoe";
        server = "emulated-isp";
      };
      uplinks = {
        emulated-isp-vlan4 = {
          mode = "dhcp";
          bridge = "vlan4";
          vlan = 4;
        };
        emulated-isp-vlan5 = {
          mode = "dhcp";
          bridge = "vlan5";
          vlan = 5;
        };
      };
      hat.endpointClients = { };
    };
  };
}
