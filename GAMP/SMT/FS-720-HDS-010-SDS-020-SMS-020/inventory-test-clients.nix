{
  meta = {
    traceId = "FS-720-HDS-010-SDS-020-SMS-020";
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
