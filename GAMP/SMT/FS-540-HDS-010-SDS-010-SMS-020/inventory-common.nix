{
  host,
  clientBridge,
  clientVlan,
  clab ? false,
}:

let
  traceId = "FS-540-HDS-010-SDS-010-SMS-020";
  prefix = "mini-smt-${traceId}";
  bridges = {
    accessDownstream = "r540-ad";
    downstreamPolicy = "r540-dp";
    policyUpstream = "r540-pu";
    upstreamCore = "r540-uc";
  };
  links = {
    accessDownstream = "p2p-access-dns-downstream-selector";
    downstreamPolicy = "p2p-downstream-selector-policy--access-access-dns";
    policyUpstream = "p2p-policy-upstream-selector--access-access-dns--uplink-testnet-vlan4";
    upstreamCore = "p2p-resolver-node-upstream-selector";
  };
  p2pPort = link: bridge: adapterName: interfaceName: {
    inherit link;
    adapterName = "fs540-${adapterName}";
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
  uplink = {
    bridge = "testnet-vlan4";
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
    mode = "vlan";
    parent = "eth0";
    vlan = 4;
  };
  deploymentHosts.${host} = {
    bridgeNetworks = {
      ${clientBridge} = {
        mode = "vlan";
        parent = "eth0";
        vlan = clientVlan;
      };
      ${bridges.accessDownstream} = { };
      ${bridges.downstreamPolicy} = { };
      ${bridges.policyUpstream} = { };
      ${bridges.upstreamCore} = { };
    };
    uplinks.testnet-vlan4 = uplink;
  };
  base = {
    meta = {
      inherit traceId;
      scope = "named-core-dns-dual-stack";
    };
    deployment.hosts = deploymentHosts;
    inherit deploymentHosts;
    endpoints.access-dns = {
      ipv4 = [ "10.54.10.1" ];
      ipv6 = [ "fd42:540::1" ];
    };

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
          transit-downstream-selector =
            p2pPort links.accessDownstream bridges.accessDownstream "ad"
              "transit0";
        };
        advertisements = {
          dhcp4.tenant-client = {
            dnsServers = [ "router-self" ];
            domain = "lab.";
          };
          ipv6Ra.tenant-client = {
            dnssl = [ "lab." ];
            rdnss = [ "router-self" ];
            managed = false;
            otherConfig = false;
            onLink = true;
            autonomous = true;
          };
        };
        services.dns = { };
      };
      "${prefix}-downstream-selector" = {
        inherit host;
        logicalNode = logicalNode "downstream-selector";
        platform = "nixos-container";
        ports = {
          access-dns = p2pPort links.accessDownstream bridges.accessDownstream "da" "access0";
          policy-access-dns = p2pPort links.downstreamPolicy bridges.downstreamPolicy "dp" "policy0";
        };
      };
      "${prefix}-policy" = {
        inherit host;
        logicalNode = logicalNode "policy";
        platform = "nixos-container";
        ports = {
          downstream-access-dns = p2pPort links.downstreamPolicy bridges.downstreamPolicy "pd" "down0";
          upstream-access-dns = p2pPort links.policyUpstream bridges.policyUpstream "pu" "up0";
        };
      };
      "${prefix}-upstream-selector" = {
        inherit host;
        logicalNode = logicalNode "upstream-selector";
        platform = "nixos-container";
        ports = {
          policy-access-dns = p2pPort links.policyUpstream bridges.policyUpstream "up" "policy0";
          resolver-node = p2pPort links.upstreamCore bridges.upstreamCore "ur" "core0";
        };
      };
      "${prefix}-resolver-node" = {
        inherit host;
        logicalNode = logicalNode "resolver-node";
        platform = "nixos-container";
        ports = {
          upstream-selector = p2pPort links.upstreamCore bridges.upstreamCore "ru" "transit0";
          testnet-vlan4 = {
            uplink = "testnet-vlan4";
            external = true;
            attach = {
              kind = "bridge";
              bridge = "testnet-vlan4";
            };
            interface.name = "wan0";
          };
        };
      };
    };
  };
in
base
// (
  if clab then
    {
      containerlab = {
        capabilities.labEmulation = true;
        labEmulation = {
          scope = "harness";
          requests = [
            {
              providerEmulationMode = "fake-provider";
              handoffVlan = 11;
              liveUpstreamVlan = 4;
              dhcp4 = {
                address = "10.20.0.1/24";
                router = "10.20.0.1";
                clientAddress = "10.20.0.20";
                rangeStart = "10.20.0.20";
                rangeEnd = "10.20.0.99";
                leaseTime = "5m";
                sourcePrefix = "10.20.0.0/24";
              };
              nat44 = {
                enabled = true;
                sourcePrefix = "10.20.0.0/24";
              };
            }
          ];
        };
      };
    }
  else
    { }
)
