{
  meta = {
    traceId = "FS-166-HDS-010-SDS-010-SMS-900";
    renderer = "test-clients";
    scope = "row-local-smt-sit-test-client-inventory-stub";
    evidenceBoundary = "source-stub-only";
  };
  clients = { };
  deploymentHosts = {
    s-router-test-clients = {
      hat.endpointClients = { };
    };
  };
}
