{
  meta = {
    traceId = "FS-800-HDS-010-SDS-030-SMS-040";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-010-SDS-030-SMS-040-hat-script-override-rejection.md";
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
