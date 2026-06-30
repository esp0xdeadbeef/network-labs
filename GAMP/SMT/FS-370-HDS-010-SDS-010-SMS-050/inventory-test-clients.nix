{
  meta = {
    traceId = "FS-370-HDS-010-SDS-010-SMS-050";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-370-HDS-010-SDS-010-SMS-050-renderer-lane-egress-binding.md";
    renderer = "test-clients";
    scope = "canonical-sms-source-stub";
    evidenceBoundary = "source-stub-only";
    managedRuntimeRealization = true;
  };
  clients = { };
  deploymentHosts = {
    s-router-test-clients = {
      hat.endpointClients = { };
    };
  };
}
