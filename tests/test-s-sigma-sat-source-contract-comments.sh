#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="${repo_root}/sat"
intent="${lab_dir}/intent.nix"
inventory="${lab_dir}/inventory.nix"
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
require_file "${contract}"

intent_markers=(
  SAT-SRC-INTENT-001
  SAT-SRC-INTENT-NIXOS-COMMS
  SAT-SRC-INTENT-NIXOS-OWNERSHIP
  SAT-SRC-INTENT-NIXOS-TRANSPORT
  SAT-SRC-INTENT-HETZ-COMMS
  SAT-SRC-INTENT-HETZ-OWNERSHIP
  SAT-SRC-INTENT-HETZ-TRANSPORT
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
  SAT-SRC-INVENTORY-STATIC-RESERVATION
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
require_text "${contract}" "SAT-SRC-GAP-WIREGUARD-128-001"
require_text "${contract}" "SAT-SRC-GAP-WIREGUARD-64-001"
require_text "${contract}" "SAT-SRC-GAP-WIREGUARD-PUBLIC-001"
require_text "${contract}" "SAT-SRC-GAP-PPPOE-NIXOS-001"
require_text "${contract}" "SAT-SRC-GAP-PPPOE-CLAB-001"
require_text "${contract}" "Nebula"
require_text "${contract}" "WireGuard"
require_text "${contract}" 'VLAN `4`'
require_text "${contract}" 'VLAN `11`'

if grep -RFl "SAT-SRC-INTENT-001" "${repo_root}/examples" >/dev/null; then
  fail "examples must not carry s-router SAT source markers"
fi

nix-instantiate --parse "${intent}" >/dev/null
nix-instantiate --parse "${inventory}" >/dev/null

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
      && dhcp4.namespaceOwner == \"tenant-client\"
      && dhcp4.conflictBehavior == \"fail-closed\"
      && dhcp4.ipv4.hostOffset == 10
      && dhcp6Service.pool.start == \"fd42:dead:beef:20::100\"
      && dhcp6Service.pool.end == \"fd42:dead:beef:20::1ff\"
      && dhcp6.mac == \"02:10:20:00:00:10\"
      && dhcp6.namespaceOwner == \"tenant-client\"
      && dhcp6.conflictBehavior == \"fail-closed\"
      && dhcp6.ipv6.hostOffset == 16
    then \"true\"
    else throw \"s-router SAT source must define controlled DHCP and DHCPv6 static reservations for esp-nixos-router-access-client\"
" >/dev/null

echo "PASS s-sigma-sat-source-contract-comments"
