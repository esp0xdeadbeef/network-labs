{
  meta = {
    traceId = "FS-420-HDS-010-SDS-010-SMS-030";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-420-HDS-010-SDS-010-SMS-030-translation-authority-containment.md";
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
