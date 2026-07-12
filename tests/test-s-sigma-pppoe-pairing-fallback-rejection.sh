#!/usr/bin/env bash
# GAMP-ID: FS-800-HDS-010-SDS-020-SMS-030
# GAMP-ID: FS-800-HDS-030-SDS-030-SMS-010
# GAMP-SCOPE: software-integration-test
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
current_lab_status_before="$(git -C "${repo_root}" status --porcelain=v1 -- current-lab)"
current_lab_diff_before="$(git -C "${repo_root}" diff -- current-lab)"

"${repo_root}/tests/FS-800-HDS-030-SDS-030-SMS-010-pppoe-pairing-fallback-rejection.sh"
"${repo_root}/tests/run-active-lab-mini-smt.sh" FS-800-HDS-030-SDS-030-SMS-010

current_lab_status_after="$(git -C "${repo_root}" status --porcelain=v1 -- current-lab)"
current_lab_diff_after="$(git -C "${repo_root}" diff -- current-lab)"
if [[ "${current_lab_status_after}" != "${current_lab_status_before}" \
  || "${current_lab_diff_after}" != "${current_lab_diff_before}" ]]; then
  echo "FAIL s-sigma-pppoe-pairing-fallback-rejection: mini-SMT runner left current-lab mutated" >&2
  exit 1
fi

echo "PASS s-sigma-pppoe-pairing-fallback-rejection"
