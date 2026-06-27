{
  meta = {
    traceId = "FS-700-HDS-010-SDS-020-SMS-010";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-700-HDS-010-SDS-020-SMS-010-source-file-classification.md";
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
