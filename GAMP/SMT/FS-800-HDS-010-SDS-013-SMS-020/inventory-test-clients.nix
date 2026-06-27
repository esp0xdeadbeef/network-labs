{
  meta = {
    traceId = "FS-800-HDS-010-SDS-013-SMS-020";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-010-SDS-013-SMS-020-cpm-provider-handoff-fabric-egress.md";
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
