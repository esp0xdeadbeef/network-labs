{
  meta = {
    traceId = "FS-030-HDS-010-SDS-010-SMS-020";
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
