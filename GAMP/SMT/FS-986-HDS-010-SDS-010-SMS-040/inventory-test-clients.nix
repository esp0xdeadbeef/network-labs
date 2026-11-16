{
  meta = {
    traceId = "FS-986-HDS-010-SDS-010-SMS-040";
    canonicalSms = "canonical-gamp/GAMP/SMS/FS-986-HDS-010-SDS-010-SMS-040.md";
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
