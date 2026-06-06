#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ "${NETWORK_REPO_SWEEP:-0}" != "1" && "${NETWORK_REPO_DIRECT_TEST_OK:-0}" != "1" ]]; then
  echo "WARN: direct repo tests are partial; set NETWORK_REPO_DIRECT_TEST_OK=1 for intentional focused runs, or run network-codex-agent/scripts/s-router-full-lab-rebuild-loop.sh for the locked full network-* sweep plus live validation." >&2
fi

default_jobs="$(nproc 2>/dev/null || getconf _NPROCESSORS_ONLN 2>/dev/null || printf '1')"
jobs="${TEST_JOBS:-${default_jobs}}"
test_timeout_seconds="${TEST_TIMEOUT_SECONDS:-${NETWORK_REPO_TEST_TIMEOUT_SECONDS:-1800}}"
if ! [[ "${jobs}" =~ ^[0-9]+$ ]] || [[ "${jobs}" -lt 1 ]]; then
  echo "error: TEST_JOBS must be a positive integer, got '${jobs}'" >&2
  exit 2
fi
if ! [[ "${test_timeout_seconds}" =~ ^[0-9]+$ ]] || [[ "${test_timeout_seconds}" -lt 1 ]]; then
  echo "error: TEST_TIMEOUT_SECONDS must be a positive integer, got '${test_timeout_seconds}'" >&2
  exit 2
fi

tests=(
  test-readable-examples-and-labs.sh
  test-lab-sigma-runtime-contract.sh
  test-lab-sigma-dns-intent-to-cpm.sh
  test-lab-sigma-public-egress-intent.sh
  test-lab-sigma-hetzner-ipv6-wan-transit.sh
  test-lab-sigma-wan-vlan-uplink-authority.sh
  test-hostile-exits-east-west-only.sh
  test-lab-sigma-nebula-public-endpoints.sh
  test-lab-sigma-nebula-underlay-access.sh
  test-lab-sigma-wireguard-host128-core-split.sh
  test-overlay-underlay-service-reachability-examples.sh
  test-overlay-pools-live-in-intent.sh
  test-runtime-routed-prefixes-live-in-intent.sh
  test-inventory-model-boundary.sh
  test-nebula-relay-realization-contract.sh
  test-nebula-runtime-node-intent-contract.sh
  test-tri-site-bgp-overlay-realization.sh
  test-modeling-contract-docs.sh
  test-smt-traceability-docs.sh
  test-s-sigma-sat-source-contract-comments.sh
  test-fs200-shared-service-source-matrix.sh
  test-fs650-fs690-profile-matrices.sh
  test-fs690-support-view-provenance-non-authority.sh
  test-fs810-fs820-secret-source-records.sh
  test-s-sigma-pppoe-upstream-emulation-source.sh
  test-s-sigma-provider-access-attachments.sh
  test-s-sigma-pppoe-pairing-fallback-rejection.sh
  test-s-sigma-site-role-map.sh
  test-s-sigma-site-role-map-provider-ingress-overlay.sh
  test-s-sigma-site-role-map-management-access-membership.sh
  test-management-core-host-authority-source.sh
  test-s-sigma-site-evidence-name-map.sh
  test-s-sigma-public-ingress-fixture-table.sh
  test-s-sigma-public-ingress-denied-variants.sh
  test-s-sigma-public-ingress-provider-emulation-boundary.sh
  test-public-ingress-source-tuple-authority.sh
  test-lab-intent-derived-topology-contract.sh
  test-lab-inventory-derived-p2p-bindings-contract.sh
  test-inventory-no-synthetic-default-containers.sh
  test-lab-runtime-secret-boundary.sh
  test-s-router-client-bridge-contract.sh
  test-s-router-clab-access-vlans.sh
  test-s-router-clab-inventory-interface-names.sh
  test-multi-wan-nixos-wan-group-bindings.sh
  test-clab-nat-uplink-examples.sh
  test-ipv6-pd-downstream-delegation-example-required.sh
  test-fs750-receiver-source.sh
  test-fs730-printer-cups-source.sh
  test-fs770-common-intent-field-presence.sh
  test-fs770-realization-fact-classification.sh
  test-fs770-realization-fact-binding.sh
  test-fs770-realization-mutation-rejection.sh
  test-hat-printer-receiver-policy-source.sh
  test-hat-emulated-isp-residential-testnet.sh
  test-hat-fixture-source-boundaries.sh
  test-hat-upstream-inventory-realization-boundary.sh
)

tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

declare -A pid_to_name=()
declare -A pid_to_log=()
declare -A pid_to_start=()
running=0
failures=0

wait_for_one() {
  local finished_pid
  local status=0
  wait -n -p finished_pid || status=$?

  local name="${pid_to_name[${finished_pid}]}"
  local log_file="${pid_to_log[${finished_pid}]}"
  local start="${pid_to_start[${finished_pid}]}"
  local elapsed=$((SECONDS - start))
  unset "pid_to_name[${finished_pid}]"
  unset "pid_to_log[${finished_pid}]"
  unset "pid_to_start[${finished_pid}]"
  running=$((running - 1))

  if (( status == 0 )); then
    printf 'PASS %s (%ss)\n' "${name}" "${elapsed}"
  else
    printf 'FAIL %s (exit %s, %ss)\n' "${name}" "${status}" "${elapsed}" >&2
    awk -v prefix="[${name}] " '{ print prefix $0 }' "${log_file}" >&2
    failures=$((failures + 1))
  fi
}

printf 'running %s tests with TEST_JOBS=%s\n' "${#tests[@]}" "${jobs}"
for test_name in "${tests[@]}"; do
  test_path="${repo_root}/tests/${test_name}"
  log_file="${tmp_dir}/${test_name}.log"
  printf 'START %s\n' "${test_name}"
  timeout "${test_timeout_seconds}" "${test_path}" >"${log_file}" 2>&1 &
  pid_to_name[$!]="${test_name}"
  pid_to_log[$!]="${log_file}"
  pid_to_start[$!]="${SECONDS}"
  running=$((running + 1))

  if (( running >= jobs )); then
    wait_for_one
  fi
done

while (( running > 0 )); do
  wait_for_one
done

if (( failures > 0 )); then
  printf 'FAIL network-labs: %s test(s) failed\n' "${failures}" >&2
  exit 1
fi

printf 'PASS network-labs: %s tests\n' "${#tests[@]}"
