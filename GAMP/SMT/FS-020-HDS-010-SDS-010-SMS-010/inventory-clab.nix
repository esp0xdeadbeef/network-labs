{
  meta = {
    traceId = "FS-020-HDS-010-SDS-010-SMS-010";
    renderer = "clab";
    scope = "mini-smt-auto";
  };
  hosts = {};
  deploymentHosts = {
    s-router-clab = {
      bridgeNetworks = {
        admin = {};
        branch = {};
        client = {};
      };
    };
  };
}
