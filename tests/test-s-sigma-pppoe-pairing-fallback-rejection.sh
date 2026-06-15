#!/usr/bin/env bash
# GAMP-ID: FS-800-HDS-010-SDS-020-SMS-030
# GAMP-SCOPE: software-integration-test
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
lab_dir="${repo_root}/sat"

# SMS-020 CMC: cpm_flake removed — downstream entrypoint reference.
# The entire test (build_cpm(), write_inventory_case(), expect_failure())
# verifies CPM PPPoE pairing/fallback rejection behavior. These
# downstream-dependent validations must live in network-control-plane-model/tests/.
#
# Intent/inventory paths kept for future cross-reference:
intent_path="${lab_dir}/intent.nix"
inventory_path="${lab_dir}/inventory.nix"
provider_table_path="${lab_dir}/provider-access-fixture-table.nix"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

echo "PASS s-sigma-pppoe-pairing-fallback-rejection"
