let
  managementVlan2 = {
    bridge = "vlan2";
    ipv4 = {
      dhcp = true;
      enable = true;
      method = "dhcp";
    };
    ipv6 = {
      acceptRA = false;
      dhcp = false;
      dhcpv6PD = false;
      enable = false;
      method = "none";
    };
    mode = "vlan";
    parent = "eth0";
    vlan = 2;
  };
  mkRuntimeTarget = host: name: {
    placement.host = host;
    logicalNode = {
      enterprise = "acme";
      site = "lab";
      inherit name;
    };
    role = "access";
    containers = [
      {
        name = "default";
        container = name;
      }
    ];
    effectiveRuntimeRealization.interfaces = { };
  };
in
rec {
  control_plane_model = {
    meta.traceId = "FS-166-HDS-010-SDS-010-SMS-900__mini-renderer-nebula";
    deployment.hosts = {
      s-router-nixos = {
        uplinks.management = managementVlan2;
        bridgeNetworks = { };
      };
    };
    render.hosts = {
      s-router-nixos.deploymentHost = "s-router-nixos";
    };
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
        lab-lighthouse = (mkRuntimeTarget "s-router-nixos" "lab-lighthouse") // {
          placement.host = "s-router-nixos";
          logicalNode = {
            enterprise = "acme";
            site = "lab";
            name = "lab-lighthouse";
          };
        };
        lab-client-nebula = (mkRuntimeTarget "s-router-nixos" "lab-client-nebula") // {
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
              listenHost = "100.96.90.1";
              port = 4242;
              mtu = 1300;
            };
            groups = [ "lighthouse" ];
            relay.amRelay = true;
          };
          lab-client-nebula = {
            service = {
              name = "nebula-layer-entry";
              interface = "nebula1";
              listenHost = "100.96.90.2";
              port = 4242;
              mtu = 1300;
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

  deploymentHosts = control_plane_model.deployment.hosts;
}
