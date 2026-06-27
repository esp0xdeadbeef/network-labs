{
  meta = {
    traceId = "FS-720-HDS-010-SDS-050-SMS-010";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-720-HDS-010-SDS-050-SMS-010-fixture-non-authority.md";
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
