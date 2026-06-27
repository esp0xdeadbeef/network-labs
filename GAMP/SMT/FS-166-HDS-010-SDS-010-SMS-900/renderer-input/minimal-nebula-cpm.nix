{
  control_plane_model = {
    meta.traceId = "FS-166-HDS-010-SDS-010-SMS-900__mini-renderer-nebula";
    data.acme.lab = {
      siteName = "acme.lab";
      domains.tenants = [
        {
          name = "lab";
          ipv4 = "10.90.0.0/24";
          ipv6 = "fd42:90::/64";
        }
      ];
      runtimeTargets = {
        lab-lighthouse = {
          placement.host = "s-router-nixos";
          logicalNode = {
            enterprise = "acme";
            site = "lab";
            name = "lab-lighthouse";
          };
        };
        lab-client-nebula = {
          placement.host = "s-router-nixos";
          logicalNode = {
            enterprise = "acme";
            site = "lab";
            name = "lab-client-nebula";
          };
        };
      };
      overlays.nebula-layer-entry = {
        type = "nebula";
        provider = "nebula";
        ipam = {
          ipv4.prefix = "100.96.90.0/24";
          ipv6.prefix = "fd42:dead:90::/64";
        };
        nodes = {
          lab-lighthouse = {
            addr4 = "100.96.90.1/24";
            addr6 = "fd42:dead:90::1/64";
          };
          lab-client-nebula = {
            addr4 = "100.96.90.2/24";
            addr6 = "fd42:dead:90::2/64";
          };
        };
        runtimeNodes = {
          lab-lighthouse = {
            service = {
              name = "nebula-layer-entry";
              interface = "nebula1";
            };
            groups = [ "lighthouse" ];
            relay.amRelay = true;
          };
          lab-client-nebula = {
            service = {
              name = "nebula-layer-entry";
              interface = "nebula1";
            };
            groups = [ "client" ];
            relay = {
              useRelays = true;
              relays = [ "lab-lighthouse" ];
            };
          };
        };
        nebula = {
          lighthouse = {
            node = "lab-lighthouse";
            endpoint = "198.51.100.90";
            endpoint6 = "2001:db8:90::90";
            port = 4242;
          };
          runtimeNodes = {
            lab-lighthouse.relay.amRelay = true;
            lab-client-nebula = {
              relay = {
                useRelays = true;
                relays = [ "lab-lighthouse" ];
              };
              unsafeRoutes = [
                {
                  route = "10.90.0.0/24";
                  via = "100.96.90.1";
                }
              ];
            };
          };
        };
      };
    };
  };
}
