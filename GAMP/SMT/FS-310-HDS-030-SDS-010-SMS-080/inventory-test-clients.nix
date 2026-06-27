{
  meta = {
    traceId = "FS-310-HDS-030-SDS-010-SMS-080";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-030-SDS-010-SMS-080-renderer-shell-fallback-error-propagation.md";
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
