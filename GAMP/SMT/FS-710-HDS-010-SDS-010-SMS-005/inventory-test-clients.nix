{
  meta = {
    traceId = "FS-710-HDS-010-SDS-010-SMS-005";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-710-HDS-010-SDS-010-SMS-005-lab-site-role-map.md";
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
