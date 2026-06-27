{
  meta = {
    traceId = "FS-940-HDS-010-SDS-020-SMS-070";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-940-HDS-010-SDS-020-SMS-070-one-pass-route-materializer.md";
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
