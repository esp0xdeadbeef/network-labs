{
  meta = {
    traceId = "FS-350-HDS-010-SDS-010-SMS-060";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-350-HDS-010-SDS-010-SMS-060-s-router-prod-runtime-delegated-prefix-materialization.md";
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
