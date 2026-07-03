let
  traceId = "FS-380-HDS-020-SDS-010-SMS-120";
  accessNode = "mini-smt-${traceId}-access-vlan2";
  clientBridge = "client";
  clientVlan = 302;
  vlan4Uplink = {
    bridge = "internet-vlan4";
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
    vlan = 4;
  };
in
{
  meta = {
    inherit traceId;
    scope = "prod-like-ipv4-vlan4-client-egress";
  };
  hosts = { };
  endpoints = {
    access-dns = {
      ipv4 = [ "10.38.120.1" ];
    };
  };
  deploymentHosts = {
    s-router-nixos = {
      bridgeNetworks = {
        ${clientBridge} = {
          mode = "vlan";
          parent = "eth0";
          vlan = clientVlan;
        };
      };
      uplinks.internet-vlan4 = vlan4Uplink;
    };
  };
  realization.nodes.${accessNode} = {
    ports.tenant-client = {
      logicalInterface = "tenant-client";
      attach = {
        kind = "bridge";
        bridge = clientBridge;
      };
      interface.name = "lan2";
    };
    services.dns = {
      forwarders = [
        "1.1.1.1"
        "9.9.9.9"
      ];
      outgoingInterfaces = [ "10.38.120.1" ];
      roles.recursion.outgoingInterfaces = [ "10.38.120.1" ];
    };
  };
}
