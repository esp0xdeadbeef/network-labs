{
  meta = {
    traceId = "FS-500-HDS-010-SDS-010-SMS-020";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-500-HDS-010-SDS-010-SMS-020-decision-type-preservation.md";
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
