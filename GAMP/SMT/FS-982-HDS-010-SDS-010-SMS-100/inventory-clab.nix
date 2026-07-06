{
  meta = {
    traceId = "FS-982-HDS-010-SDS-010-SMS-100";
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
