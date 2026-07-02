{
  meta = {
    traceId = "FS-570-HDS-010-SDS-010-SMS-040";
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
