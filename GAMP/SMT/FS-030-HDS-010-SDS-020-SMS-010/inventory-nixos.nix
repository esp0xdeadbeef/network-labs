{
  meta = {
    traceId = "FS-030-HDS-010-SDS-020-SMS-010";
    scope = "mini-smt-auto";
    renderer = "nixos";
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
