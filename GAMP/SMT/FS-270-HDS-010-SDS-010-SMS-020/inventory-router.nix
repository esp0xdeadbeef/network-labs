{
  host,
  sourceBridge,
  sourceVlan,
  destinationBridge,
  destinationVlan,
  containerlab ? false,
}:

let
  traceId = "FS-270-HDS-010-SDS-010-SMS-020";
  nodeId = name: "mini-smt-${traceId}-${name}";
  logicalNode = name: {
    enterprise = "mini-smt";
    site = traceId;
    inherit name;
  };
  mkTransitPort =
    {
      link,
      bridge,
      adapterName,
      interfaceName,
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
    f270-access-destination-ds = { };
    f270-access-source-ds = { };
    f270-ds-policy-destination = { };
    f270-ds-policy-source = { };
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
  };
  accessDestinationLink = "p2p-access-destination-downstream-selector";
  accessSourceLink = "p2p-access-source-downstream-selector";
  destinationPolicyLink = "p2p-downstream-selector-policy--access-access-destination";
  sourcePolicyLink = "p2p-downstream-selector-policy--access-access-source";
in
{
  meta = {
    inherit traceId;
    scope = "isolated-access-service-policy-state-owner";
  };

  deployment.hosts.${host} = deploymentHost;
  deploymentHosts.${host} = deploymentHost;

  realization.nodes = {
    ${nodeId "access-source"} =
      (mkNode "access-source" {
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
          bridge = "f270-access-source-ds";
          adapterName = "f270-access-source-ds";
          interfaceName = "transit";
        };
      })
      // {
        advertisements = {
          dhcp4.tenant-source.enabled = false;
          ipv6Ra.tenant-source.enabled = false;
        };
      };

    ${nodeId "access-destination"} =
      (mkNode "access-destination" {
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
          bridge = "f270-access-destination-ds";
          adapterName = "f270-access-destination-ds";
          interfaceName = "transit";
        };
      })
      // {
        advertisements = {
          dhcp4.tenant-destination.enabled = false;
          ipv6Ra.tenant-destination.enabled = false;
        };
      };

    ${nodeId "downstream-selector"} = mkNode "downstream-selector" {
      access-source = mkTransitPort {
        link = accessSourceLink;
        bridge = "f270-access-source-ds";
        adapterName = "f270-ds-access-source";
        interfaceName = "access-source";
      };
      access-destination = mkTransitPort {
        link = accessDestinationLink;
        bridge = "f270-access-destination-ds";
        adapterName = "f270-ds-access-destination";
        interfaceName = "dst-access";
      };
      policy-access-source = mkTransitPort {
        link = sourcePolicyLink;
        bridge = "f270-ds-policy-source";
        adapterName = "f270-ds-policy-source";
        interfaceName = "policy-source";
      };
      policy-access-destination = mkTransitPort {
        link = destinationPolicyLink;
        bridge = "f270-ds-policy-destination";
        adapterName = "f270-ds-policy-destination";
        interfaceName = "dst-policy";
      };
    };

    ${nodeId "policy"} = mkNode "policy" {
      downstream-access-source = mkTransitPort {
        link = sourcePolicyLink;
        bridge = "f270-ds-policy-source";
        adapterName = "f270-policy-source";
        interfaceName = "source";
      };
      downstream-access-destination = mkTransitPort {
        link = destinationPolicyLink;
        bridge = "f270-ds-policy-destination";
        adapterName = "f270-policy-destination";
        interfaceName = "destination";
      };
    };
  };
}
// (
  if containerlab then
    {
      containerlab.roles = {
        access.forwarding.disable_eth0 = true;
        downstream-selector.forwarding.disable_eth0 = true;
        policy.forwarding.disable_eth0 = true;
      };
    }
  else
    { }
)
