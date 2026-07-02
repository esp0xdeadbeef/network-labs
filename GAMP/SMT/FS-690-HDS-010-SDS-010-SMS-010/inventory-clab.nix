{
  meta = {
    traceId = "FS-690-HDS-010-SDS-010-SMS-010";
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
