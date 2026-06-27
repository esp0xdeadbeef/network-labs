{
  meta = {
    traceId = "FS-400-HDS-010-SDS-010-SMS-060";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-400-HDS-010-SDS-010-SMS-060-renderer-ipv6-internet-mode.md";
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
