{
  host,
  recursiveClientBridge,
  localClientBridge,
  recursiveClientVlan,
  localClientVlan,
}:

let
  traceId = "FS-540-HDS-010-SDS-010-SMS-045";
  prefix = "mini-smt-${traceId}";
  bridges = {
    accessRecursive = "r545-ar";
    accessLocal = "r545-al";
    downstreamPolicy = "r545-dp";
    downstreamPolicyLocal = "r545-dl";
    policyUpstream = "r545-pu";
    upstreamCore = "r545-uc";
  };
  links = {
    accessRecursive = "p2p-access-recursive-downstream-selector";
    accessLocal = "p2p-access-local-downstream-selector";
    downstreamPolicy = "p2p-downstream-selector-policy--access-access-recursive";
    downstreamPolicyLocal = "p2p-downstream-selector-policy--access-access-local";
    policyUpstream = "p2p-policy-upstream-selector--access-access-recursive--uplink-isp-primary";
    upstreamCore = "p2p-core-primary-upstream-selector";
  };
  p2pPort = link: bridge: adapterName: interfaceName: {
    inherit link;
    adapterName = "fs545-${adapterName}";
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
  uplink = name: {
    bridge = name;
    mode = "isolated";
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
  validationAuthority = {
    kind = "controlled-iterative-hierarchy";
    scope = "harness";
    inherit traceId;
    selectedUplink = "isp-primary";
    alternateUplinks = [ "overlay-secondary" ];
    provider = {
      bridge = "isp-primary";
      ipv4 = {
        address = "198.18.45.1/24";
        router = "198.18.45.1";
        clientAddress = "198.18.45.20";
        rangeStart = "198.18.45.20";
        rangeEnd = "198.18.45.99";
        leaseTime = "5m";
      };
      ipv6 = {
        address = "fd42:540:45:ff::1/64";
        router = "fd42:540:45:ff::1";
        prefix = "fd42:540:45:ff::/64";
        leaseTime = "5m";
      };
    };
    root = {
      zone = ".";
      nameServer = "root.dns-validation.test.";
      ipv4 = [ "198.18.45.53" ];
      ipv6 = [ "fd42:540:45:ff::53" ];
    };
    delegation = {
      zone = "dns-validation.test.";
      nameServer = "ns.dns-validation.test.";
      ipv4 = [ "198.18.45.54" ];
      ipv6 = [ "fd42:540:45:ff::54" ];
    };
    terminal = {
      name = "answer.dns-validation.test.";
      ipv4 = [ "198.18.45.80" ];
      ipv6 = [ "fd42:540:45:ff::80" ];
    };
    trust.mode = "insecure-controlled-root";
  };
  bridgeNetworks = {
    ${recursiveClientBridge} = {
      mode = "vlan";
      parent = "eth0";
      vlan = recursiveClientVlan;
    };
    ${localClientBridge} = {
      mode = "vlan";
      parent = "eth0";
      vlan = localClientVlan;
    };
    ${bridges.accessRecursive} = { };
    ${bridges.accessLocal} = { };
    ${bridges.downstreamPolicy} = { };
    ${bridges.downstreamPolicyLocal} = { };
    ${bridges.policyUpstream} = { };
    ${bridges.upstreamCore} = { };
  };
  deploymentHosts.${host} = {
    inherit bridgeNetworks;
    uplinks = {
      isp-primary = uplink "isp-primary";
      overlay-secondary = uplink "overlay-secondary";
    };
  };
  accessAdvertisement = tenantInterface: {
    dhcp4.${tenantInterface} = {
      dnsServers = [ "router-self" ];
      domain = "lab.";
    };
    ipv6Ra.${tenantInterface} = {
      dnssl = [ "lab." ];
      rdnss = [ "router-self" ];
      managed = false;
      otherConfig = false;
      onLink = true;
      autonomous = true;
    };
  };
in
{
  meta = {
    inherit traceId;
    scope = "dual-stack-recursive-and-local-only-dns-live-acceptance";
  };
  deployment.hosts = deploymentHosts;
  inherit deploymentHosts;

  endpoints = {
    recursive-dns = {
      ipv4 = [ "10.54.45.1" ];
      ipv6 = [ "fd42:540:45::1" ];
    };
    local-dns = {
      ipv4 = [ "10.54.46.1" ];
      ipv6 = [ "fd42:540:46::1" ];
    };
  };

  realization.nodes = {
    "${prefix}-access-recursive" = {
      inherit host;
      logicalNode = logicalNode "access-recursive";
      platform = "nixos-container";
      ports = {
        tenant-recursive-client = {
          logicalInterface = "tenant-recursive-client";
          attach = {
            kind = "bridge";
            bridge = recursiveClientBridge;
          };
          interface.name = "lan0";
        };
        transit-downstream-selector = p2pPort links.accessRecursive bridges.accessRecursive "ar" "transit0";
      };
      advertisements = accessAdvertisement "tenant-recursive-client";
      services.dns.localRecords = [
        {
          name = "shared.lab.";
          a = [ "10.54.45.53" ];
          aaaa = [ "fd42:540:45::53" ];
        }
      ];
    };
    "${prefix}-access-local" = {
      inherit host;
      logicalNode = logicalNode "access-local";
      platform = "nixos-container";
      ports = {
        tenant-local-client = {
          logicalInterface = "tenant-local-client";
          attach = {
            kind = "bridge";
            bridge = localClientBridge;
          };
          interface.name = "lan0";
        };
        transit-downstream-selector = p2pPort links.accessLocal bridges.accessLocal "al" "transit0";
      };
      advertisements = accessAdvertisement "tenant-local-client";
      services.dns = {
        localZones = [
          {
            name = "lab.";
            type = "static";
          }
        ];
        localRecords = [
          {
            name = "local.lab.";
            a = [ "10.54.46.53" ];
            aaaa = [ "fd42:540:46::53" ];
          }
        ];
      };
    };
    "${prefix}-downstream-selector" = {
      inherit host;
      logicalNode = logicalNode "downstream-selector";
      platform = "nixos-container";
      ports = {
        access-recursive = p2pPort links.accessRecursive bridges.accessRecursive "ra" "access0";
        access-local = p2pPort links.accessLocal bridges.accessLocal "la" "access1";
        policy-access-recursive = p2pPort links.downstreamPolicy bridges.downstreamPolicy "dp" "policy0";
        policy-access-local =
          p2pPort links.downstreamPolicyLocal bridges.downstreamPolicyLocal "dl"
            "policy1";
      };
    };
    "${prefix}-policy" = {
      inherit host;
      logicalNode = logicalNode "policy";
      platform = "nixos-container";
      ports = {
        downstream-access-recursive = p2pPort links.downstreamPolicy bridges.downstreamPolicy "pd" "down0";
        downstream-access-local =
          p2pPort links.downstreamPolicyLocal bridges.downstreamPolicyLocal "ld"
            "down1";
        upstream-access-recursive = p2pPort links.policyUpstream bridges.policyUpstream "pu" "up0";
      };
    };
    "${prefix}-upstream-selector" = {
      inherit host;
      logicalNode = logicalNode "upstream-selector";
      platform = "nixos-container";
      ports = {
        policy-access-recursive = p2pPort links.policyUpstream bridges.policyUpstream "up" "policy0";
        core-primary = p2pPort links.upstreamCore bridges.upstreamCore "uc" "core0";
      };
    };
    "${prefix}-core-primary" = {
      inherit host;
      logicalNode = logicalNode "core-primary";
      platform = "nixos-container";
      ports = {
        upstream-selector = p2pPort links.upstreamCore bridges.upstreamCore "cu" "transit0";
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
      services.dns.validationAuthority = validationAuthority;
    };
  };
}
