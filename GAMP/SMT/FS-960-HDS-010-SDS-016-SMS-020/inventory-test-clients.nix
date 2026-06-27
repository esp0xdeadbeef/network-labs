{
  meta = {
    traceId = "FS-960-HDS-010-SDS-016-SMS-020";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-960-HDS-010-SDS-016-SMS-020-clab-cache-present-use.md";
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
