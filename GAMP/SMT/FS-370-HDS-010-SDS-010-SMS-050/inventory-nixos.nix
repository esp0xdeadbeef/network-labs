{
  meta = {
    traceId = "FS-370-HDS-010-SDS-010-SMS-050";
    scope = "mini-smt-lane-egress";
  };
  hosts = { };
  deploymentHosts = {
    s-router-nixos = {
      bridgeNetworks = {
        admin = { };
        branch = { };
        client = { };
        testnet = {
          hostAddresses = ["10.11.0.1/24"];
        };
      };
    };
  };
}
