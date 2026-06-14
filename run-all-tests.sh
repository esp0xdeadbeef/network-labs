#!/usr/bin/env bash
# run-all-tests.sh — run all construction tests in network-labs/tests/
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
test_dir="${repo_root}/tests"

failures=0
passed=0

echo "=== network-labs construction test suite ==="
echo

for test_file in "${test_dir}"/test-*.sh; do
  test_name="$(basename "${test_file}")"
  echo -n "  ${test_name} ... "
  if bash "${test_file}" 2>/dev/null; then
    passed=$((passed + 1))
  else
    failures=$((failures + 1))
    echo "FAILED (see above)"
  fi
done

echo
echo "=== Results: ${passed} passed, ${failures} failed ==="
if [ "${failures}" -gt 0 ]; then
  exit 1
fi
