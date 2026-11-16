{
  meta = {
    traceId = "FS-230-HDS-010-SDS-010-SMS-060";
    canonicalSms = "canonical-gamp/GAMP/SMS/FS-230-HDS-010-SDS-010-SMS-060.md";
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
