let
  traceId = "FS-525-HDS-010-SDS-010-SMS-010";
  prefix = "mini-smt-${traceId}";
  host = "s-router-nixos";
  clientBridge = "dns525";
  bridges = {
    accessDownstream = "r525-ad";
    downstreamPolicy = "r525-dp";
    policyUpstream = "r525-pu";
    upstreamCore = "r525-uc";
  };
  links = {
    accessDownstream = "p2p-access-dns-downstream-selector";
    downstreamPolicy = "p2p-downstream-selector-policy--access-access-dns";
    policyUpstream = "p2p-policy-upstream-selector--access-access-dns--uplink-isp-primary";
    upstreamCore = "p2p-core-primary-upstream-selector";
  };
  p2pPort = link: bridge: interfaceName: {
    inherit link;
    adapterName = "adp-${traceId}-${interfaceName}";
    attach = {
      kind = "bridge";
      inherit bridge;
    };
    interface.name = interfaceName;
  };
  logicalNode = name: {
    enterprise = "mini-smt";
    site = traceId;
    inherit name;
  };
  uplink = vlan: {
    bridge = if vlan == 4 then "isp-primary" else "overlay-secondary";
    parent = "eth0";
    inherit vlan;
    mode = "vlan";
    ipv4 = {
      enable = true;
      method = "dhcp";
      dhcp = true;
    };
    ipv6 = {
      enable = true;
      method = "slaac";
      acceptRA = true;
      dhcp = false;
      dhcpv6PD = false;
    };
  };
  deploymentHosts = {
    ${host} = {
      bridgeNetworks = {
        ${clientBridge} = {
          mode = "vlan";
          parent = "eth0";
          vlan = 395;
        };
        ${bridges.accessDownstream} = { };
        ${bridges.downstreamPolicy} = { };
        ${bridges.policyUpstream} = { };
        ${bridges.upstreamCore} = { };
      };
      uplinks = {
        isp-primary = uplink 4;
        overlay-secondary = uplink 5;
      };
    };
  };
in
{
  meta = {
    inherit traceId;
    scope = "named-core-dns-dual-stack";
  };
  deployment.hosts = deploymentHosts;
  inherit deploymentHosts;

  realization.nodes = {
    "${prefix}-access-dns" = {
      inherit host;
      logicalNode = logicalNode "access-dns";
      platform = "nixos-container";
      ports = {
        tenant-client = {
          logicalInterface = "tenant-client";
          attach = {
            kind = "bridge";
            bridge = clientBridge;
          };
          interface.name = "lan0";
        };
        transit-downstream-selector = p2pPort links.accessDownstream bridges.accessDownstream "transit0";
      };
      advertisements = {
        dhcp4.tenant-client = {
          dnsServers = [ "router-self" ];
          domain = "lan.";
        };
        dhcpv6.tenant-client = {
          dnsServers = [ "router-self" ];
          domain = "lan.";
          pool = {
            start = "fd42:525::100";
            end = "fd42:525::1ff";
          };
        };
        ipv6Ra.tenant-client = {
          dnssl = [ "lan." ];
          rdnss = [ "router-self" ];
          managed = true;
          otherConfig = true;
          onLink = true;
          autonomous = false;
        };
      };
      services.dns = { };
    };
    "${prefix}-downstream-selector" = {
      inherit host;
      logicalNode = logicalNode "downstream-selector";
      platform = "nixos-container";
      ports = {
        access-dns = p2pPort links.accessDownstream bridges.accessDownstream "access0";
        policy-access-dns = p2pPort links.downstreamPolicy bridges.downstreamPolicy "policy0";
      };
    };
    "${prefix}-policy" = {
      inherit host;
      logicalNode = logicalNode "policy";
      platform = "nixos-container";
      ports = {
        downstream-access-dns = p2pPort links.downstreamPolicy bridges.downstreamPolicy "down0";
        upstream-access-dns = p2pPort links.policyUpstream bridges.policyUpstream "up0";
      };
    };
    "${prefix}-upstream-selector" = {
      inherit host;
      logicalNode = logicalNode "upstream-selector";
      platform = "nixos-container";
      ports = {
        policy-access-dns = p2pPort links.policyUpstream bridges.policyUpstream "policy0";
        core-primary = p2pPort links.upstreamCore bridges.upstreamCore "core0";
      };
    };
    "${prefix}-core-primary" = {
      inherit host;
      logicalNode = logicalNode "core-primary";
      platform = "nixos-container";
      ports = {
        upstream-selector = p2pPort links.upstreamCore bridges.upstreamCore "transit0";
        isp-primary = {
          uplink = "isp-primary";
          external = true;
          attach = {
            kind = "bridge";
            bridge = "isp-primary";
          };
          interface.name = "wan0";
        };
        overlay-secondary = {
          uplink = "overlay-secondary";
          external = true;
          attach = {
            kind = "bridge";
            bridge = "overlay-secondary";
          };
          interface.name = "wan1";
        };
      };
    };
  };
}
