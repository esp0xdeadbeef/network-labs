{
  meta = {
    traceId = "FS-030-HDS-010-SDS-010-SMS-040";
    scope = "mini-smt-auto";
    renderer = "test-clients";
  };
  hosts = {};
  deploymentHosts = {
    s-router-nixos = {
      bridgeNetworks = {
        admin = {};
        branch = {};
        client = {};
      };
    };
  };
}
