{
  meta = {
    traceId = "FS-260-HDS-010-SDS-010-SMS-080";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-260-HDS-010-SDS-010-SMS-080-nfm-forwarding-derivation-contract.md";
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
