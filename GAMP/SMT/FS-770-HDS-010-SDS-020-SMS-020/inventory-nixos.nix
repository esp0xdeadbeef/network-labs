{
  meta = {
    traceId = "FS-770-HDS-010-SDS-020-SMS-020";
    scope = "mini-smt-auto";
  };
  hosts = {};
  deploymentHosts = {
    s-router-nixos = {
      bridgeNetworks = {
        admin = {};
        branch = {};
        client = {};
      };
      uplinks = {
        internet-vlan4 = {
          bridge = "internet-vlan4";
          parent = "eth0";
          vlan = 4;
          mode = "vlan";
          ipv4 = { enable = false; };
          ipv6 = { enable = false; };
        };
      };
    };
  };
}
