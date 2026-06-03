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

if rg -n 'nat-isp|simulated-isp|east-west|nebula|spoofed' "${hat_dir}" >&2; then
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
    nixosHost = nixos.deployment.hosts.lab-host;
    nixosClientHost = nixos.deployment.hosts.s-router-test-clients;
    clabDhcp = clabHost.hat.upstreamEmulation.residentialDhcpRoutedTestnet;
    clabPppoe = clabHost.hat.upstreamEmulation.residentialPppoeHostTestnet;
    nixosDhcp = nixosHost.hat.upstreamEmulation.residentialDhcpRoutedTestnet;
    nixosPppoe = nixosHost.hat.upstreamEmulation.residentialPppoeHostTestnet;
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
    hasRelation = id: builtins.any (relation: (relation.id or "") == id) relations;
    require = cond: msg: if cond then true else throw msg;
  in
    require (nodes ? s-router-access-client)
      "missing client access node"
    && require (nodes ? s-router-core-testnet-routed-isp)
      "missing routed testnet ISP core node"
    && require (nodes ? s-router-core-testnet-host-isp)
      "missing host testnet ISP core node"
    && require (nodes.s-router-core-testnet-routed-isp.uplinks.testnet-routed-isp.ipv4 == [ "203.0.113.0/30" ])
      "routed testnet ISP must advertise IPv4 203.0.113.0/30"
    && require (nodes.s-router-core-testnet-routed-isp.uplinks.testnet-routed-isp.ipv6 == [ "2001:db8:113::/48" ])
      "routed testnet ISP must advertise IPv6 /48"
    && require (nodes.s-router-core-testnet-host-isp.uplinks.testnet-host-isp.ipv4 == [ "203.0.113.4/32" ])
      "host testnet ISP must advertise IPv4 203.0.113.4/32"
    && require (nodes.s-router-core-testnet-host-isp.uplinks.testnet-host-isp.ipv6 == [ "2001:db8:113:64::/64" ])
      "host testnet ISP must advertise constrained IPv6 /64"
    && require (!(site ? transport))
      "fixture must not model an overlay transport"
    && require (hasRelation "allow-client-to-testnet-routed-isp")
      "missing client to routed testnet ISP relation"
    && require (hasRelation "allow-client-to-testnet-host-isp")
      "missing client to host testnet ISP relation"
    && require (clabDhcp.harness == "s-router-clab")
      "CLAB DHCP row must name s-router-clab"
    && require (nixosDhcp.harness == "s-router-nixos")
      "NixOS DHCP row must name s-router-nixos"
    && require (clabPppoe.harness == "s-router-clab")
      "CLAB PPPoE row must name s-router-clab"
    && require (nixosPppoe.harness == "s-router-nixos")
      "NixOS PPPoE row must name s-router-nixos"
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
    && require (clabHost.bridgeNetworks."br-c-pppoe".isolated == true)
      "CLAB PPPoE bridge must be isolated"
    && require (nixosHost.bridgeNetworks."br-n-pppoe".isolated == true)
      "NixOS PPPoE bridge must be isolated"
    && require (nixosHost.uplinks.management.bridge == "vlan2")
      "HAT NixOS lab-host must preserve vlan2 management uplink"
    && require (nixosHost.uplinks.management.mode == "vlan" && nixosHost.uplinks.management.parent == "eth0" && nixosHost.uplinks.management.vlan == 2)
      "HAT NixOS lab-host management must use eth0 VLAN 2"
    && require (nixosHost.uplinks.management.ipv4.dhcp == true && nixosHost.uplinks.management.ipv4.method == "dhcp")
      "HAT NixOS lab-host management must use IPv4 DHCP"
    && require (nixos.deployment.hosts.s-router-nixos.uplinks.management == nixosHost.uplinks.management)
      "HAT NixOS inventory must preserve s-router-nixos management uplink"
    && require (nixos.deployment.hosts.s-router-test-clients.uplinks.management == nixosHost.uplinks.management)
      "HAT NixOS inventory must preserve s-router-test-clients management uplink"
    && require (builtins.all clientBridgeOk (builtins.attrNames requiredClientBridgeVlans))
      "HAT s-router-test-clients must expose tenant bridge VLANs required by endpoint containers"
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
    && require (!(clabHost.uplinks.uplink-testnet-routed-isp ? vlan) && !(nixosHost.uplinks.uplink-testnet-routed-isp ? vlan))
      "routed testnet ISP uplinks must not be tagged VLANs"
    && require (!(clabHost.uplinks.uplink-testnet-host-isp ? vlan) && !(nixosHost.uplinks.uplink-testnet-host-isp ? vlan))
      "host testnet ISP uplinks must not be tagged VLANs"
    && require (clabHost.wanGroupToUplink."esp0xdeadbeef::site-a::s-router-core-testnet-routed-isp" == "uplink-testnet-routed-isp")
      "routed core must map to routed testnet uplink"
    && require (clabHost.wanGroupToUplink."esp0xdeadbeef::site-a::s-router-core-testnet-host-isp" == "uplink-testnet-host-isp")
      "host core must map to host testnet uplink"
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
    .control_plane_model.data.esp0xdeadbeef."site-a" as $site
    | ($site.runtimeTargets
        | has("esp0xdeadbeef-site-a-s-router-access-client")
          and has("esp0xdeadbeef-site-a-s-router-core-testnet-routed-isp")
          and has("esp0xdeadbeef-site-a-s-router-core-testnet-host-isp"))
      and ([
        $site.trafficPaths[]
        | select(.relationId == "allow-client-to-testnet-routed-isp")
        | .nodePath
      ] == [[
        "s-router-access-client",
        "s-router-downstream-selector",
        "s-router-policy",
        "s-router-upstream-selector",
        "s-router-core-testnet-routed-isp"
      ]])
      and ([
        $site.trafficPaths[]
        | select(.relationId == "allow-client-to-testnet-host-isp")
        | .nodePath
      ] == [[
        "s-router-access-client",
        "s-router-downstream-selector",
        "s-router-policy",
        "s-router-upstream-selector",
        "s-router-core-testnet-host-isp"
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

grep -F 's-router-core-testnet-routed-isp' "${tmp_dir}/clab/fabric.clab.yml" >/dev/null
grep -F 's-router-core-testnet-host-isp' "${tmp_dir}/clab/fabric.clab.yml" >/dev/null
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
  .render.hosts."lab-host".network.bridges as $bridges
  | .render.hosts."lab-host".network.networks as $networks
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
    labHost = mkHost "lab-host";
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
      "HAT NixOS lab-host render must preserve vlan2 management"
    && require (hostHasManagement clientHost)
      "HAT NixOS s-router-test-clients render must preserve vlan2 management"
' >/dev/null

echo "PASS hat-emulated-isp-residential-testnet"
