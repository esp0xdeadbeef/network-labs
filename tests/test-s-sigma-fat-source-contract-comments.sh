#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="${repo_root}/labs/lab-s-sigma/s-router-test-three-site"
intent="${lab_dir}/intent.nix"
inventory="${lab_dir}/inventory.nix"
contract="${lab_dir}/FAT-SOURCE-CONTRACT.md"

fail() {
  echo "FAIL s-sigma-fat-source-contract-comments: $*" >&2
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
  FAT-SRC-INTENT-001
  FAT-SRC-INTENT-NIXOS-COMMS
  FAT-SRC-INTENT-NIXOS-OWNERSHIP
  FAT-SRC-INTENT-NIXOS-TRANSPORT
  FAT-SRC-INTENT-HETZ-COMMS
  FAT-SRC-INTENT-HETZ-OWNERSHIP
  FAT-SRC-INTENT-HETZ-TRANSPORT
  FAT-SRC-INTENT-CLAB-COMMS
  FAT-SRC-INTENT-CLAB-OWNERSHIP
  FAT-SRC-INTENT-CLAB-TRANSPORT
)

inventory_markers=(
  FAT-SRC-INVENTORY-001
  FAT-SRC-INVENTORY-CLAB-ROLES
  FAT-SRC-INVENTORY-CONTROL-PLANE
  FAT-SRC-INVENTORY-DEPLOYMENT
  FAT-SRC-INVENTORY-ENDPOINTS
  FAT-SRC-INVENTORY-REALIZATION
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
  USR-MODEL-001 \
  USR-MODEL-002 \
  USR-MODEL-003 \
  USR-MODEL-004 \
  USR-INET-001 \
  USR-INET-002 \
  USR-REACH-001 \
  USR-PREFIX-001 \
  USR-PREFIX-002 \
  USR-DNS-001 \
  USR-ROUTING-001 \
  USR-OVERLAY-001 \
  USR-SECRET-001 \
  USR-STATE-001 \
  USR-PROD-001 \
  USR-VALID-001 \
  USR-VALID-002 \
  FS-FN-024 \
  HDS-INF-030 \
  SDS-SW-029 \
  SMS-MOD-018 \
  CMC-MOD-018 \
  FAT-SOURCE-GOVERNANCE-001; do
  require_text "${contract}" "${gamp_id}"
done

require_text "${contract}" "network-labs/labs/lab-s-sigma/s-router-test-three-site"
require_text "${contract}" "network-labs/examples"
require_text "${contract}" "They are not FAT source evidence by themselves."
require_text "${contract}" "This document is not FAT evidence."
require_text "${contract}" "FAT-SCEN-PROVIDER-NEBULA-001"
require_text "${contract}" "FAT-SCEN-PROVIDER-WG-128-EGRESS-001"
require_text "${contract}" "FAT-SCEN-PROVIDER-WG-64-ROUTED-001"
require_text "${contract}" "FAT-SCEN-PROVIDER-WG-PORTFWD-001"
require_text "${contract}" "FAT-SCEN-EMULATED-ISP-NIXOS-001"
require_text "${contract}" "FAT-SCEN-EMULATED-ISP-CLAB-001"
require_text "${contract}" "FAT-SRC-GAP-WIREGUARD-128-001"
require_text "${contract}" "FAT-SRC-GAP-WIREGUARD-64-001"
require_text "${contract}" "FAT-SRC-GAP-WIREGUARD-PUBLIC-001"
require_text "${contract}" "FAT-SRC-GAP-PPPOE-NIXOS-001"
require_text "${contract}" "FAT-SRC-GAP-PPPOE-CLAB-001"
require_text "${contract}" "Nebula"
require_text "${contract}" "WireGuard"
require_text "${contract}" 'VLAN `4`'
require_text "${contract}" 'VLAN `11`'

if grep -RFl "FAT-SRC-INTENT-001" "${repo_root}/examples" >/dev/null; then
  fail "examples must not carry s-router FAT source markers"
fi

nix-instantiate --parse "${intent}" >/dev/null
nix-instantiate --parse "${inventory}" >/dev/null

echo "PASS s-sigma-fat-source-contract-comments"
