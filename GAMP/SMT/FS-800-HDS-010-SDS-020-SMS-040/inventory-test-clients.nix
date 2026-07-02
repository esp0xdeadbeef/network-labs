{
  meta = {
    traceId = "FS-800-HDS-010-SDS-020-SMS-040";
    scope = "provider-access-default-route";
  };
  hosts = { };
  deploymentHosts = {
    s-router-test-clients = {
      bridgeNetworks = {
        admin = { };
        provider-handoff-a = { };
      };
    };
  };
  realization.nodes = { };
}
