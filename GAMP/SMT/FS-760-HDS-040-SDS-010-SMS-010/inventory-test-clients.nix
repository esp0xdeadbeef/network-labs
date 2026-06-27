{
  meta = {
    traceId = "FS-760-HDS-040-SDS-010-SMS-010";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-760-HDS-040-SDS-010-SMS-010-receiver-denied-probe-surfaces.md";
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
