{
  meta = {
    traceId = "FS-100-HDS-010-SDS-010-SMS-050";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-100-HDS-010-SDS-010-SMS-050-output-artifact-baseline-binding.md";
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
