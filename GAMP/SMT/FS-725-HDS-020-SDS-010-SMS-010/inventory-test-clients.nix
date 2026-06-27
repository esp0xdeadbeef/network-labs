{
  meta = {
    traceId = "FS-725-HDS-020-SDS-010-SMS-010";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-725-HDS-020-SDS-010-SMS-010-vlan2-management-integration.md";
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
