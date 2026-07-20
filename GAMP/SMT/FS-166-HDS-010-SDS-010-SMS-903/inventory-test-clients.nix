{
  meta = {
    traceId = "FS-166-HDS-010-SDS-010-SMS-903";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-166-HDS-010-SDS-010-SMS-903-access-endpoint-replacement.md";
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
