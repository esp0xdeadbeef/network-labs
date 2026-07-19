{ host
, wanBridge
, wanVlan
, dmzBridge
, dmzVlan
, containerlab ? false
,
}:
let
  traceId = "FS-230-HDS-010-SDS-010-SMS-040";
  nodeId = name: "mini-smt-${traceId}-${name}";
  logicalNode = name: {
    enterprise = "mini-smt";
    site = traceId;
    inherit name;
  };
  mkTransitPort =
    { link
    , bridge
    , adapterName
    , interfaceName
    ,
    }:
    {
      inherit link adapterName;
      attach = {
        kind = "bridge";
        inherit bridge;
      };
      interface.name = interfaceName;
    };
  mkNode = name: ports: {
    inherit host ports;
    logicalNode = logicalNode name;
    platform = "linux";
  };
  accessLink = "p2p-access-dmz-downstream-selector";
  downstreamPolicyLink = "p2p-downstream-selector-policy--access-access-dmz";
  policyUpstreamLink = "p2p-policy-upstream-selector--access-access-dmz--uplink-lab-wan";
  coreLink = "p2p-core-lab-wan-upstream-selector";
  deploymentHost = {
    bridgeNetworks = {
      f230-ad = { };
      f230-dp = { };
      f230-pu = { };
      f230-uc = { };
      ${dmzBridge} = {
        mode = "vlan";
        parent = "eth0";
        vlan = dmzVlan;
      };
    };
    uplinks.lab-wan = {
      bridge = wanBridge;
      parent = "eth0";
      vlan = wanVlan;
      mode = "vlan";
      ipv4 = {
        enable = false;
        method = "none";
        dhcp = false;
      };
      ipv6 = {
        enable = false;
        method = "none";
        acceptRA = false;
        dhcp = false;
        dhcpv6PD = false;
      };
    };
  };
in
{
  meta = {
    inherit traceId;
    scope = "isolated-protected-ipv6-public-ingress";
  };

  # Only the stable IID is public. The selected /48 remains a runtime secret.
  endpoints.nebula-lab-endpoint.ipv6 = [ "fd00:230::4242" ];

  deployment.hosts.${host} = deploymentHost;
  deploymentHosts.${host} = deploymentHost;

  realization.nodes = {
    ${nodeId "access-dmz"} = (mkNode "access-dmz" {
      tenant-lab-dmz = {
        logicalInterface = "tenant-lab-dmz";
        attach = {
          kind = "bridge";
          bridge = dmzBridge;
        };
        interface.name = "tenant0";
      };
      transit-downstream-selector = mkTransitPort {
        link = accessLink;
        bridge = "f230-ad";
        adapterName = "f230-access-ds";
        interfaceName = "transit";
      };
    }) // {
      advertisements = {
        dhcp4.tenant-lab-dmz.enabled = false;
        ipv6Ra.tenant-lab-dmz.enabled = false;
      };
    };

    ${nodeId "downstream-selector"} = mkNode "downstream-selector" {
      access-dmz = mkTransitPort {
        link = accessLink;
        bridge = "f230-ad";
        adapterName = "f230-ds-access";
        interfaceName = "access";
      };
      policy-access-dmz = mkTransitPort {
        link = downstreamPolicyLink;
        bridge = "f230-dp";
        adapterName = "f230-ds-policy";
        interfaceName = "policy";
      };
    };

    ${nodeId "policy"} = mkNode "policy" {
      downstream-access-dmz = mkTransitPort {
        link = downstreamPolicyLink;
        bridge = "f230-dp";
        adapterName = "f230-policy-ds";
        interfaceName = "downstream";
      };
      upstream-access-dmz-lab-wan = mkTransitPort {
        link = policyUpstreamLink;
        bridge = "f230-pu";
        adapterName = "f230-policy-us";
        interfaceName = "upstream";
      };
    };

    ${nodeId "upstream-selector"} = mkNode "upstream-selector" {
      policy-access-dmz-lab-wan = mkTransitPort {
        link = policyUpstreamLink;
        bridge = "f230-pu";
        adapterName = "f230-us-policy";
        interfaceName = "policy";
      };
      core-lab-wan = mkTransitPort {
        link = coreLink;
        bridge = "f230-uc";
        adapterName = "f230-us-core";
        interfaceName = "core";
      };
    };

    ${nodeId "core-lab-wan"} = mkNode "core-lab-wan" {
      upstream-selector = mkTransitPort {
        link = coreLink;
        bridge = "f230-uc";
        adapterName = "f230-core-us";
        interfaceName = "upstream";
      };
      lab-wan = {
        uplink = "lab-wan";
        external = true;
        attach = {
          kind = "bridge";
          bridge = wanBridge;
        };
        interface = {
          name = "wan0";
          addr4 = "10.230.40.1/24";
          addr6 = "fd42:0230:40:1::1/64";
        };
      };
    };
  };
}
  // (if containerlab then {
  containerlab.roles = {
    access.forwarding.disable_eth0 = true;
    downstream-selector.forwarding.disable_eth0 = true;
    policy.forwarding.disable_eth0 = true;
    upstream-selector.forwarding.disable_eth0 = true;
    core.forwarding.disable_eth0 = false;
  };
} else { })
