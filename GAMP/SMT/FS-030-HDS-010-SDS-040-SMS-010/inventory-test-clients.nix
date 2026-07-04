{
  meta = {
    traceId = "FS-030-HDS-010-SDS-040-SMS-010";
    scope = "mini-smt-auto";
    renderer = "test-clients";
  };
  hosts = { };
  deploymentHosts = {
    s-router-test-clients = {
      bridgeNetworks = {
        admin = { };
        branch = { };
        client = { };
      };
    };
  };
}
