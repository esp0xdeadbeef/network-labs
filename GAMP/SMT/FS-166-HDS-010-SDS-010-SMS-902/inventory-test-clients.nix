{
  meta = {
    traceId = "FS-166-HDS-010-SDS-010-SMS-902";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-166-HDS-010-SDS-010-SMS-902-nixos-p2p-replacement.md";
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
