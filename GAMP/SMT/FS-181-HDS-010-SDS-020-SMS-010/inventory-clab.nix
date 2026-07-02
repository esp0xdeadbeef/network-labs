{
  meta = {
    traceId = "FS-181-HDS-010-SDS-020-SMS-010";
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
