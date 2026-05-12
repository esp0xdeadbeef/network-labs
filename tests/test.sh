#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ "${NETWORK_REPO_SWEEP:-0}" != "1" && "${NETWORK_REPO_DIRECT_TEST_OK:-0}" != "1" ]]; then
  echo "WARN: direct repo tests are partial; set NETWORK_REPO_DIRECT_TEST_OK=1 for intentional focused runs, or run network-codex-agent/scripts/s-router-full-lab-rebuild-loop.sh for the locked full network-* sweep plus live validation." >&2
fi

"${repo_root}/tests/test-readable-examples-and-labs.sh"
"${repo_root}/tests/test-lab-sigma-runtime-contract.sh"
"${repo_root}/tests/test-lab-sigma-hetzner-ipv6-wan-transit.sh"
"${repo_root}/tests/test-lab-sigma-nebula-public-endpoints.sh"
"${repo_root}/tests/test-nebula-relay-realization-contract.sh"
"${repo_root}/tests/test-nebula-runtime-node-intent-contract.sh"
"${repo_root}/tests/test-modeling-contract-docs.sh"
"${repo_root}/tests/test-lab-intent-derived-topology-contract.sh"
"${repo_root}/tests/test-lab-inventory-derived-p2p-bindings-contract.sh"
"${repo_root}/tests/test-inventory-no-synthetic-default-containers.sh"
"${repo_root}/tests/test-lab-runtime-secret-boundary.sh"
"${repo_root}/tests/test-s-router-client-bridge-contract.sh"
"${repo_root}/tests/test-s-router-clab-access-vlans.sh"
"${repo_root}/tests/test-clab-nat-uplink-examples.sh"
"${repo_root}/tests/test-ipv6-pd-downstream-delegation-example-required.sh"
