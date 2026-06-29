{
  meta = {
    traceId = "FS-650-HDS-010-SDS-010-SMS-040";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-650-HDS-010-SDS-010-SMS-040-profile-internet-colocation.md";
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
