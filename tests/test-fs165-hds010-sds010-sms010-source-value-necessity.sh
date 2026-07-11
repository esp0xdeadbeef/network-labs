#!/usr/bin/env bash
# GAMP-ID: FS-165-HDS-010-SDS-010-SMS-010
# Row-local focused test: source-value necessity validation
# Evidence tier: construction/local-build
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
agent_root="${NETWORK_CODEX_AGENT_ROOT:-${repo_root}/../network-codex-agent}"
focused_test="${agent_root}/tests/test-gamp-fs165-source-form-minimality.sh"

fail() { echo "FAIL FS-165-HDS-010-SDS-010-SMS-010: $*" >&2; exit 1; }

[[ -x "${focused_test}" || -f "${focused_test}" ]] \
  || fail "missing canonical focused test: ${focused_test}"

bash "${focused_test}" | grep -F 'PASS fs165-source-form-minimality' >/dev/null \
  || fail "canonical focused test did not prove FS-165 source-form minimality"

echo "PASS FS-165-HDS-010-SDS-010-SMS-010 (source-value necessity, row-local SMT)"
