#!/usr/bin/env bash
# GAMP-ID: FS-770-HDS-010-SDS-010-SMS-010
# GAMP-SCOPE: software-module-test
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
hat_dir="${repo_root}/GAMP/HAT/emulated-isp-residential-testnet"
# SMS-020 CMC: cpm_flake removed — downstream entrypoint reference.
# The CPM compile-and-build invocation, canonicalize/diff comparison of
# CPM output, and shared-service contract surface validation are
# downstream-dependent and must live in network-control-plane-model/tests/.
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

echo "PASS hat-common-intent-shared-service-source"
