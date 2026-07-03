let
  clientBridge = "client";
  clientVlan = 302;
in
{
  meta = {
    traceId = "FS-380-HDS-020-SDS-010-SMS-120";
    scope = "prod-like-ipv4-vlan4-client-egress-test-client";
  };
  clients = { };
  hosts = { };
  deploymentHosts = {
    s-router-test-clients = {
      bridgeNetworks = {
        ${clientBridge} = {
          mode = "vlan";
          parent = "eth0";
          vlan = clientVlan;
        };
      };
    };
  };
  realization.nodes = { };
}
