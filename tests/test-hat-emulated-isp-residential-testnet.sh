#!/usr/bin/env bash
set -euo pipefail
# LAB-HAT-SCOPE: host-substrate-preparation; see HAT/emulated-isp-residential-testnet/README.md

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
hat_dir="${repo_root}/HAT/emulated-isp-residential-testnet"
cpm_flake="${CPM_FLAKE:-github:esp0xdeadbeef/network-control-plane-model}"
cpm_nfm_flake="${CPM_NFM_FLAKE:-}"
clab_renderer_flake="${CLAB_RENDERER_FLAKE:-github:esp0xdeadbeef/network-renderer-containerlab-linux-backend}"
nixos_renderer_flake="${NIXOS_RENDERER_FLAKE:-github:esp0xdeadbeef/network-renderer-nixos}"
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
    nodes = site.topology.nodes;
    relations = site.communicationContract.relations;
    clabHost = clab.deployment.hosts.s-router-clab;
    nixosHost = nixos.deployment.hosts.s-router-nixos;
    nixosClientHost = nixos.deployment.hosts.s-router-test-clients;
    clabDhcp = clabHost.hat.providerAccess.residentialDhcpRoutedTestnet;
    clabPppoe = clabHost.hat.providerAccess.residentialPppoeHostTestnet;
    nixosDhcp = nixosHost.hat.providerAccess.residentialDhcpRoutedTestnet;
    nixosPppoe = nixosHost.hat.providerAccess.residentialPppoeHostTestnet;
    endpointClients = nixosClientHost.hat.endpointClients or { };
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
    hasRelation = id: builtins.any (relation: (relation.id or "") == id) relations;
    require = cond: msg: if cond then true else throw msg;
  in
    require (nodes ? nixos-access-client)
      "missing client access node"
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
    && require (!(site ? transport))
      "fixture must not model an overlay transport"
    && require (hasRelation "allow-client-to-testnet-routed-isp")
      "missing client to routed testnet ISP relation"
    && require (hasRelation "allow-client-to-testnet-host-isp")
      "missing client to host testnet ISP relation"
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
    && require (builtins.all clientBridgeOk (builtins.attrNames requiredClientBridgeVlans))
      "HAT s-router-test-clients must expose tenant bridge VLANs required by endpoint containers"
    && require (accessTenantPortOk nixos "esp0xdeadbeef-site-a-nixos-access-client" "tenant-client" "client")
      "HAT NixOS access-client must realize tenant-client on the endpoint client bridge"
    && require (accessTenantPortOk clab "esp0xdeadbeef-site-b-clab-access-client" "tenant-client" "client")
      "HAT CLAB access-client must realize tenant-client on the endpoint client bridge"
    && require (endpointAssignmentIs "nixos-client01" "dhcp" && endpointAssignmentIs "nixos-client02" "dhcp")
      "HAT endpoint inventory must identify DHCP-addressed client fixtures"
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
    && require (endpointAddressIs "nixos-branch-node01" "ipv4" "10.60.10.10/24")
      "HAT endpoint inventory must carry branch static IPv4"
    && require (endpointAddressIs "nixos-branch-node01" "ipv6" "fd42:dead:feed:10::10/64")
      "HAT endpoint inventory must carry branch static IPv6"
    && require (endpointAssignmentIs "nixos-streaming-test" "static-ipv4-or-ipv6-client")
      "HAT endpoint inventory must identify streaming static-address client fixture"
    && require (endpointAddressIs "nixos-streaming-test" "ipv4" "10.20.50.10/24")
      "HAT endpoint inventory must carry streaming static IPv4"
    && require (endpointAddressIs "nixos-streaming-test" "ipv6" "fd42:dead:beef:50::10/64")
      "HAT endpoint inventory must carry streaming static IPv6"
    && require (endpointAssignmentIs "nixos-emulated-sigma" "static-ipv4-or-ipv6-client")
      "HAT endpoint inventory must identify nixos-emulated-sigma static-address client fixture"
    && require (endpointAddressIs "nixos-emulated-sigma" "ipv4" "10.20.10.50/24")
      "HAT endpoint inventory must carry nixos-emulated-sigma static IPv4"
    && require (endpointAddressIs "nixos-emulated-sigma" "ipv6" "fd42:dead:beef:10::50/64")
      "HAT endpoint inventory must carry nixos-emulated-sigma static IPv6"
    && require (endpointAssignmentIs "clab-emulated-sigma" "static-ipv4-or-ipv6-client")
      "HAT endpoint inventory must identify clab-emulated-sigma static-address client fixture"
    && require (endpointAddressIs "clab-emulated-sigma" "ipv4" "10.50.10.50/24")
      "HAT endpoint inventory must carry clab-emulated-sigma static IPv4"
    && require (endpointAddressIs "clab-emulated-sigma" "ipv6" "fd42:dead:feed:10::50/64")
      "HAT endpoint inventory must carry clab-emulated-sigma static IPv6"
    && require (clabEndpointRequired "clab-emulated-sigma")
      "HAT endpoint inventory must require clab-emulated-sigma evidence"
    && require (endpointTenantIs "clab-client01" "client" && clabEndpointRequired "clab-client01")
      "HAT endpoint inventory must require clab-client01 evidence"
    && require (endpointTenantIs "clab-client02" "client" && clabEndpointRequired "clab-client02")
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

