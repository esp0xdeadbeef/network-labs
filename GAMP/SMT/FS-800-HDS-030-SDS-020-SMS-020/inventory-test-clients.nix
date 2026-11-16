{
  meta = {
    traceId = "FS-800-HDS-030-SDS-020-SMS-020";
    canonicalSms = "canonical-gamp/GAMP/SMS/FS-800-HDS-030-SDS-020-SMS-020.md";
    renderer = "test-clients";
    scope = "canonical-sms-source-stub";
    evidenceBoundary = "source-stub-only";
  };
  clients = { };
  deploymentHosts = {
    s-router-test-clients = {
      hat.endpointClients = { };
    };
  };
}
