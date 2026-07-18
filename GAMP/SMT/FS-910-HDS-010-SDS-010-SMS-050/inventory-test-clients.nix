{
  meta = {
    traceId = "FS-910-HDS-010-SDS-010-SMS-050";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-910-HDS-010-SDS-010-SMS-050-s-router-prod-public-address-validation-log-redaction.md";
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
