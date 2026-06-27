{
  meta = {
    traceId = "FS-350-HDS-010-SDS-010-SMS-040";
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
