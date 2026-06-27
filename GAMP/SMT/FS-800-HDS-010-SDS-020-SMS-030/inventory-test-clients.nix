{
  meta = {
    traceId = "FS-800-HDS-010-SDS-020-SMS-030";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-010-SDS-020-SMS-030-pppoe-pairing-and-fallback-rejection.md";
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
