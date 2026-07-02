{
  meta = {
    traceId = "FS-940-HDS-010-SDS-020-SMS-040";
    scope = "mini-smt-auto";
  };
  hosts = {};
  deploymentHosts = {
    s-router-nixos = {
      bridgeNetworks = {
        admin = {};
        branch = {};
        client = {};
        testnet = {};
      };
    };
  };
}
