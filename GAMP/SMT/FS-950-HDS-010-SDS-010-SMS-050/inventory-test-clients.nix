{
  meta = {
    traceId = "FS-950-HDS-010-SDS-010-SMS-050";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-950-HDS-010-SDS-010-SMS-050-s-router-prod-offline-latest-pin-migration-package.md";
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
