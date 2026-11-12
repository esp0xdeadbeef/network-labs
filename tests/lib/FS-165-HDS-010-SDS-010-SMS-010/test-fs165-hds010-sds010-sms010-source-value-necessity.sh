#!/usr/bin/env bash
# GAMP-ID: FS-165-HDS-010-SDS-010-SMS-010
# Row-local focused test: source-value necessity validation
# Evidence tier: construction/local-build
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
agent_root="${NETWORK_CODEX_AGENT_ROOT:-${repo_root}/../network-codex-agent}"

fail() { echo "FAIL FS-165-HDS-010-SDS-010-SMS-010: $*" >&2; exit 1; }

# The canonical source-form checker moved from tests/ to tests/lib/shared/.
# Resolve it through the same list FS-165-HDS-010-SDS-010-SMS-020 and -030 use,
# so all three FS-165 rows assert one location contract instead of three
# independent guesses at the canonical layout.
focused_test=""
for candidate in \
  "${agent_root}/tests/lib/shared/test-gamp-fs165-source-form-minimality.sh" \
  "${agent_root}/tests/test-gamp-fs165-source-form-minimality.sh"; do
  if [[ -f "${candidate}" ]]; then
    focused_test="${candidate}"
    break
  fi
done

[[ -n "${focused_test}" ]] \
  || fail "missing canonical focused test under ${agent_root}/tests (looked in tests/lib/shared/ and tests/)"

# The checker resolves its helper and the GAMP spec tree from SMS_TEST_REPO_ROOT,
# so run it rooted at the canonical repository it belongs to. The suite exports
# that variable pointed at network-labs for row-local cases; override it here
# because this row delegates to the canonical checker rather than reimplementing it.
SMS_TEST_REPO_ROOT="${agent_root}" bash "${focused_test}" \
  | grep -F 'PASS fs165-source-form-minimality' >/dev/null \
  || fail "canonical focused test did not prove FS-165 source-form minimality"

echo "PASS FS-165-HDS-010-SDS-010-SMS-010 (source-value necessity, row-local SMT)"
