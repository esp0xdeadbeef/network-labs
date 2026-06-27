{
  meta = {
    traceId = "FS-981-HDS-010-SDS-010-SMS-060";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-981-HDS-010-SDS-010-SMS-060-archive-compatibility-boundary.md";
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