build_cpm() {
  local renderer="$1"
  local out_dir="${tmp_dir}/${renderer}"
  local cpm_args=()
  mkdir -p "${out_dir}"
  if [[ -n "${cpm_nfm_flake}" ]]; then
    cpm_args+=(--override-input network-forwarding-model "${cpm_nfm_flake}")
  fi
  nix run "${cpm_args[@]}" "${cpm_flake}#compile-and-build-control-plane-model" -- \
    "${hat_dir}/intent.nix" \
    "${hat_dir}/inventory-${renderer}.nix" \
    "${out_dir}/control-plane.json" >/dev/null
}

build_cpm clab
build_cpm nixos

for renderer in clab nixos; do
  jq -e '
    def has_dhcp4_lease_contract($target):
      ($target.advertisements.dhcp4 | length) == 1
      and ($target.advertisements.dhcp4[0].interface == "tenant-client")
      and ($target.stateContracts.persistence.dhcp4Leases | length) == 1
      and ($target.stateContracts.persistence.dhcp4Leases[0].interface == "tenant-client")
      and ($target.stateContracts.persistence.dhcp4Leases[0].service == "dhcp4");
    def has_pppoe_client($target; $interface; $runtimeInterface):
      $target.services.pppoe.client.interface == $interface
      and $target.services.pppoe.client.runtimeInterface == $runtimeInterface
      and $target.services.pppoe.client.defaultRoute == true;
    def has_pppoe_server($target; $interface; $providerAddress; $customerAddress):
      $target.services.pppoe.server.interface == $interface
      and $target.services.pppoe.server.providerAddress == $providerAddress
      and $target.services.pppoe.server.customerAddress == $customerAddress;
    .control_plane_model.data.esp0xdeadbeef."site-a" as $site
    | .control_plane_model.data.esp0xdeadbeef."site-b" as $clabSite
    | ($site.runtimeTargets
        | has("esp0xdeadbeef-site-a-nixos-access-client")
          and has("esp0xdeadbeef-site-a-nixos-core-testnet-routed-isp")
          and has("esp0xdeadbeef-site-a-nixos-core-testnet-host-isp"))
      and has_dhcp4_lease_contract($site.runtimeTargets."esp0xdeadbeef-site-a-nixos-access-client")
      and has_dhcp4_lease_contract($clabSite.runtimeTargets."esp0xdeadbeef-site-b-clab-access-client")
      and has_pppoe_client($site.runtimeTargets."esp0xdeadbeef-site-a-nixos-core-testnet-host-isp"; "p2p-nixos-core-testnet-host-isp-nixos-provider-handoff-access-a"; "ppp0")
      and has_pppoe_client($site.runtimeTargets."esp0xdeadbeef-site-a-nixos-core-testnet-routed-isp"; "p2p-nixos-core-testnet-routed-isp-nixos-provider-handoff-access-b"; "ppp1")
      and has_pppoe_server($site.runtimeTargets."esp0xdeadbeef-site-a-nixos-provider-handoff-access-a"; "p2p-nixos-core-testnet-host-isp-nixos-provider-handoff-access-a"; "203.0.113.5"; "203.0.113.4")
      and has_pppoe_server($site.runtimeTargets."esp0xdeadbeef-site-a-nixos-provider-handoff-access-b"; "p2p-nixos-core-testnet-routed-isp-nixos-provider-handoff-access-b"; "203.0.113.1"; "203.0.113.2")
      and has_pppoe_client($clabSite.runtimeTargets."esp0xdeadbeef-site-b-clab-core-testnet-host-isp"; "p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a"; "ppp0")
      and has_pppoe_client($clabSite.runtimeTargets."esp0xdeadbeef-site-b-clab-core-testnet-routed-isp"; "p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b"; "ppp1")
      and has_pppoe_server($clabSite.runtimeTargets."esp0xdeadbeef-site-b-clab-provider-handoff-access-a"; "p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a"; "203.0.113.5"; "203.0.113.4")
      and has_pppoe_server($clabSite.runtimeTargets."esp0xdeadbeef-site-b-clab-provider-handoff-access-b"; "p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b"; "203.0.113.1"; "203.0.113.2")
      and ([
        $site.trafficPaths[]
        | select(.relationId == "allow-client-to-testnet-routed-isp")
        | .nodePath
      ] == [[
        "nixos-access-client",
        "nixos-downstream-selector",
        "nixos-policy",
        "nixos-upstream-selector",
        "nixos-core-testnet-routed-isp"
      ]])
      and ([
        $site.trafficPaths[]
        | select(.relationId == "allow-client-to-testnet-host-isp")
        | .nodePath
      ] == [[
        "nixos-access-client",
        "nixos-downstream-selector",
        "nixos-policy",
        "nixos-upstream-selector",
        "nixos-core-testnet-host-isp"
      ]])
  ' "${tmp_dir}/${renderer}/control-plane.json" >/dev/null
