{
  meta = {
    traceId = "FS-030-HDS-010-SDS-030-SMS-010";
    scope = "mini-smt-auto";
    renderer = "clab";
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
    s-router-clab = {
      bridgeNetworks = {
        admin = {};
        branch = {};
        client = {};
      };
    };
  };
}
