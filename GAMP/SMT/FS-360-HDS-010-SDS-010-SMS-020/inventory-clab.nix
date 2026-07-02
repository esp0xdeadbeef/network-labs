{
  meta = {
    traceId = "FS-360-HDS-010-SDS-010-SMS-020";
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
