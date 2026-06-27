{
  meta = {
    traceId = "FS-166-HDS-010-SDS-010-SMS-900__mini-renderer-nixos-clients";
    renderer = "test-clients";
    scope = "active-lab-current-selection";
  };
  clients = { };
  deploymentHosts = {
    s-router-test-clients = {
      hat.endpointClients = { };
    };
  };
}
