#!/usr/bin/env bash
# GAMP-ID: FS-800-HDS-010-SDS-020-SMS-030
# GAMP-ID: FS-800-HDS-030-SDS-030-SMS-010
# GAMP-SCOPE: software-integration-test
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

"${repo_root}/tests/FS-800-HDS-030-SDS-030-SMS-010-pppoe-pairing-fallback-rejection.sh"
"${repo_root}/tests/run-active-lab-mini-smt.sh" FS-800-HDS-030-SDS-030-SMS-010

echo "PASS s-sigma-pppoe-pairing-fallback-rejection"
