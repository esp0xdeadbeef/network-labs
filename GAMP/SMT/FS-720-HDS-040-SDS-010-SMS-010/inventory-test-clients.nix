{
  meta = {
    traceId = "FS-720-HDS-040-SDS-010-SMS-010";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-720-HDS-040-SDS-010-SMS-010-runtime-observation-boundary.md";
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
