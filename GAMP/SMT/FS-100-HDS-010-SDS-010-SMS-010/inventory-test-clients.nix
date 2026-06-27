{
  meta = {
    traceId = "FS-100-HDS-010-SDS-010-SMS-010";
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
