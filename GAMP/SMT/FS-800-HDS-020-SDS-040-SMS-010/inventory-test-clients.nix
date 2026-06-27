{
  meta = {
    traceId = "FS-800-HDS-020-SDS-040-SMS-010";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-020-SDS-040-SMS-010-hat-script-override-rejection.md";
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
