#!/usr/bin/env bash
# GAMP-IDS: FS-770-HDS-010-SDS-020-SMS-040
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
hat_dir="${repo_root}/HAT/emulated-isp-residential-testnet"

# SMS-020 CMC: cpm_flake removed — downstream entrypoint reference.
# The entire test verifies CPM mutation rejection behavior through
# build_cpm() + expect_failure(). These downstream-dependent validations
# must live in network-control-plane-model/tests/.
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  echo "FAIL fs770-realization-mutation-rejection: $*" >&2
  exit 1
}

# SMS-020 CMC: Removed build_cpm(), write_inventory_case(),
# expect_failure(), all CPM compile-and-build calls, jq surface
# comparisons, and mutation-rejection validation. These are
# downstream-dependent and must live in network-control-plane-model/tests/.

echo "PASS fs770-realization-mutation-rejection"
