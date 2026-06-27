{
  meta = {
    traceId = "FS-800-HDS-010-SDS-011-SMS-010";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-010-SDS-011-SMS-010-provider-access-required-fields.md";
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
