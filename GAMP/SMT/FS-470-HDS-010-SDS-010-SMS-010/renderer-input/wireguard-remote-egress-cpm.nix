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
  runtimeTarget = {
    placement.host = "s-router-nixos";
    logicalNode = {
      enterprise = "acme";
      site = "lab";
      name = "wireguard-remote-egress";
    };
    role = "provider-egress";
    containers = [
      {
        name = "default";
        container = "wireguard-remote-egress";
      }
    ];
    effectiveRuntimeRealization.interfaces = { };
  };
  wgPeerPublicKey = "lulaH/DcSwly2+BTasbAx4hNtXuA3J5K9pXjPesXJlo=";
  wgPrivateKeyFile = "/run/secrets/wireguard-mini-provider-private-key";
in
rec {
  id = "fs470-wireguard-remote-egress-active-lab";
  control_plane_model = {
    meta = {
      traceId = "FS-470-HDS-010-SDS-010-SMS-010";
      source = "network-labs FS-470 active-lab renderer-input CPM";
      scope = "WireGuard remote-egress provider runtime materialization";
      layerEntry = {
        entryBoundary = "renderer-input";
        warnings = [
          { code = "WARN_LAYER_ENTRY_SKIPS_NETWORK_LABS_INTENT_SOURCE"; }
          { code = "WARN_LAYER_ENTRY_SKIPS_NETWORK_COMPILER"; }
          { code = "WARN_LAYER_ENTRY_SKIPS_NFM"; }
          { code = "WARN_LAYER_ENTRY_SKIPS_CPM"; }
        ];
      };
    };
    deployment.hosts = {
      s-router-nixos = {
        uplinks.management = managementVlan2;
        bridgeNetworks = { };
      };
      s-router-clab = {
        uplinks.management = managementVlan2;
        bridgeNetworks = { };
      };
      s-router-test-clients = {
        uplinks.management = managementVlan2;
        bridgeNetworks = { };
      };
    };
    render.hosts = {
      s-router-nixos.deploymentHost = "s-router-nixos";
      s-router-clab.deploymentHost = "s-router-clab";
      s-router-test-clients.deploymentHost = "s-router-test-clients";
    };
    data.acme.lab = {
      enterprise = "acme";
      siteName = "acme.lab";
      overlays.wg-remote-egress = {
        providerBootstrapDns = [ "10.47.0.1" ];
        terminateOn = [ "wireguard-remote-egress" ];
        nodes.wireguard-remote-egress = {
          addr4 = "10.47.0.2/32";
          addr6 = "fd47:470::2/128";
        };
      };
      runtimeTargets.wireguard-remote-egress = runtimeTarget;
    };
    wgInventory.wg-remote-egress = {
      interface = "wg-re-egress0";
      privateKeyFile = wgPrivateKeyFile;
      listenPort = 51820;
      peers = [
        {
          publicKey = wgPeerPublicKey;
          endpoint = "198.51.100.47:51820";
          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
          persistentKeepalive = 25;
        }
      ];
    };
    providerContracts.wireguard.wg-remote-egress = {
      id = "fs470-remote-egress";
      provider = {
        class = "commercial-imported";
        mode = "egress-only";
        prefixAuthority = "host-only-128";
      };
      interfaces = {
        wan = "uplink0";
        lan = "edge-lan0";
        vpn = "wg-re-egress0";
      };
      profile = {
        mode = "generated-peer";
        generatedPeer = {
          privateKeyFile = wgPrivateKeyFile;
          addresses = [
            "10.47.0.2/32"
            "fd47:470::2/128"
          ];
          dns = [ "10.47.0.1" ];
          mtu = 1420;
          peers = [
            {
              publicKey = wgPeerPublicKey;
              endpoint = "198.51.100.47:51820";
              allowedIPs = [
                "0.0.0.0/0"
                "::/0"
              ];
              persistentKeepalive = 25;
            }
          ];
        };
      };
      runtime = {
        generatedConfigPath = "/run/network-renderer-wireguard/fs470-generated.conf";
        uuidFile = "/run/network-renderer-wireguard/fs470.uuid";
        ownNetworkStack = true;
      };
      dns.mode = "default";
      wan = {
        ipv4.method = "disabled";
        ipv6.method = "ignore";
      };
      firewall = {
        mode = "dedicated-gateway";
        allowLanToVpn = true;
        denyLanToWan = true;
        denyWanToLan = true;
      };
      publicIngress = [ ];
      portForwards = [ ];
      lan = {
        ipv4.address = "10.147.0.1/24";
        ipv6.address = "fd47:147::1/64";
      };
      nat = {
        ipv4 = {
          enable = true;
          sourceCidrs = [ "10.147.0.0/24" ];
        };
        ipv6 = {
          enable = true;
          sourceCidrs = [ "fd47:147::/64" ];
        };
      };
      services = {
        dhcp4 = {
          enable = true;
          subnet = "10.147.0.0/24";
          pool = "10.147.0.100 - 10.147.0.180";
          gateway = "10.147.0.1";
          dns = [ "10.147.0.1" ];
          leaseFile = "/var/lib/kea/dhcp4.leases";
        };
        ra = {
          enable = true;
          prefix = "fd47:147::/64";
          rdnss = [ "fd47:147::1" ];
        };
        healthCheck.enable = false;
      };
    };
  };

  deploymentHosts = control_plane_model.deployment.hosts;
}