done

nix eval --impure --json --expr "import ${hat_dir}/inventory-clab.nix" \
  > "${tmp_dir}/clab/inventory-clab.json"

(
  cd "${tmp_dir}/clab"
  CLABGEN_RENDERER_INVENTORY_JSON="${tmp_dir}/clab/inventory-clab.json" \
  CLABGEN_DEPLOYMENT_HOST="s-router-clab" \
    nix run "${clab_renderer_flake}#generate-clab-config" -- \
      "${tmp_dir}/clab/control-plane.json" \
      "${tmp_dir}/clab/fabric.clab.yml" \
      "${tmp_dir}/clab/vm-bridges-generated.nix" >/dev/null
)

grep -F 'clab-core-testnet-routed-isp' "${tmp_dir}/clab/fabric.clab.yml" >/dev/null
grep -F 'clab-core-testnet-host-isp' "${tmp_dir}/clab/fabric.clab.yml" >/dev/null
if grep -F 'nixos-core-testnet' "${tmp_dir}/clab/fabric.clab.yml" >/dev/null; then
  echo "FAIL emulated-isp-residential-testnet: CLAB render included site-a/nixos nodes" >&2
  exit 1
fi
grep -F 'br-t-routed' "${tmp_dir}/clab/vm-bridges-generated.nix" >/dev/null
grep -F 'br-t-host' "${tmp_dir}/clab/vm-bridges-generated.nix" >/dev/null

mkdir -p "${tmp_dir}/nixos-render"
ln -s "${hat_dir}/inventory-nixos.nix" "${tmp_dir}/nixos/inventory-nixos.nix"
(
  cd "${tmp_dir}/nixos-render"
  nix run "${nixos_renderer_flake}#render-dry-config" -- \
    --debug "${tmp_dir}/nixos/control-plane.json" >/dev/null
)

jq -e '
  .render.hosts."s-router-nixos".network.bridges as $bridges
  | .render.hosts."s-router-nixos".network.networks as $networks
  | ($bridges | length) >= 2
    and ($networks | length) >= 2
' "${tmp_dir}/nixos-render/90-dry-config.json" >/dev/null

NIXOS_RENDERER_FLAKE="${nixos_renderer_flake}" HAT_DIR="${hat_dir}" nix eval --impure --expr '
  let
    renderer = builtins.getFlake (builtins.getEnv "NIXOS_RENDERER_FLAKE");
    root = builtins.getEnv "HAT_DIR";
    mkHost = selector: renderer.lib.renderer.buildHostFromPaths {
      inherit selector;
      system = "x86_64-linux";
      intentPath = root + "/intent.nix";
      inventoryPath = root + "/inventory-nixos.nix";
    };
    labHost = mkHost "s-router-nixos";
    clientHost = mkHost "s-router-test-clients";
    require = cond: msg: if cond then true else throw msg;
    hostHasManagement = host:
      let
        uplinks = host.renderedHost.uplinks or { };
        netdevs = host.renderedHost.netdevs or { };
        networks = host.renderedHost.networks or { };
      in
        (uplinks.management.bridge or null) == "vlan2"
        && (uplinks.management.mode or null) == "vlan"
        && (uplinks.management.parent or null) == "eth0"
        && (uplinks.management.vlan or null) == 2
        && (uplinks.management.ipv4.dhcp or false)
        && (netdevs."11-eth0.2".vlanConfig.Id or null) == 2
        && (netdevs."10-vlan2".netdevConfig.Kind or null) == "bridge"
        && (networks."21-eth0.2".networkConfig.Bridge or null) == "vlan2"
        && (networks."30-vlan2".networkConfig.DHCP or null) == "ipv4";
  in
    require (hostHasManagement labHost)
      "HAT NixOS s-router-nixos render must preserve vlan2 management"
    && require (hostHasManagement clientHost)
      "HAT NixOS s-router-test-clients render must preserve vlan2 management"
' >/dev/null

echo "PASS hat-emulated-isp-residential-testnet"
