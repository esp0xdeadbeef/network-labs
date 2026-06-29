{
  meta = {
    traceId = "FS-770-HDS-010-SDS-020-SMS-040";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-770-HDS-010-SDS-020-SMS-040-realization-mutation-rejection.md";
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
