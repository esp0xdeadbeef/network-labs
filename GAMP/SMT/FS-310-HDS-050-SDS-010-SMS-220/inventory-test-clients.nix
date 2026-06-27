{
  meta = {
    traceId = "FS-310-HDS-050-SDS-010-SMS-220";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-050-SDS-010-SMS-220-test-input-pinning.md";
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
