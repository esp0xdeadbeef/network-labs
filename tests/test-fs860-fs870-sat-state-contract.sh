#!/usr/bin/env bash
# GAMP-IDS: FS-860-HDS-010-SDS-010, FS-870-HDS-010-SDS-010
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="${repo_root}/sat"
cpm_flake="${CPM_FLAKE:-github:esp0xdeadbeef/network-control-plane-model}"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

inventory_nix="${tmp_dir}/inventory-nixos.nix"
output_json="${tmp_dir}/cpm.json"

printf 'import %s/getResolvedInventory.nix { renderer = "nixos"; }\n' "${lab_dir}" >"${inventory_nix}"

nix run --show-trace "${cpm_flake}#compile-and-build-control-plane-model" -- \
  "${lab_dir}/intent.nix" \
  "${inventory_nix}" \
  "${output_json}" >/dev/null

jq -e '
  def state_contracts_for($target):
    ($target.stateContracts // {}) as $sc
    | (
        ($sc.persistence.dhcp4Leases // [])[],
        ($sc.persistence.dhcpv6Leases // [])[],
        ($sc.persistence.dnsServiceState // [])[],
        ($sc.persistence.dnsResolverState // [])[],
        ($sc.persistence.relatedServices // [])[],
        ($sc.operationalRecords.dhcp4Leases // [])[],
        ($sc.operationalRecords.dhcpv6Leases // [])[],
        ($sc.operationalRecords.dnsService // [])[],
        ($sc.operationalRecords.dnsResolver // [])[]
      );
  def all_state_contracts:
    [
      .control_plane_model.data
      | to_entries[]
      | .value
      | to_entries[]
      | .value.runtimeTargets
      | to_entries[]
      | state_contracts_for(.value)
    ];
  def nixos_access_contracts:
    [
      .control_plane_model.data.esp.nixos.runtimeTargets
      | to_entries[]
      | select(.key | startswith("esp-nixos-router-access-"))
      | state_contracts_for(.value)
    ];
  def has_class($class):
    all_state_contracts | map(.durabilityClass) | index($class) != null;
  def required_with_path:
    nixos_access_contracts
    | map(select(
        .required == true
        and .mode == "persistent"
        and .durabilityClass == "restart-persistent"
        and .source == "inventory-realization"
        and (.path | type == "string" and startswith("/persist/s-router/"))
        and (.targetName | type == "string" and length > 0)
        and (.scope.target == .targetName)
        and (.scope.service == .service)
        and (.stateClass | type == "string" and length > 0)
        and .stateLossHandling == "fail-closed-require-persistent-state"
      ));
  def restart_tolerant_with_path:
    all_state_contracts
    | map(select(
        .required == false
        and .durabilityClass == "restart-tolerant"
        and .source == "inventory-realization"
        and (.path | type == "string" and startswith("/run/s-router/"))
        and .stateLossHandling == "rebuild-from-modeled-runtime-facts"
      ));
  def disposable_without_path:
    all_state_contracts
    | map(select(
        .required == false
        and .durabilityClass == "disposable"
        and .source == "explicit-ephemeral"
        and .runtimeLocation == "ephemeral"
        and .stateLossHandling == "recreate-empty-state"
      ));
  (required_with_path | length) > 0
  and (required_with_path | map(.service) | unique | index("dhcp4") != null)
  and (required_with_path | map(.service) | unique | index("dhcpv6") != null)
  and (required_with_path | map(.service) | unique | index("dns-service") != null)
  and (required_with_path | map(.service) | unique | index("dns-resolver") != null)
  and has_class("restart-persistent")
  and has_class("restart-tolerant")
  and has_class("disposable")
  and (restart_tolerant_with_path | length) > 0
  and (disposable_without_path | length) > 0
' "${output_json}" >/dev/null || {
  echo "FAIL fs860-fs870-sat-state-contract: CPM artifact did not preserve persistent NixOS state paths and separated durability classes" >&2
  jq -c '
    def state_contracts_for($target):
      ($target.stateContracts // {}) as $sc
      | (
          ($sc.persistence.dhcp4Leases // [])[],
          ($sc.persistence.dhcpv6Leases // [])[],
          ($sc.persistence.dnsServiceState // [])[],
          ($sc.persistence.dnsResolverState // [])[],
          ($sc.persistence.relatedServices // [])[]
        );
    .control_plane_model.data.esp.nixos.runtimeTargets
    | to_entries
    | map(select(.key | startswith("esp-nixos-router-access-")))
    | map({
        target: .key,
        services: [state_contracts_for(.value) | {service, required, durabilityClass, source, path, runtimeLocation, stateLossHandling}]
      })
  ' "${output_json}" >&2
  exit 1
}

echo "PASS fs860-fs870-sat-state-contract"
