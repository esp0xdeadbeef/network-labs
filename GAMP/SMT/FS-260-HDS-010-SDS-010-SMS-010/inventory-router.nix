{ host
, sourceBridge
, sourceVlan
, destinationBridge
, destinationVlan
, containerlab ? false
,
}:
let
  traceId = "FS-260-HDS-010-SDS-010-SMS-010";
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
  linkBridges = {
    f260-access-destination-ds = { };
    f260-access-source-ds = { };
    f260-ds-policy-destination = { };
    f260-ds-policy-source = { };
    f260-policy-us-source-vlan4 = { };
    f260-core-us = { };
  };
  deploymentHost = {
    bridgeNetworks = linkBridges // {
      ${sourceBridge} = {
        mode = "vlan";
        parent = "eth0";
        vlan = sourceVlan;
      };
      ${destinationBridge} = {
        mode = "vlan";
        parent = "eth0";
        vlan = destinationVlan;
      };
    };
    uplinks.internet-vlan4 = {
      bridge = "internet-vlan4";
      parent = "eth0";
      vlan = 4;
      mode = "vlan";
      ipv4 = {
        enable = false;
        method = "none";
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
  accessDestinationLink = "p2p-access-destination-downstream-selector";
  accessSourceLink = "p2p-access-source-downstream-selector";
  destinationPolicyLink = "p2p-downstream-selector-policy--access-access-destination";
  sourcePolicyLink = "p2p-downstream-selector-policy--access-access-source";
  sourceUplinkLink = "p2p-policy-upstream-selector--access-access-source--uplink-internet-vlan4";
  coreLink = "p2p-core-vlan4-upstream-selector";
in
{
  meta = {
    inherit traceId;
    scope = "isolated-policy-required-access-return";
  };

  deployment.hosts.${host} = deploymentHost;
  deploymentHosts.${host} = deploymentHost;

  realization.nodes = {
    ${nodeId "access-source"} = (mkNode "access-source" {
      tenant-source = {
        logicalInterface = "tenant-source";
        attach = {
          kind = "bridge";
          bridge = sourceBridge;
        };
        interface.name = "src-lan";
      };
      transit-downstream-selector = mkTransitPort {
        link = accessSourceLink;
        bridge = "f260-access-source-ds";
        adapterName = "f260-access-source-ds";
        interfaceName = "transit";
      };
    }) // {
      advertisements = {
        dhcp4.tenant-source.enabled = false;
        ipv6Ra.tenant-source.enabled = false;
      };
    };

    ${nodeId "access-destination"} = (mkNode "access-destination" {
      tenant-destination = {
        logicalInterface = "tenant-destination";
        attach = {
          kind = "bridge";
          bridge = destinationBridge;
        };
        interface.name = "dst-lan";
      };
      transit-downstream-selector = mkTransitPort {
        link = accessDestinationLink;
        bridge = "f260-access-destination-ds";
        adapterName = "f260-access-destination-ds";
        interfaceName = "transit";
      };
    }) // {
      advertisements = {
        dhcp4.tenant-destination.enabled = false;
        ipv6Ra.tenant-destination.enabled = false;
      };
    };

    ${nodeId "downstream-selector"} = mkNode "downstream-selector" {
      access-source = mkTransitPort {
        link = accessSourceLink;
        bridge = "f260-access-source-ds";
        adapterName = "f260-ds-access-source";
        interfaceName = "access-source";
      };
      access-destination = mkTransitPort {
        link = accessDestinationLink;
        bridge = "f260-access-destination-ds";
        adapterName = "f260-ds-access-destination";
        interfaceName = "dst-access";
      };
      policy-access-source = mkTransitPort {
        link = sourcePolicyLink;
        bridge = "f260-ds-policy-source";
        adapterName = "f260-ds-policy-source";
        interfaceName = "policy-source";
      };
      policy-access-destination = mkTransitPort {
        link = destinationPolicyLink;
        bridge = "f260-ds-policy-destination";
        adapterName = "f260-ds-policy-destination";
        interfaceName = "dst-policy";
      };
    };

    ${nodeId "policy"} = mkNode "policy" {
      downstream-access-source = mkTransitPort {
        link = sourcePolicyLink;
        bridge = "f260-ds-policy-source";
        adapterName = "f260-policy-source";
        interfaceName = "source";
      };
      downstream-access-destination = mkTransitPort {
        link = destinationPolicyLink;
        bridge = "f260-ds-policy-destination";
        adapterName = "f260-policy-destination";
        interfaceName = "destination";
      };
      upstream-access-source-internet-vlan4 = mkTransitPort {
        link = sourceUplinkLink;
        bridge = "f260-policy-us-source-vlan4";
        adapterName = "f260-policy-us";
        interfaceName = "upstream";
      };
    };

    ${nodeId "upstream-selector"} = mkNode "upstream-selector" {
      policy-access-source-internet-vlan4 = mkTransitPort {
        link = sourceUplinkLink;
        bridge = "f260-policy-us-source-vlan4";
        adapterName = "f260-us-policy";
        interfaceName = "policy";
      };
      core-internet-vlan4 = mkTransitPort {
        link = coreLink;
        bridge = "f260-core-us";
        adapterName = "f260-us-core";
        interfaceName = "core";
      };
    };

    ${nodeId "core-vlan4"} = mkNode "core-vlan4" {
      upstream-selector = mkTransitPort {
        link = coreLink;
        bridge = "f260-core-us";
        adapterName = "f260-core-us";
        interfaceName = "upstream";
      };
      internet-vlan4 = {
        uplink = "internet-vlan4";
        external = true;
        attach = {
          kind = "bridge";
          bridge = "internet-vlan4";
        };
        interface.name = "internet-vlan4";
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
