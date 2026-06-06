#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="${repo_root}/sat"
intent="${lab_dir}/intent.nix"
inventory="${lab_dir}/inventory.nix"
provider_table="${lab_dir}/provider-access-fixture-table.nix"
contract="${lab_dir}/SAT-SOURCE-CONTRACT.md"

fail() {
  echo "FAIL s-sigma-sat-source-contract-comments: $*" >&2
  exit 1
}

require_file() {
  local path="$1"
  [[ -f "${path}" ]] || fail "missing ${path}"
}

require_text() {
  local path="$1"
  local text="$2"
  grep -Fq "${text}" "${path}" || fail "${path} missing ${text}"
}

require_file "${intent}"
require_file "${inventory}"
require_file "${provider_table}"
require_file "${contract}"

intent_markers=(
  SAT-SRC-INTENT-001
  SAT-SRC-INTENT-NIXOS-COMMS
  SAT-SRC-INTENT-NIXOS-OWNERSHIP
  SAT-SRC-INTENT-NIXOS-TRANSPORT
  SAT-SRC-INTENT-HETZ-COMMS
  SAT-SRC-INTENT-HETZ-OWNERSHIP
  SAT-SRC-INTENT-HETZ-TRANSPORT
  SAT-SRC-INTENT-WIREGUARD-PROVIDER-SCENARIOS
  SAT-SRC-INTENT-CLAB-COMMS
  SAT-SRC-INTENT-CLAB-OWNERSHIP
  SAT-SRC-INTENT-CLAB-TRANSPORT
)

inventory_markers=(
  SAT-SRC-INVENTORY-001
  SAT-SRC-INVENTORY-CLAB-ROLES
  SAT-SRC-INVENTORY-CONTROL-PLANE
  SAT-SRC-INVENTORY-DEPLOYMENT
  SAT-SRC-INVENTORY-ENDPOINTS
  SAT-SRC-INVENTORY-MTU
  SAT-SRC-INVENTORY-PROVIDER-BOOTSTRAP-DNS
  SAT-SRC-INVENTORY-WIREGUARD-PROVIDER-CONTRACTS
  SAT-SRC-INVENTORY-STATIC-RESERVATION
  SAT-SRC-INVENTORY-UPSTREAM-EMULATION
  SAT-SRC-INVENTORY-SECRET-DECLARATIONS
  SAT-SRC-INVENTORY-SECRET-SOURCE-BINDINGS
  SAT-SRC-INVENTORY-REALIZATION
)

for marker in "${intent_markers[@]}"; do
  require_text "${intent}" "${marker}"
  require_text "${contract}" "${marker}"
done

for marker in "${inventory_markers[@]}"; do
  require_text "${inventory}" "${marker}"
  require_text "${contract}" "${marker}"
done

for gamp_id in \
  URS-010 \
  URS-020 \
  URS-030 \
  URS-040 \
  URS-050 \
  URS-060 \
  URS-070 \
  URS-080 \
  URS-090 \
  URS-100 \
  URS-110 \
  URS-120 \
  URS-130 \
  URS-140 \
  URS-150 \
  URS-160 \
  URS-170 \
  URS-170-FS-010 \
  URS-170-FS-020 \
  URS-180 \
  URS-180-FS-010 \
  URS-190 \
  URS-190-FS-010; do
  require_text "${contract}" "${gamp_id}"
done

require_text "${contract}" "network-labs/sat"
require_text "${contract}" "network-labs/examples"
require_text "${contract}" "They are not SAT source evidence by themselves."
require_text "${contract}" "This document is not SAT evidence."
require_text "${contract}" "SAT-SCEN-PROVIDER-NEBULA-001"
require_text "${contract}" "SAT-SCEN-PROVIDER-WG-128-EGRESS-001"
require_text "${contract}" "SAT-SCEN-PROVIDER-WG-64-ROUTED-001"
require_text "${contract}" "SAT-SCEN-PROVIDER-WG-PORTFWD-001"
require_text "${contract}" "SAT-SCEN-EMULATED-ISP-NIXOS-001"
require_text "${contract}" "SAT-SCEN-EMULATED-ISP-CLAB-001"
require_text "${contract}" "WireGuard provider-profile realization authority"
require_text "${contract}" "SAT-SRC-INVENTORY-WIREGUARD-PROVIDER-CONTRACTS"
require_text "${contract}" "SAT-SRC-INTENT-WIREGUARD-PROVIDER-SCENARIOS"
require_text "${contract}" "Source provenance present in"
require_text "${contract}" "HAT/SAT live proof not provided"
require_text "${contract}" "Nebula"
require_text "${contract}" "WireGuard"
# shellcheck disable=SC2016
require_text "${contract}" 'VLAN `4`'
require_text "${contract}" 'provider-access-fixture-table.nix'
require_text "${contract}" 'SAT-SRC-INTENT-NIXOS-UPSTREAM-EMULATION'
require_text "${contract}" 'SAT-SRC-INTENT-CLAB-UPSTREAM-EMULATION'
# shellcheck disable=SC2016
require_text "${contract}" 'retired from `intent.nix`'
# shellcheck disable=SC2016
require_text "${contract}" 'intent.nix` shall not carry `upstreamEmulation`'
# shellcheck disable=SC2016
require_text "${contract}" 'isolated Ethernet PPPoE handoff bridges with `physical = false`'
require_text "${contract}" 'provider runtime node, customer runtime node, paired handoff link/interface'
require_text "${contract}" 'server/client PPPoE service placement'
require_text "${contract}" 'Physical PPPoE VLAN handoff requires an explicit exclusive-run guard.'
require_text "${provider_table}" 'SAT-SCEN-EMULATED-ISP-NIXOS-001'
require_text "${provider_table}" 'SAT-SCEN-EMULATED-ISP-CLAB-001'
require_text "${provider_table}" 'FS-800-HDS-010-SDS-011-SMS-010'

