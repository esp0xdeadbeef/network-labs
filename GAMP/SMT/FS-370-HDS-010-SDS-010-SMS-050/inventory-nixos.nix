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
      };
    };
  };
}
