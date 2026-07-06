{
  meta = {
    traceId = "FS-030-HDS-010-SDS-030-SMS-010";
    scope = "mini-smt-auto";
    renderer = "nixos";
  };
  controlPlane = {
    sites = {
      mini-smt = {
        FS-030-HDS-010-SDS-030-SMS-010 = {
          overlays = {
            east-west = {
              provider = "nebula";
              nodes = {
                overlay-core = {
                  addr4 = "100.96.30.1/32";
                  addr6 = "fd42:001e:ee::1/128";
                };
              };
            };
          };
        };
      };
    };
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
      uplinks = {
        east-west = {
          mode = "vlan";
          parent = "eth0";
          vlan = 5;
        };
        testnet = {
          mode = "vlan";
          parent = "eth0";
          vlan = 4;
        };
      };
    };
  };
}
