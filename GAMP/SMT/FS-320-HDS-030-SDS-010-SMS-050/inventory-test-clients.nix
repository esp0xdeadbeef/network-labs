{
  meta = {
    traceId = "FS-320-HDS-030-SDS-010-SMS-050";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-320-HDS-030-SDS-010-SMS-050-per-interface-policy-table-connected-peer-routes.md";
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
