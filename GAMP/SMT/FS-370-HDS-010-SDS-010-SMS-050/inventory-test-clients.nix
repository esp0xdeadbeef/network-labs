{
  meta = {
    traceId = "FS-370-HDS-010-SDS-010-SMS-050";
    scope = "mini-smt-lane-egress";
    managedRuntimeRealization = true;
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
