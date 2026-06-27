{
  meta = {
    traceId = "FS-740-HDS-030-SDS-010-SMS-010";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-740-HDS-030-SDS-010-SMS-010-printer-payload-admin-surfaces.md";
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
