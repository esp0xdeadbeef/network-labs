let
  traceId = "FS-166-HDS-010-SDS-010-SMS-900__active-lab-mini-runtime";
in
rec {
  control_plane_model = {
    meta = {
      inherit traceId;
      source = "network-labs active-lab mini-SMT renderer-input";
      scope = "one-container NixOS runtime materialization POC; not HAT/SAT approval";
      expectedRuntimeTargets = [ "poc-router" ];
    };

    endpoints = { };

    deployment.hosts.s-router-nixos = {
      uplinks.management = {
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
      bridgeNetworks = { };
    };

    render.hosts.s-router-nixos.deploymentHost = "s-router-nixos";

    realization.nodes = { };

    data.acme.lab = {
      enterprise = "acme";
      siteName = "acme.lab";
      runtimeTargets.poc-router = {
        placement.host = "s-router-nixos";
        logicalNode = {
          enterprise = "acme";
          site = "lab";
          name = "poc-router";
        };
        role = "access";
        provenance = {
          inherit traceId;
          miniSmt = true;
        };
        containers = [
          {
            name = "default";
            container = "poc-router";
          }
        ];
        effectiveRuntimeRealization.interfaces = { };
      };
    };
  };

  deploymentHosts = control_plane_model.deployment.hosts;
}
