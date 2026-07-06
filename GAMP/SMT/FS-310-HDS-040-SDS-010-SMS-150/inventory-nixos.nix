{
  meta = {
    traceId = "FS-310-HDS-040-SDS-010-SMS-150";
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
