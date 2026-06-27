{
  meta = {
    traceId = "FS-960-HDS-010-SDS-012-SMS-010";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-960-HDS-010-SDS-012-SMS-010-readiness-status-boundary.md";
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
