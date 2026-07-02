{
  meta = {
    traceId = "FS-800-HDS-010-SDS-020-SMS-040";
    scope = "provider-access-default-route";
  };
  hosts = { };
  deploymentHosts = {
    s-router-nixos = {
      bridgeNetworks = {
        admin = { };
        branch = { };
        provider-handoff-a = { };
      };
    };
  };
}
