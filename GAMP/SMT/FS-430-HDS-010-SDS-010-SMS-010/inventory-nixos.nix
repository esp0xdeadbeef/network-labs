{
  meta = {
    traceId = "FS-430-HDS-010-SDS-010-SMS-010";
    scope = "mini-smt-auto";
  };
  hosts = {};
  deploymentHosts = {
    s-router-nixos = {
      bridgeNetworks = {
        admin = {};
        branch = {};
        client = {};
        testnet = {
          hostAddresses = ["10.11.0.1/24"];
        };
      };
    };
  };
}