if grep -Fq "SAT-SRC-GAP-PPPOE" "${contract}"; then
  fail "PPPoE source gaps must not remain once inventory upstream-emulation rows exist"
fi

if grep -Fq "SAT-SRC-GAP-WIREGUARD" "${contract}"; then
  fail "WireGuard source gaps must not remain once inventory provider contracts exist"
fi

if grep -RFl "SAT-SRC-INTENT-001" "${repo_root}/examples" >/dev/null; then
  fail "examples must not carry s-router SAT source markers"
fi

nix-instantiate --parse "${intent}" >/dev/null
nix-instantiate --parse "${inventory}" >/dev/null
nix-instantiate --parse "${provider_table}" >/dev/null

nix eval --impure --raw --expr "
  let
    intent = import ${intent};
    encoded = builtins.toJSON intent;
  in
    if builtins.match \".*upstreamEmulation.*\" encoded == null
      && builtins.match \".*providerAccess.*\" encoded == null
    then \"true\"
    else throw \"s-router SAT intent must not carry upstreamEmulation/providerAccess side-channel fields\"
" >/dev/null

nix eval --impure --raw --expr "
  let
    inventory = import ${inventory};
    expectedForwarders = [ \"192.0.2.53\" \"2001:db8::53\" ];
    siteHasProviderBootstrapDns = siteName:
      let
        dns = inventory.controlPlane.sites.esp.\${siteName}.overlays.east-west.providerBootstrapDns or { };
      in
        (dns.forwarders or [ ]) == expectedForwarders;
  in
    if siteHasProviderBootstrapDns \"nixos\"
      && siteHasProviderBootstrapDns \"hetz\"
      && siteHasProviderBootstrapDns \"clab\"
    then \"true\"
    else throw \"s-router SAT source must define providerBootstrapDns.forwarders on nixos, hetz, and clab east-west overlays\"
" >/dev/null

nix eval --impure --raw --expr "
  let
    intent = import ${intent};
    inventory = import ${inventory};
    require = cond: msg: if cond then true else throw msg;
    relationById = relations: id:
      let
        matches = builtins.filter (relation: relation.id == id) relations;
      in
        if matches == [ ] then throw \"missing relation \${id}\" else builtins.head matches;
    overlayByName = overlays: name:
      let
        matches = builtins.filter (overlay: overlay.name == name) overlays;
      in
        if matches == [ ] then throw \"missing overlay \${name}\" else builtins.head matches;
    wgHost = inventory.controlPlane.sites.esp.hetz.overlays.wg-host128-egress.wireguard.providerContract;
    wgRouted = inventory.controlPlane.sites.esp.hetz.overlays.wg-routed64.wireguard.providerContract;
    hetzRelations = intent.esp.hetz.communicationContract.relations;
    hostRelation = relationById hetzRelations \"allow-wan-to-wireguard-host128\";
    routedRelation = relationById hetzRelations \"allow-wan-to-wireguard-routed64\";
    routedIngressRelation = relationById hetzRelations \"allow-wireguard-routed64-public-ingress-to-hetz-client\";
    hostOverlay = overlayByName intent.esp.hetz.transport.overlays \"wg-host128-egress\";
    routedOverlay = overlayByName intent.esp.hetz.transport.overlays \"wg-routed64\";
    encodedHetzIntent = builtins.toJSON intent.esp.hetz;
    routedPublicIngress = builtins.head wgRouted.publicIngress;
    routedForward = builtins.head wgRouted.portForwards;
    routedReturn = builtins.head wgRouted.routes.returnRoutes;
  in
    if require (builtins.match \".*prefixAuthority.*\" encodedHetzIntent == null)
      \"WireGuard provider-profile prefix authority must not move into intent tuple authority\"
      && require (builtins.match \".*providerContract.*\" encodedHetzIntent == null)
        \"WireGuard provider contracts must stay in inventory realization authority\"
      && require (hostOverlay.underlayTrafficTypes == [ \"wireguard-host128\" ])
        \"intent must authorize the host-only WireGuard provider overlay traffic tuple\"
      && require (routedOverlay.underlayTrafficTypes == [ \"wireguard-routed64\" ])
        \"intent must authorize the routed64 WireGuard provider overlay traffic tuple\"
      && require (hostRelation.to.kind == \"service\" && hostRelation.to.name == \"wireguard-host128\" && hostRelation.trafficType == \"wireguard-host128\")
        \"intent must authorize WireGuard host-only provider-control service traffic\"
      && require (routedRelation.to.kind == \"service\" && routedRelation.to.name == \"wireguard-routed64\" && routedRelation.trafficType == \"wireguard-routed64\")
        \"intent must authorize WireGuard routed64 provider-control service traffic\"
      && require (routedIngressRelation.to.kind == \"service\" && routedIngressRelation.to.name == \"hetz-client-4446\" && routedIngressRelation.trafficType == \"tcp-udp-4446\")
        \"intent must authorize the WireGuard routed64 public-ingress target tuple\"
      && require (wgHost.provider.prefixAuthority == \"host-only-128\")
        \"inventory must carry WireGuard host-only /128 prefix authority\"
      && require (wgHost.nat.ipv4.enable == true && wgHost.nat.ipv6.enable == true)
        \"inventory must carry WireGuard host-only NAT44/NAT66 realization authority\"
      && require (builtins.elem \"2001:db8:128::2/128\" wgHost.profile.generatedPeer.addresses)
        \"inventory must carry WireGuard host-only generated /128 peer address\"
      && require (wgRouted.provider.prefixAuthority == \"provider-owned-prefix\")
        \"inventory must carry WireGuard routed64 provider-owned prefix authority\"
      && require (wgRouted.nat.ipv4.enable == true && wgRouted.nat.ipv6.enable == false)
        \"inventory must carry WireGuard routed64 no-NAT66 realization authority\"
      && require (wgRouted.routes.ipv6.providerOwnedPrefixes == [ \"2001:db8:64:100::/64\" ])
        \"inventory must carry WireGuard routed64 provider-owned /64\"
      && require (routedReturn.destination == \"2001:db8:64:100::/64\" && routedReturn.interface == \"wg64-lan\")
        \"inventory must carry WireGuard routed64 return route\"
      && require (routedPublicIngress.protocol == \"tcp\" && routedPublicIngress.listenPort == 8447 && routedPublicIngress.targetPort == 4446)
        \"inventory must carry WireGuard routed64 public-ingress realization\"
      && require (routedForward.protocol == \"udp\" && routedForward.listenPort == 51822 && routedForward.targetPort == 4446)
        \"inventory must carry WireGuard routed64 port-forward realization\"
    then \"true\"
    else \"unreachable\"
" >/dev/null

nix eval --impure --raw --expr "
  let
    inventory = import ${inventory};
    mtu = inventory.realization.nodes.esp-nixos-router-core-isp-a.ports.isp-a.interface.mtu or null;
  in
    if mtu == 1492
    then \"true\"
    else throw \"s-router SAT source must define explicit MTU realization for esp-nixos-router-core-isp-a isp-a\"
" >/dev/null

nix eval --impure --raw --expr "
  let
    inventory = import ${inventory};
    node = inventory.realization.nodes.esp-nixos-router-access-client;
    dhcp4 = builtins.head node.advertisements.dhcp4.tenant-client.reservations;
    dhcp6Service = node.advertisements.dhcpv6.tenant-client;
    dhcp6 = builtins.head node.advertisements.dhcpv6.tenant-client.reservations;
  in
    if dhcp4.mac == \"02:10:20:00:00:10\"
      && dhcp4.macSource.sourceClass == \"public-synthetic-lab\"
      && dhcp4.macSource.purpose == \"static-dhcp-reservation\"
      && dhcp4.macSource.accepted == true
      && dhcp4.macSource.disposable == true
      && dhcp4.namespaceOwner == \"tenant-client\"
      && dhcp4.conflictBehavior == \"fail-closed\"
      && dhcp4.ipv4.hostOffset == 10
      && dhcp6Service.pool.start == \"fd42:dead:beef:20::100\"
      && dhcp6Service.pool.end == \"fd42:dead:beef:20::1ff\"
      && dhcp6.mac == \"02:10:20:00:00:10\"
      && dhcp6.macSource.sourceClass == \"public-synthetic-lab\"
      && dhcp6.macSource.purpose == \"dhcpv6-reservation\"
      && dhcp6.macSource.accepted == true
      && dhcp6.macSource.disposable == true
      && dhcp6.namespaceOwner == \"tenant-client\"
      && dhcp6.conflictBehavior == \"fail-closed\"
      && dhcp6.ipv6.hostOffset == 16
    then \"true\"
    else throw \"s-router SAT source must define controlled DHCP and DHCPv6 static reservations with accepted FS-720 MAC source classification for esp-nixos-router-access-client\"
" >/dev/null

echo "PASS s-sigma-sat-source-contract-comments"
