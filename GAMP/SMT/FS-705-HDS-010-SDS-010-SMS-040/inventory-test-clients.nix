{
  meta = {
    traceId = "FS-705-HDS-010-SDS-010-SMS-040";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-705-HDS-010-SDS-010-SMS-040-access-client-endpoint-coverage.md";
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
