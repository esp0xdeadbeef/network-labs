{
  meta = {
    traceId = "FS-030-HDS-010-SDS-030-SMS-010";
    scope = "mini-smt-auto";
    renderer = "clab";
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
