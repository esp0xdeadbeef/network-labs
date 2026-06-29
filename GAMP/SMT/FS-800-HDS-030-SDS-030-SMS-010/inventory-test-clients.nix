{
  meta = {
    traceId = "FS-800-HDS-030-SDS-030-SMS-010";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-030-SDS-030-SMS-010-pppoe-pairing-fallback-rejection.md";
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
