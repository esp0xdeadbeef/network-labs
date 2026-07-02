{
  meta = {
    traceId = "FS-540-HDS-010-SDS-010-SMS-020";
    scope = "row-local-test-client-endpoint-source";
  };
  hosts = { };
  deploymentHosts = {
    s-router-test-clients = {
      bridgeNetworks = {
        "br-mini-smt-dns-resolver-config-tenant-client" = { };
      };
    };
  };
  realization.nodes = { };
}
