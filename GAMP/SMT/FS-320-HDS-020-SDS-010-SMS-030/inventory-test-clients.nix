{
  meta = {
    traceId = "FS-320-HDS-020-SDS-010-SMS-030";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-320-HDS-020-SDS-010-SMS-030-renderer-interface-audit-mapping.md";
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
