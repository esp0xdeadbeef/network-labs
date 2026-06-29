{
  meta = {
    traceId = "FS-320-HDS-030-SDS-010-SMS-040";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-320-HDS-030-SDS-010-SMS-040-selector-runtime-interface-relation-mapping.md";
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
