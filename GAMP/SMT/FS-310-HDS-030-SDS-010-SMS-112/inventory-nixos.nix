{
  meta = {
    traceId = "FS-310-HDS-030-SDS-010-SMS-112";
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
