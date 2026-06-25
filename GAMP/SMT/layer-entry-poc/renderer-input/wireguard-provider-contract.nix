{
  id = "layer-entry-poc-wireguard-provider";
  provenance = {
    requested = {
      scope.traceId = "FS-166-HDS-010-SDS-010-SMS-900__allow-client-to-testnet-host-isp";
      target = {
        renderer = "wireguard";
        role = "renderer-output";
      };
    };
    sourceClasses = {
      userIntent.kind = "network-labs-layer-entry-poc";
      publicInventory.kind = "synthetic-public-provider-contract";
      protectedInventory.kind = "synthetic-protected-provider-contract";
    };
    controlledBaseline = "network-labs-layer-entry-poc";
  };
  provider = {
    class = "commercial-imported";
    mode = "egress-only";
    prefixAuthority = "none";
  };
  interfaces = {
    wan = "uplink0";
    lan = "lan0";
    vpn = "wg-layer-entry";
  };
  profile = {
    mode = "profile-import";
    path = "/run/network-renderer-wireguard/layer-entry-poc.conf";
    format = "wireguard";
  };
  dns.mode = "default";
  firewall = {
    mode = "dedicated-gateway";
    allowLanToVpn = true;
    denyLanToWan = true;
    denyWanToLan = true;
  };
  runtime.uuidFile = "/run/network-renderer-wireguard/layer-entry-poc.uuid";
  publicIngress = [ ];
  portForwards = [ ];
  lan = {
    ipv4.address = "10.66.90.1/24";
    ipv6.address = "fd42:66:90::1/64";
  };
  nat = {
    ipv4 = {
      enable = false;
      sourceCidrs = [ ];
    };
    ipv6 = {
      enable = false;
      sourceCidrs = [ ];
    };
  };
  services = {
    dhcp4.enable = false;
    ra.enable = false;
    healthCheck.enable = false;
  };
}
