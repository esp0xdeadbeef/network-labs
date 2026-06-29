{
  meta = {
    traceId = "FS-190-HDS-010-SDS-010-SMS-010";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-190-HDS-010-SDS-010-SMS-010-service-exposure-classification.md";
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
