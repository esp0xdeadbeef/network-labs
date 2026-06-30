{
  meta = {
    traceId = "FS-540-HDS-010-SDS-010-SMS-020";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-540-HDS-010-SDS-010-SMS-020-cpm-dns-resolver-configuration-authority.md";
    renderer = "test-clients";
    scope = "row-local-test-client-endpoint-source";
    evidenceBoundary = "endpoint-only-client-source-plus-host-substrate";
  };
  clients = { };
  deploymentHosts = {
    s-router-test-clients = {
      hat.endpointClients = { };
    };
  };
}
