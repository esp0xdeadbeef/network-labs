#!/usr/bin/env bash
set -euo pipefail
# LAB-HAT-SCOPE: host-substrate-preparation; see HAT/emulated-isp-residential-testnet/README.md

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
hat_dir="${repo_root}/HAT/emulated-isp-residential-testnet"
# SMS-020 CMC: cpm_flake, cpm_nfm_flake, clab_renderer_flake, nixos_renderer_flake
# removed — downstream entrypoint references. Tests that need these must live in
# the downstream repo that owns the entrypoint.
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

for required in README.md intent.nix inventory-clab.nix inventory-nixos.nix; do
  if [[ ! -f "${hat_dir}/${required}" ]]; then
    echo "FAIL emulated-isp-residential-testnet: missing ${required}" >&2
    exit 1
  fi
done

if rg -n 'nat-isp|simulated-isp|east-west|spoofed|upstreamEmulation' "${hat_dir}" >&2; then
  echo "FAIL emulated-isp-residential-testnet: fixture still contains old overlay/NAT-provider naming" >&2
  exit 1
fi

HAT_DIR="${hat_dir}" nix eval --impure --expr '
  let
    root = builtins.getEnv "HAT_DIR";
    intent = import (root + "/intent.nix");
    clab = import (root + "/inventory-clab.nix");
    nixos = import (root + "/inventory-nixos.nix");
    site = intent.esp0xdeadbeef.site-a;
    clabSite = intent.esp0xdeadbeef.site-b;
    nodes = site.topology.nodes;
    clabNodes = clabSite.topology.nodes;
    relations = site.communicationContract.relations;
    clabHost = clab.deployment.hosts.s-router-clab;
    nixosHost = nixos.deployment.hosts.s-router-nixos;
    nixosClientHost = nixos.deployment.hosts.s-router-test-clients;
    siteHostManagementOk = site:
      let management = site.hostManagement or { };
      in
        (management.required or false)
        && (management.interface or null) == "management"
        && (management.purpose or null) == "hardware-management";
    clabDhcp = clabHost.hat.providerAccess.residentialDhcpRoutedTestnet;
    clabPppoe = clabHost.hat.providerAccess.residentialPppoeHostTestnet;
    nixosDhcp = nixosHost.hat.providerAccess.residentialDhcpRoutedTestnet;
    nixosPppoe = nixosHost.hat.providerAccess.residentialPppoeHostTestnet;
    clabEndpointClients = clabHost.hat.endpointClients or { };
    nixosEndpointClients = nixosClientHost.hat.endpointClients or { };
    endpointClients = nixosEndpointClients // clabEndpointClients;
    nodeHostIs = inventory: nodeName: expectedHost:
      ((inventory.realization.nodes.${nodeName} or { }).host or null) == expectedHost;
    allLogicalPlacementsMatch = inventory: siteName: namePattern: expectedHost:
      builtins.all
        (node:
          let logicalNode = node.logicalNode or { };
          in
            (logicalNode.site or null) != siteName
            || builtins.match namePattern (logicalNode.name or "") == null
            || (node.host or null) == expectedHost)
        (builtins.attrValues (inventory.realization.nodes or { }));
    accessTenantPortOk = inventory: nodeName: tenantPort: bridgeName:
      let
        node = inventory.realization.nodes.${nodeName} or { };
        port = (node.ports or { }).${tenantPort} or { };
      in
        (port.logicalInterface or null) == tenantPort
        && (port.attach.kind or null) == "bridge"
        && (port.attach.bridge or null) == bridgeName;
    requiredClientBridgeVlans = {
      admin = 301;
      branch = 305;
      client = 302;
      dmz = 304;
      hostile = 306;
      mgmt = 300;
      streaming = 311;
    };
    clientBridgeOk =
      name:
      let bridge = nixosClientHost.bridgeNetworks.${name} or { };
      in
        (bridge.mode or null) == "vlan"
        && (bridge.parent or null) == "eth0"
        && (bridge.vlan or null) == requiredClientBridgeVlans.${name};
    endpointAssignmentIs = name: assignment:
      (endpointClients.${name}.assignment or null) == assignment;
    endpointSubstrateIs = name: substrate:
      (endpointClients.${name}.owningSubstrate or null) == substrate;
    endpointDeliveryIs = name: delivery:
      (endpointClients.${name}.addressDelivery or null) == delivery;
    endpointTenantIs = name: tenant:
      (endpointClients.${name}.tenant or null) == tenant;
    endpointAddressIs = name: family: address:
      let endpoint = endpointClients.${name} or { };
      in builtins.elem address (endpoint.${family} or [ ]);
    endpointSurfaceHasPort = name: surface: protocol: port:
      let serviceSurface = ((endpointClients.${name} or { }).serviceSurfaces or { }).${surface} or { };
      in
        (serviceSurface.protocol or null) == protocol
        && builtins.elem port (serviceSurface.ports or [ ]);
    trafficTypeHasPort = name: proto: port:
      let
        matches = builtins.filter (trafficType: (trafficType.name or null) == name)
          (site.communicationContract.trafficTypes or [ ]);
        trafficType = if matches == [ ] then { match = [ ]; } else builtins.head matches;
      in
        builtins.any
          (match: (match.proto or null) == proto && builtins.elem port (match.dports or [ ]))
          (trafficType.match or [ ]);
    serviceProvidersAre = serviceName: providers:
      let
        matches = builtins.filter (service: (service.name or null) == serviceName)
          (site.communicationContract.services or [ ]);
      in
        matches != [ ] && ((builtins.head matches).providers or [ ]) == providers;
    clabEndpointRequired = name:
      (endpointClients.${name}.required or false)
      && (endpointClients.${name}.status or null) == "missing-live-evidence";
    requiredEndpointClientsPresent = host: clients:
      builtins.all
        (name: builtins.hasAttr name clients)
        ((host.hat or { }).requiredEndpointClients or [ ]);
    hasRelation = id: builtins.any (relation: (relation.id or "") == id) relations;
    tenantAttachments = nodes: nodeName:
      builtins.map
        (attachment: attachment.name or "")
        (builtins.filter
          (attachment: (attachment.kind or null) == "tenant")
          ((nodes.${nodeName} or { }).attachments or [ ]));
    shareTenantAttachment = nodes: left: right:
      builtins.any
        (tenant: builtins.elem tenant (tenantAttachments nodes right))
        (tenantAttachments nodes left);
    roleOf = nodes: nodeName: (nodes.${nodeName} or { }).role or null;
    attachmentsOf = nodes: nodeName: (nodes.${nodeName} or { }).attachments or [ ];
    uplinksOf = nodes: nodeName: (nodes.${nodeName} or { }).uplinks or { };
    accessTenantOnly = nodes: nodeName: tenant:
      roleOf nodes nodeName == "access"
      && attachmentsOf nodes nodeName == [ { kind = "tenant"; name = tenant; } ]
      && uplinksOf nodes nodeName == { };
    overlaySource = inventory: siteName: overlayName:
      ((inventory.controlPlane.sites.esp0xdeadbeef.${siteName}.overlays or { }).${overlayName} or { });
    overlayRuntimeAdapterOk = inventory: siteName: overlayName: nodeName: expectedProvider: expectedInterface: expectedService:
      let
        overlay = overlaySource inventory siteName overlayName;
        runtimeNode = (overlay.runtimeNodes or { }).${nodeName} or { };
        service = runtimeNode.service or { };
      in
        (overlay.provider or null) == expectedProvider
        && builtins.hasAttr nodeName (overlay.nodes or { })
        && service.interface == expectedInterface
        && service.name == expectedService;
    sourceHasNoCommercialVpnOverlay = inventory:
      !builtins.hasAttr "commercial-vpn" (inventory.controlPlane.sites.esp0xdeadbeef.site-a.overlays or { })
      && !builtins.hasAttr "commercial-vpn" (inventory.controlPlane.sites.esp0xdeadbeef.site-b.overlays or { });
    providerCoreOnly = nodes: nodeName: tenant: uplink:
      roleOf nodes nodeName == "core"
      && attachmentsOf nodes nodeName == [ { kind = "tenant"; name = tenant; } ]
      && builtins.attrNames (uplinksOf nodes nodeName) == [ uplink ];
    upstreamCoreOnly = nodes: nodeName: uplink:
      roleOf nodes nodeName == "core"
      && attachmentsOf nodes nodeName == [ ]
      && builtins.attrNames (uplinksOf nodes nodeName) == [ uplink ];
    coreMapsToUplink = host: siteName: coreNode: uplink:
      (host.wanGroupToUplink."esp0xdeadbeef::${siteName}::${coreNode}" or null) == uplink;
    nodeDoesNotMapToUplink = host: siteName: nodeName:
      !(host.wanGroupToUplink ? "esp0xdeadbeef::${siteName}::${nodeName}");
    stageLinkAllowed = nodes: link:
      let
        left = builtins.elemAt link 0;
        right = builtins.elemAt link 1;
        leftRole = roleOf nodes left;
        rightRole = roleOf nodes right;
        rolePairIs = a: b:
          (leftRole == a && rightRole == b) || (leftRole == b && rightRole == a);
      in
        rolePairIs "core" "upstream-selector"
        || rolePairIs "upstream-selector" "policy"
        || rolePairIs "policy" "downstream-selector"
        || rolePairIs "downstream-selector" "access"
        || (rolePairIs "access" "core" && shareTenantAttachment nodes left right);
    invalidStageLinks = nodes: links:
      builtins.filter (link: !(stageLinkAllowed nodes link)) links;
    accessCoreLinks = nodes: links:
      builtins.filter
        (link:
          let
            left = builtins.elemAt link 0;
            right = builtins.elemAt link 1;
          in
            ((roleOf nodes left) == "access" && (roleOf nodes right) == "core")
            || ((roleOf nodes left) == "core" && (roleOf nodes right) == "access"))
        links;
    syntheticInvalidStageLinks = nodes: prefix: [
      [ "${prefix}-downstream-selector" "${prefix}-core-upstream-vlan4" ]
      [ "${prefix}-downstream-selector" "${prefix}-upstream-selector" ]
      [ "${prefix}-core-upstream-vlan4" "${prefix}-policy" ]
      [ "${prefix}-access-client" "${prefix}-policy" ]
      [ "${prefix}-access-client" "${prefix}-upstream-selector" ]
      [ "${prefix}-access-client" "${prefix}-core-upstream-vlan4" ]
    ];
    require = cond: msg: if cond then true else throw msg;
  in
    require (siteHostManagementOk intent.esp0xdeadbeef.site-a)
      "site-a intent must declare required hardware management without inventory realization facts"
    && require (siteHostManagementOk intent.esp0xdeadbeef.site-b)
      "site-b intent must declare required hardware management without inventory realization facts"
    && require (nodes ? nixos-access-client)
      "missing client access node"
    && require (trafficTypeHasPort "dns" "udp" 53 && trafficTypeHasPort "dns" "tcp" 53)
      "site-a HAT source must model DNS traffic explicitly before advertising router-self resolvers"
    && require (builtins.any
      (endpoint:
        (endpoint.name or null) == "nixos-site-dns-client"
        && (endpoint.tenant or null) == "client")
      (site.ownership.endpoints or [ ]))
      "site-a HAT source must assign the DNS service provider to the client tenant"
    && require (serviceProvidersAre "hat-site-dns" [ "nixos-site-dns-client" ])
      "site-a HAT source must model hat-site-dns as a NixOS client-access DNS service"
    && require (hasRelation "allow-client-to-hat-site-dns")
      "site-a HAT source must allow modeled client DNS requests only through hat-site-dns"
    && require (hasRelation "allow-hat-site-dns-service-to-client-uplinks")
      "site-a HAT source must model DNS service recursion authority before inventory advertises router-self"
    && require (hasRelation "deny-client-dns-to-uplinks")
      "site-a HAT source must keep direct tenant public DNS blocked when router-self is advertised"
    && require (nodes ? nixos-core-testnet-routed-isp)
      "missing routed testnet ISP core node"
    && require (nodes ? nixos-core-testnet-host-isp)
      "missing host testnet ISP core node"
    && require (nodes.nixos-core-testnet-routed-isp.uplinks.testnet-routed-isp.ipv4 == [ "203.0.113.0/30" ])
      "routed testnet ISP must advertise IPv4 203.0.113.0/30"
    && require (nodes.nixos-core-testnet-routed-isp.uplinks.testnet-routed-isp.ipv6 == [ "2001:db8:113::/48" ])
      "routed testnet ISP must advertise IPv6 /48"
    && require (nodes.nixos-core-testnet-host-isp.uplinks.testnet-host-isp.ipv4 == [ "203.0.113.4/32" ])
      "host testnet ISP must advertise IPv4 203.0.113.4/32"
    && require (nodes.nixos-core-testnet-host-isp.uplinks.testnet-host-isp.ipv6 == [ "2001:db8:113:64::/64" ])
      "host testnet ISP must advertise constrained IPv6 /64"
    && require (!(site ? transport) && !(clabSite ? transport))
      "fixture intent must not turn existing HAT p2p underlay links into overlay transport"
    && require (overlayRuntimeAdapterOk nixos "site-a" "nebula-egress" "nixos-core-nebula" "nebula" "nebula1" "nebula-runtime")
      "NixOS HAT inventory must declare Nebula runtime adapter service.interface"
    && require (overlayRuntimeAdapterOk nixos "site-a" "wireguard-egress" "nixos-core-wireguard-remote-egress" "wireguard" "wg-egress" "wireguard-runtime")
      "NixOS HAT inventory must declare WireGuard egress runtime adapter service.interface"
    && require (overlayRuntimeAdapterOk nixos "site-a" "wireguard-host128" "nixos-core-wireguard-host128" "wireguard" "wg-host128" "wireguard-runtime")
      "NixOS HAT inventory must declare WireGuard host128 runtime adapter service.interface"
    && require (overlayRuntimeAdapterOk clab "site-b" "nebula-egress" "clab-core-nebula" "nebula" "nebula1" "nebula-runtime")
      "CLAB HAT inventory must declare Nebula runtime adapter service.interface"
    && require (overlayRuntimeAdapterOk clab "site-b" "wireguard-egress" "clab-core-wireguard-remote-egress" "wireguard" "wg-egress" "wireguard-runtime")
      "CLAB HAT inventory must declare WireGuard egress runtime adapter service.interface"
    && require (overlayRuntimeAdapterOk clab "site-b" "wireguard-host128" "clab-core-wireguard-host128" "wireguard" "wg-host128" "wireguard-runtime")
      "CLAB HAT inventory must declare WireGuard host128 runtime adapter service.interface"
    && require (sourceHasNoCommercialVpnOverlay nixos && sourceHasNoCommercialVpnOverlay clab)
      "HAT source must not invent a commercial-vpn overlay runtime adapter without a modeled underlay contract"
    && require (hasRelation "allow-client-to-testnet-routed-isp")
      "missing client to routed testnet ISP relation"
    && require (hasRelation "allow-client-to-testnet-host-isp")
      "missing client to host testnet ISP relation"
    && require (invalidStageLinks nodes site.topology.links == [ ])
      "site-a HAT source must reject selector-bypassing or unscoped canonical stage links"
    && require (invalidStageLinks clabNodes clabSite.topology.links == [ ])
      "site-b HAT source must reject selector-bypassing or unscoped canonical stage links"
    && require (invalidStageLinks nodes (syntheticInvalidStageLinks nodes "nixos") == syntheticInvalidStageLinks nodes "nixos")
      "site-a HAT stage-link validation must reject downstream-selector-to-core, downstream-selector-to-upstream-selector, core-to-policy, access-to-policy, selector-bypassing, and unscoped direct core/access links"
    && require (invalidStageLinks clabNodes (syntheticInvalidStageLinks clabNodes "clab") == syntheticInvalidStageLinks clabNodes "clab")
      "site-b HAT stage-link validation must reject downstream-selector-to-core, downstream-selector-to-upstream-selector, core-to-policy, access-to-policy, selector-bypassing, and unscoped direct core/access links"
    && require (builtins.any
      (endpoint:
        (endpoint.name or null) == "clab-site-dns-client"
        && (endpoint.tenant or null) == "client")
      (clabSite.ownership.endpoints or [ ]))
      "site-b HAT source must assign the DNS service provider to the client tenant"
    && require (builtins.any
      (service:
        (service.name or null) == "hat-site-dns"
        && (service.trafficType or null) == "dns"
        && (service.providers or [ ]) == [ "clab-site-dns-client" ])
      (clabSite.communicationContract.services or [ ]))
      "site-b HAT source must model hat-site-dns as a CLAB client-access DNS service"
    && require (builtins.any
      (relation: (relation.id or null) == "allow-client-to-hat-site-dns")
      (clabSite.communicationContract.relations or [ ]))
      "site-b HAT source must allow modeled client DNS requests only through hat-site-dns"
    && require (builtins.any
      (relation: (relation.id or null) == "allow-hat-site-dns-service-to-client-uplinks")
      (clabSite.communicationContract.relations or [ ]))
      "site-b HAT source must model DNS service recursion authority before inventory advertises router-self"
    && require (builtins.any
      (relation: (relation.id or null) == "deny-client-dns-to-uplinks")
      (clabSite.communicationContract.relations or [ ]))
      "site-b HAT source must keep direct tenant public DNS blocked when router-self is advertised"
    && require (accessCoreLinks nodes site.topology.links == [
      [ "nixos-provider-handoff-access-a" "nixos-core-testnet-host-isp" ]
      [ "nixos-provider-handoff-access-b" "nixos-core-testnet-routed-isp" ]
      [ "nixos-access-iot" "nixos-core-nebula" ]
      [ "nixos-access-iot" "nixos-core-wireguard-remote-egress" ]
      [ "nixos-access-iot" "nixos-core-wireguard-host128" ]
    ])
      "site-a HAT source must allow only HDS access-space/core attachment links"
    && require (accessCoreLinks clabNodes clabSite.topology.links == [
      [ "clab-provider-handoff-access-a" "clab-core-testnet-host-isp" ]
      [ "clab-provider-handoff-access-b" "clab-core-testnet-routed-isp" ]
      [ "clab-access-iot" "clab-core-nebula" ]
      [ "clab-access-iot" "clab-core-wireguard-remote-egress" ]
      [ "clab-access-iot" "clab-core-wireguard-host128" ]
    ])
      "site-b HAT source must allow only HDS access-space/core attachment links"
    && require (upstreamCoreOnly nodes "nixos-core-upstream-vlan4" "isp-a")
      "site-a VLAN4 upstream surface must be a core uplink without tenant/client attachment"
    && require (upstreamCoreOnly clabNodes "clab-core-upstream-vlan4" "isp-a")
      "site-b VLAN4 upstream surface must be a core uplink without tenant/client attachment"
    && require (accessTenantOnly nodes "nixos-access-client" "client")
      "site-a ordinary client surface must remain tenant access without uplink/core classification"
    && require (accessTenantOnly clabNodes "clab-access-client" "client")
      "site-b ordinary client surface must remain tenant access without uplink/core classification"
    && require (accessTenantOnly nodes "nixos-provider-handoff-access-a" "provider-handoff-a")
      "site-a provider handoff A must remain access-side provider distribution"
    && require (accessTenantOnly nodes "nixos-provider-handoff-access-b" "provider-handoff-b")
      "site-a provider handoff B must remain access-side provider distribution"
    && require (accessTenantOnly clabNodes "clab-provider-handoff-access-a" "provider-handoff-a")
      "site-b provider handoff A must remain access-side provider distribution"
    && require (accessTenantOnly clabNodes "clab-provider-handoff-access-b" "provider-handoff-b")
      "site-b provider handoff B must remain access-side provider distribution"
    && require (providerCoreOnly nodes "nixos-core-testnet-host-isp" "provider-handoff-a" "testnet-host-isp")
      "site-a host ISP core must carry provider handoff attachment and testnet uplink only"
    && require (providerCoreOnly nodes "nixos-core-testnet-routed-isp" "provider-handoff-b" "testnet-routed-isp")
      "site-a routed ISP core must carry provider handoff attachment and testnet uplink only"
    && require (providerCoreOnly clabNodes "clab-core-testnet-host-isp" "provider-handoff-a" "testnet-host-isp")
      "site-b host ISP core must carry provider handoff attachment and testnet uplink only"
    && require (providerCoreOnly clabNodes "clab-core-testnet-routed-isp" "provider-handoff-b" "testnet-routed-isp")
      "site-b routed ISP core must carry provider handoff attachment and testnet uplink only"
    && require (clabDhcp.harness == "s-router-clab")
      "CLAB DHCP row must name s-router-clab"
    && require (clabDhcp.distribution.mode == "network-wide" && clabDhcp.distribution.technology == "dhcp")
      "CLAB DHCP provider access must remain network-wide DHCP"
    && require (nixosDhcp.harness == "s-router-nixos")
      "NixOS DHCP row must name s-router-nixos"
    && require (nixosDhcp.distribution.mode == "network-wide" && nixosDhcp.distribution.technology == "dhcp")
      "NixOS DHCP provider access must remain network-wide DHCP"
    && require (clabPppoe.harness == "s-router-clab")
      "CLAB PPPoE row must name s-router-clab"
    && require (clabPppoe.distribution.mode == "endpoint-specific" && clabPppoe.distribution.endpoint == "clab-core-testnet-host-isp")
      "CLAB provider access must target the CLAB host-ISP core endpoint when distribution is endpoint-specific"
    && require (nixosPppoe.harness == "s-router-nixos")
      "NixOS PPPoE row must name s-router-nixos"
    && require (nixosPppoe.distribution.mode == "endpoint-specific" && nixosPppoe.distribution.endpoint == "nixos-core-testnet-host-isp")
      "NixOS provider access must target the host-ISP core endpoint when distribution is endpoint-specific"
    && require (clabDhcp.advertisedIpv4.prefix == "203.0.113.0/30")
      "CLAB routed ISP row must preserve 203.0.113.0/30"
    && require (nixosDhcp.advertisedIpv4.prefix == "203.0.113.0/30")
      "NixOS routed ISP row must preserve 203.0.113.0/30"
    && require (clabDhcp.delegatedIpv6.prefix == "2001:db8:113::/48")
      "CLAB routed ISP row must preserve IPv6 /48"
    && require (nixosDhcp.delegatedIpv6.prefix == "2001:db8:113::/48")
      "NixOS routed ISP row must preserve IPv6 /48"
    && require (clabPppoe.advertisedIpv4.prefix == "203.0.113.4/32")
      "CLAB host ISP row must preserve 203.0.113.4/32"
    && require (nixosPppoe.advertisedIpv4.prefix == "203.0.113.4/32")
      "NixOS host ISP row must preserve 203.0.113.4/32"
    && require (clabPppoe.delegatedIpv6.prefix == "2001:db8:113:64::/64")
      "CLAB host ISP row must preserve IPv6 /64"
    && require (nixosPppoe.delegatedIpv6.prefix == "2001:db8:113:64::/64")
      "NixOS host ISP row must preserve IPv6 /64"
    && require (clabDhcp.nat64.enabled == true && nixosDhcp.nat64.enabled == true)
      "routed ISP rows must carry explicit NAT64 enablement"
    && require (clabPppoe.nat64.enabled == true && nixosPppoe.nat64.enabled == true)
      "host ISP rows must carry explicit NAT64 enablement"
    && require (clabDhcp.nat64.prefix == "64:ff9b::/96" && nixosDhcp.nat64.prefix == "64:ff9b::/96")
      "routed ISP NAT64 rows must preserve 64:ff9b::/96"
    && require (clabPppoe.nat64.prefix == "64:ff9b::/96" && nixosPppoe.nat64.prefix == "64:ff9b::/96")
      "host ISP NAT64 rows must preserve 64:ff9b::/96"
    && require (clabDhcp.nat64.probeTarget4 == "203.0.113.1" && nixosDhcp.nat64.probeTarget4 == "203.0.113.1")
      "routed ISP NAT64 rows must target the routed test address"
    && require (clabPppoe.nat64.probeTarget4 == "203.0.113.4" && nixosPppoe.nat64.probeTarget4 == "203.0.113.4")
      "host ISP NAT64 rows must target the host test address"
    && require (clabDhcp.nat44 == false && nixosDhcp.nat44 == false && clabPppoe.nat44 == false && nixosPppoe.nat44 == false)
      "fixture must not model NAT44 as provider identity"
    && require (clabDhcp.nat66 == false && nixosDhcp.nat66 == false && clabPppoe.nat66 == false && nixosPppoe.nat66 == false)
      "fixture must not model NAT66"
    && require (clabPppoe.l2Surface.kind == "isolated-bridge" && nixosPppoe.l2Surface.kind == "isolated-bridge")
      "PPPoE HAT surfaces must be isolated bridges"
    && require (clabPppoe.l2Surface.name == "br-c-pppoe")
      "CLAB PPPoE HAT surface must use br-c-pppoe"
    && require (nixosPppoe.l2Surface.name == "br-n-pppoe")
      "NixOS PPPoE HAT surface must use br-n-pppoe"
    && require (clabPppoe.l2Surface.name != nixosPppoe.l2Surface.name)
      "CLAB and NixOS PPPoE HAT surfaces must be split"
    && require (builtins.stringLength clabPppoe.l2Surface.name <= 15)
      "CLAB PPPoE HAT surface name must fit Linux interface limits"
    && require (builtins.stringLength nixosPppoe.l2Surface.name <= 15)
      "NixOS PPPoE HAT surface name must fit Linux interface limits"
    && require (clabPppoe.l2Surface.physical == false && nixosPppoe.l2Surface.physical == false)
      "PPPoE HAT surfaces must not be physical"
    && require (!(clabPppoe.l2Surface ? vlan) && !(nixosPppoe.l2Surface ? vlan))
      "PPPoE HAT surfaces must not be tagged VLANs"
    && require (nodeHostIs nixos "esp0xdeadbeef-site-a-nixos-core-testnet-host-isp" "s-router-nixos")
      "NixOS inventory must place site-a/nixos host-ISP core on s-router-nixos"
    && require (nodeHostIs clab "esp0xdeadbeef-site-b-clab-core-testnet-host-isp" "s-router-clab")
      "CLAB inventory must place site-b/clab host-ISP core on s-router-clab"
    && require (allLogicalPlacementsMatch nixos "site-a" "nixos-.*" "s-router-nixos")
      "NixOS inventory must place every site-a/nixos runtime node on s-router-nixos"
    && require (allLogicalPlacementsMatch nixos "site-b" "clab-.*" "s-router-clab")
      "NixOS inventory must keep every site-b/clab runtime node assigned to s-router-clab"
    && require (allLogicalPlacementsMatch clab "site-a" "nixos-.*" "s-router-nixos")
      "CLAB inventory must keep every site-a/nixos runtime node assigned to s-router-nixos"
    && require (allLogicalPlacementsMatch clab "site-b" "clab-.*" "s-router-clab")
      "CLAB inventory must place every site-b/clab runtime node on s-router-clab"
    && require (clabHost.bridgeNetworks."br-c-pppoe".isolated == true)
      "CLAB PPPoE bridge must be isolated"
    && require (nixosHost.bridgeNetworks."br-n-pppoe".isolated == true)
      "NixOS PPPoE bridge must be isolated"
    && require (nixosHost.uplinks.management.bridge == "vlan2")
      "HAT NixOS s-router-nixos must preserve vlan2 management uplink"
    && require (nixosHost.uplinks.management.mode == "vlan" && nixosHost.uplinks.management.parent == "eth0" && nixosHost.uplinks.management.vlan == 2)
      "HAT NixOS s-router-nixos management must use eth0 VLAN 2"
    && require (nixosHost.uplinks.management.ipv4.dhcp == true && nixosHost.uplinks.management.ipv4.method == "dhcp")
      "HAT NixOS s-router-nixos management must use IPv4 DHCP"
    && require (nixos.deployment.hosts.s-router-nixos.uplinks.management == nixosHost.uplinks.management)
      "HAT NixOS inventory must preserve s-router-nixos management uplink"
    && require (nixos.deployment.hosts.s-router-test-clients.uplinks.management == nixosHost.uplinks.management)
      "HAT NixOS inventory must preserve s-router-test-clients management uplink"
    && require (clabHost.uplinks.management.bridge == "vlan2")
      "HAT CLAB s-router-clab must preserve inventory-owned vlan2 management uplink"
    && require (clabHost.uplinks.management.mode == "vlan" && clabHost.uplinks.management.parent == "eth0" && clabHost.uplinks.management.vlan == 2)
      "HAT CLAB s-router-clab management must use eth0 VLAN 2"
    && require (clabHost.uplinks.management.ipv4.dhcp == true && clabHost.uplinks.management.ipv4.method == "dhcp")
      "HAT CLAB s-router-clab management must use IPv4 DHCP"
    && require (coreMapsToUplink nixosHost "site-a" "nixos-core-upstream-vlan4" "uplink-isp-a")
      "HAT NixOS VLAN4 core must map to uplink-isp-a"
    && require (coreMapsToUplink clabHost "site-b" "clab-core-upstream-vlan4" "uplink-isp-a")
      "HAT CLAB VLAN4 core must map to uplink-isp-a"
    && require (nodeDoesNotMapToUplink nixosHost "site-a" "nixos-access-client")
      "HAT NixOS ordinary client access must not map as a WAN/uplink core"
    && require (nodeDoesNotMapToUplink clabHost "site-b" "clab-access-client")
      "HAT CLAB ordinary client access must not map as a WAN/uplink core"
    && require (nodeDoesNotMapToUplink nixosHost "site-a" "nixos-provider-handoff-access-a")
      "HAT NixOS provider handoff access A must not map as a WAN/uplink core"
    && require (nodeDoesNotMapToUplink nixosHost "site-a" "nixos-provider-handoff-access-b")
      "HAT NixOS provider handoff access B must not map as a WAN/uplink core"
    && require (nodeDoesNotMapToUplink clabHost "site-b" "clab-provider-handoff-access-a")
      "HAT CLAB provider handoff access A must not map as a WAN/uplink core"
    && require (nodeDoesNotMapToUplink clabHost "site-b" "clab-provider-handoff-access-b")
      "HAT CLAB provider handoff access B must not map as a WAN/uplink core"
    && require (builtins.all clientBridgeOk (builtins.attrNames requiredClientBridgeVlans))
      "HAT s-router-test-clients must expose tenant bridge VLANs required by endpoint containers"
    && require (accessTenantPortOk nixos "esp0xdeadbeef-site-a-nixos-access-client" "tenant-client" "client")
      "HAT NixOS access-client must realize tenant-client on the endpoint client bridge"
    && require (accessTenantPortOk clab "esp0xdeadbeef-site-b-clab-access-client" "tenant-client" "client")
      "HAT CLAB access-client must realize tenant-client on the endpoint client bridge"
    && require (requiredEndpointClientsPresent clabHost clabEndpointClients)
      "HAT CLAB inventory required endpoint list must resolve in CLAB endpoint fixtures"
    && require (requiredEndpointClientsPresent nixosClientHost nixosEndpointClients)
      "HAT NixOS inventory required endpoint list must resolve in NixOS endpoint fixtures"
    && require ((nixos.endpoints.nixos-site-dns-client.ipv4 or [ ]) == [ "10.20.20.1" ])
      "inventory-nixos must realize the NixOS HAT DNS service endpoint on the client tenant IPv4 gateway"
    && require ((nixos.endpoints.nixos-site-dns-client.ipv6 or [ ]) == [ "fd42:dead:beef:20::1" ])
      "inventory-nixos must realize the NixOS HAT DNS service endpoint on the client tenant IPv6 gateway"
    && require ((nixos.endpoints.clab-site-dns-client.ipv4 or [ ]) == [ "10.50.20.1" ])
      "inventory-nixos must carry the CLAB HAT DNS service endpoint fact for shared-source compilation"
    && require ((nixos.endpoints.clab-site-dns-client.ipv6 or [ ]) == [ "fd42:dead:feed:20::1" ])
      "inventory-nixos must carry the CLAB HAT DNS service endpoint fact for shared-source compilation"
    && require ((clab.endpoints.nixos-site-dns-client.ipv4 or [ ]) == [ "10.20.20.1" ])
      "inventory-clab must carry the NixOS HAT DNS service endpoint fact for shared-source compilation"
    && require ((clab.endpoints.nixos-site-dns-client.ipv6 or [ ]) == [ "fd42:dead:beef:20::1" ])
      "inventory-clab must carry the NixOS HAT DNS service endpoint fact for shared-source compilation"
    && require ((clab.endpoints.clab-site-dns-client.ipv4 or [ ]) == [ "10.50.20.1" ])
      "inventory-clab must realize the CLAB HAT DNS service endpoint on the client tenant IPv4 gateway"
    && require ((clab.endpoints.clab-site-dns-client.ipv6 or [ ]) == [ "fd42:dead:feed:20::1" ])
      "inventory-clab must realize the CLAB HAT DNS service endpoint on the client tenant IPv6 gateway"
    && require (!(nixosEndpointClients ? clab-client01) && !(nixosEndpointClients ? clab-client02) && !(nixosEndpointClients ? clab-emulated-sigma))
      "HAT NixOS endpoint source must not carry CLAB endpoint fixtures"
    && require (!(clabEndpointClients ? nixos-client01) && !(clabEndpointClients ? nixos-emulated-sigma) && !(clabEndpointClients ? nixos-printer01))
      "HAT CLAB endpoint source must not carry NixOS endpoint fixtures"
    && require (endpointAssignmentIs "nixos-client01" "dhcp" && endpointAssignmentIs "nixos-client02" "dhcp")
      "HAT endpoint inventory must identify DHCP-addressed client fixtures"
    && require (endpointSubstrateIs "nixos-client01" "nixos" && endpointSubstrateIs "nixos-client02" "nixos")
      "HAT NixOS DHCP endpoint records must declare NixOS owning substrate"
    && require (serviceProvidersAre "hat-printer-ipp" [ "nixos-printer01" ])
      "HAT intent must model the printer IPP provider"
    && require (serviceProvidersAre "hat-printer-admin" [ "nixos-printer01" ])
      "HAT intent must model the printer administration provider"
    && require (serviceProvidersAre "hat-receiver-control" [ "nixos-receiver01" ])
      "HAT intent must model the receiver control provider"
    && require (serviceProvidersAre "hat-receiver-discovery" [ "nixos-receiver01" ])
      "HAT intent must model the receiver discovery provider"
    && require (trafficTypeHasPort "ipp" "tcp" 631 && trafficTypeHasPort "printer-admin" "tcp" 80)
      "HAT intent must model printer traffic types"
    && require (trafficTypeHasPort "cast-control" "tcp" 8008 && trafficTypeHasPort "cast-control" "tcp" 8009)
      "HAT intent must model receiver control traffic type"
    && require (trafficTypeHasPort "cast-discovery" "udp" 5353 && trafficTypeHasPort "cast-discovery" "udp" 1900)
      "HAT intent must model receiver discovery traffic type"
    && require (endpointAssignmentIs "nixos-printer01" "static-ipv4-or-ipv6-client")
      "HAT endpoint inventory must identify printer shared-service fixture"
    && require (endpointSubstrateIs "nixos-printer01" "nixos" && endpointDeliveryIs "nixos-printer01" "endpoint-configured")
      "HAT printer static fixture must declare NixOS substrate and endpoint-configured delivery"
    && require (endpointAddressIs "nixos-printer01" "ipv4" "10.20.20.60/24")
      "HAT endpoint inventory must carry printer static IPv4"
    && require (endpointAddressIs "nixos-printer01" "ipv6" "fd42:dead:beef:20::60/64")
      "HAT endpoint inventory must carry printer static IPv6"
    && require (endpointSurfaceHasPort "nixos-printer01" "ipp" "tcp" 631)
      "HAT printer fixture must expose IPP service surface"
    && require (endpointSurfaceHasPort "nixos-printer01" "admin" "tcp" 80)
      "HAT printer fixture must expose admin service surface"
    && require (endpointAssignmentIs "nixos-receiver01" "static-ipv4-or-ipv6-client")
      "HAT endpoint inventory must identify receiver shared-service fixture"
    && require (endpointSubstrateIs "nixos-receiver01" "nixos" && endpointDeliveryIs "nixos-receiver01" "endpoint-configured")
      "HAT receiver static fixture must declare NixOS substrate and endpoint-configured delivery"
    && require (endpointAddressIs "nixos-receiver01" "ipv4" "10.20.20.70/24")
      "HAT endpoint inventory must carry receiver static IPv4"
    && require (endpointAddressIs "nixos-receiver01" "ipv6" "fd42:dead:beef:20::70/64")
      "HAT endpoint inventory must carry receiver static IPv6"
    && require (endpointSurfaceHasPort "nixos-receiver01" "control" "tcp" 8008 && endpointSurfaceHasPort "nixos-receiver01" "control" "tcp" 8009)
      "HAT receiver fixture must expose controller service surface"
    && require (endpointSurfaceHasPort "nixos-receiver01" "discovery" "udp" 5353 && endpointSurfaceHasPort "nixos-receiver01" "discovery" "udp" 1900)
      "HAT receiver fixture must expose discovery service surface"
    && require (endpointAssignmentIs "nixos-branch-node01" "static-ipv4-or-ipv6-client")
      "HAT endpoint inventory must identify branch static-address client fixture"
    && require (endpointSubstrateIs "nixos-branch-node01" "nixos" && endpointDeliveryIs "nixos-branch-node01" "endpoint-configured")
      "HAT branch static fixture must declare NixOS substrate and endpoint-configured delivery"
    && require (endpointAddressIs "nixos-branch-node01" "ipv4" "10.60.10.10/24")
      "HAT endpoint inventory must carry branch static IPv4"
    && require (endpointAddressIs "nixos-branch-node01" "ipv6" "fd42:dead:feed:10::10/64")
      "HAT endpoint inventory must carry branch static IPv6"
    && require (endpointAssignmentIs "nixos-streaming-test" "static-ipv4-or-ipv6-client")
      "HAT endpoint inventory must identify streaming static-address client fixture"
    && require (endpointSubstrateIs "nixos-streaming-test" "nixos" && endpointDeliveryIs "nixos-streaming-test" "endpoint-configured")
      "HAT streaming static fixture must declare NixOS substrate and endpoint-configured delivery"
    && require (endpointAddressIs "nixos-streaming-test" "ipv4" "10.20.50.10/24")
      "HAT endpoint inventory must carry streaming static IPv4"
    && require (endpointAddressIs "nixos-streaming-test" "ipv6" "fd42:dead:beef:50::10/64")
      "HAT endpoint inventory must carry streaming static IPv6"
    && require (endpointAssignmentIs "nixos-emulated-sigma" "static-ipv4-or-ipv6-client")
      "HAT endpoint inventory must identify nixos-emulated-sigma static-address client fixture"
    && require (endpointSubstrateIs "nixos-emulated-sigma" "nixos" && endpointDeliveryIs "nixos-emulated-sigma" "endpoint-configured")
      "HAT nixos-emulated-sigma static fixture must declare NixOS substrate and endpoint-configured delivery"
    && require (endpointAddressIs "nixos-emulated-sigma" "ipv4" "10.20.10.50/24")
      "HAT endpoint inventory must carry nixos-emulated-sigma static IPv4"
    && require (endpointAddressIs "nixos-emulated-sigma" "ipv6" "fd42:dead:beef:10::50/64")
      "HAT endpoint inventory must carry nixos-emulated-sigma static IPv6"
    && require (endpointAssignmentIs "clab-emulated-sigma" "static-ipv4-or-ipv6-client")
      "HAT endpoint inventory must identify clab-emulated-sigma static-address client fixture"
    && require (endpointSubstrateIs "clab-emulated-sigma" "clab" && endpointDeliveryIs "clab-emulated-sigma" "endpoint-configured")
      "HAT clab-emulated-sigma static fixture must declare CLAB substrate and endpoint-configured delivery"
    && require (endpointAddressIs "clab-emulated-sigma" "ipv4" "10.50.10.50/24")
      "HAT endpoint inventory must carry clab-emulated-sigma static IPv4"
    && require (endpointAddressIs "clab-emulated-sigma" "ipv6" "fd42:dead:feed:10::50/64")
      "HAT endpoint inventory must carry clab-emulated-sigma static IPv6"
    && require (clabEndpointRequired "clab-emulated-sigma")
      "HAT endpoint inventory must require clab-emulated-sigma evidence"
    && require (endpointTenantIs "clab-client01" "client" && endpointSubstrateIs "clab-client01" "clab" && clabEndpointRequired "clab-client01")
      "HAT endpoint inventory must require clab-client01 evidence"
    && require (endpointTenantIs "clab-client02" "client" && endpointSubstrateIs "clab-client02" "clab" && clabEndpointRequired "clab-client02")
      "HAT endpoint inventory must require clab-client02 evidence"
    && require (!(clabHost.bridgeNetworks ? vlan2))
      "HAT CLAB fixture must not define vlan2 as a fixture bridge"
    && require (!(clabHost.uplinks.uplink-testnet-routed-isp ? mode))
      "CLAB routed testnet ISP must not use renderer NAT mode"
    && require (!(clabHost.uplinks.uplink-testnet-host-isp ? mode))
      "CLAB host testnet ISP must not use renderer NAT mode"
    && require (!(nixosHost.uplinks.uplink-testnet-routed-isp ? mode))
      "NixOS routed testnet ISP must not use renderer NAT mode"
    && require (!(nixosHost.uplinks.uplink-testnet-host-isp ? mode))
      "NixOS host testnet ISP must not use renderer NAT mode"
    && require ((nixosHost.uplinks.uplink-isp-a.bridge or null) == "br-uplink0")
      "NixOS HAT core internet uplink must use br-uplink0"
    && require ((nixosHost.uplinks.uplink-isp-a.mode or null) == "vlan")
      "NixOS HAT core internet uplink must be a controlled VLAN surface"
    && require ((nixosHost.uplinks.uplink-isp-a.vlan or null) == 4)
      "NixOS HAT core internet uplink must use VLAN 4"
    && require ((nixosHost.uplinks.uplink-isp-a.ipv4.method or null) == "dhcp")
      "NixOS HAT core internet uplink must use DHCPv4"
    && require (!(clabHost.uplinks.uplink-testnet-routed-isp ? vlan) && !(nixosHost.uplinks.uplink-testnet-routed-isp ? vlan))
      "routed testnet ISP uplinks must not be tagged VLANs"
    && require (!(clabHost.uplinks.uplink-testnet-host-isp ? vlan) && !(nixosHost.uplinks.uplink-testnet-host-isp ? vlan))
      "host testnet ISP uplinks must not be tagged VLANs"
    && require (clabHost.wanGroupToUplink."esp0xdeadbeef::site-b::clab-core-testnet-routed-isp" == "uplink-testnet-routed-isp")
      "CLAB routed core must map to routed testnet uplink"
    && require (clabHost.wanGroupToUplink."esp0xdeadbeef::site-b::clab-core-testnet-host-isp" == "uplink-testnet-host-isp")
      "CLAB host core must map to host testnet uplink"
' >/dev/null

# SMS-020 CMC: Removed downstream CPM/CLAB/NixOS renderer invocations.
#   - build_cpm() + CPM compile-and-build calls
#   - jq validation of CPM output (runtime contract surface)
#   - CLAB renderer generate-clab-config + grep validation
#   - NixOS renderer render-dry-config + jq validation
# These validations must live in the downstream repo that owns the entrypoint.
# The nix eval below keeps a pure local-data verify of inventory assembly.

nix eval --impure --expr "import ${hat_dir}/inventory-clab.nix" >/dev/null

echo "PASS hat-emulated-isp-residential-testnet"
