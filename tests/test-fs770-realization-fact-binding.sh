#!/usr/bin/env bash
# GAMP-IDS: FS-770-HDS-010-SDS-020-SMS-020, FS-770-HDS-010-SDS-020-SMS-030
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
hat_dir="${repo_root}/HAT/emulated-isp-residential-testnet"
cpm_flake="${CPM_FLAKE:-github:esp0xdeadbeef/network-control-plane-model}"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL fs770-realization-fact-binding: $*" >&2
  exit 1
}

build_cpm() {
  local inventory_name="$1"
  local output_json="$2"

  nix run "${cpm_flake}#compile-and-build-control-plane-model" -- \
    "${hat_dir}/intent.nix" \
    "${hat_dir}/${inventory_name}" \
    "${output_json}" >/dev/null
}

build_cpm "inventory-nixos.nix" "${tmp_dir}/nixos.json"
build_cpm "inventory-clab.nix" "${tmp_dir}/clab.json"

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
  | has_dhcp4_lease_contract($site.runtimeTargets."esp0xdeadbeef-site-a-nixos-access-client")
    and has_pppoe_client($site.runtimeTargets."esp0xdeadbeef-site-a-nixos-core-testnet-host-isp"; "p2p-nixos-core-testnet-host-isp-nixos-provider-handoff-access-a"; "ppp0")
    and has_pppoe_client($site.runtimeTargets."esp0xdeadbeef-site-a-nixos-core-testnet-routed-isp"; "p2p-nixos-core-testnet-routed-isp-nixos-provider-handoff-access-b"; "ppp1")
    and has_pppoe_server($site.runtimeTargets."esp0xdeadbeef-site-a-nixos-provider-handoff-access-a"; "p2p-nixos-core-testnet-host-isp-nixos-provider-handoff-access-a"; "203.0.113.5"; "203.0.113.4")
    and has_pppoe_server($site.runtimeTargets."esp0xdeadbeef-site-a-nixos-provider-handoff-access-b"; "p2p-nixos-core-testnet-routed-isp-nixos-provider-handoff-access-b"; "203.0.113.1"; "203.0.113.2")
' "${tmp_dir}/nixos.json" >/dev/null \
  || fail "NixOS realization facts did not bind into CPM runtime targets"

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
  .control_plane_model.data.esp0xdeadbeef."site-b" as $site
  | has_dhcp4_lease_contract($site.runtimeTargets."esp0xdeadbeef-site-b-clab-access-client")
    and has_pppoe_client($site.runtimeTargets."esp0xdeadbeef-site-b-clab-core-testnet-host-isp"; "p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a"; "ppp0")
    and has_pppoe_client($site.runtimeTargets."esp0xdeadbeef-site-b-clab-core-testnet-routed-isp"; "p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b"; "ppp1")
    and has_pppoe_server($site.runtimeTargets."esp0xdeadbeef-site-b-clab-provider-handoff-access-a"; "p2p-clab-core-testnet-host-isp-clab-provider-handoff-access-a"; "203.0.113.5"; "203.0.113.4")
    and has_pppoe_server($site.runtimeTargets."esp0xdeadbeef-site-b-clab-provider-handoff-access-b"; "p2p-clab-core-testnet-routed-isp-clab-provider-handoff-access-b"; "203.0.113.1"; "203.0.113.2")
' "${tmp_dir}/clab.json" >/dev/null \
  || fail "CLAB realization facts did not bind into CPM runtime targets"

echo "PASS fs770-realization-fact-binding"
