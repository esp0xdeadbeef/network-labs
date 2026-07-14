#!/usr/bin/env bash
# GAMP-ID: FS-960-HDS-010-SDS-010-SMS-080
# GAMP-SCOPE: network-labs standard test runner
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
test_dir="${repo_root}/tests"
cache_file="/tmp/network-labs-tests.out"
seed_dir="${NETWORK_LABS_SEED_DIR:-/tmp/network-labs-seed}"

replay_cached_result() {
  cat "${cache_file}"

  summary="$(grep -E '^PASS: [0-9]+, FAIL: [0-9]+, TOTAL: [0-9]+' "${cache_file}" | tail -1 || true)"
  if [[ -n "${summary}" ]]; then
    printf '%s\n' "${summary}" >&2
  fi

  status="$(sed -n 's/^CACHE_EXIT_STATUS=//p' "${cache_file}" | tail -1)"
  if [[ -z "${status}" ]]; then
    echo "ERROR: cached network-labs test output lacks CACHE_EXIT_STATUS" >&2
    exit 1
  fi
  exit "${status}"
}

run_suite() {
  local failures=0
  local passed=0
  local skipped=0
  local total=0

  echo "=== network-labs construction test suite ==="
  echo "CACHE_HEADER timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ) git_commit=$(git -C "${repo_root}" rev-parse HEAD)"
  echo

  if [[ ! -d "${test_dir}" ]]; then
    echo "ERROR: tests directory not found: ${test_dir}" >&2
    return 1
  fi

  if [[ ! -d "${seed_dir}" || "${NETWORK_FORCE_RESEED:-0}" == "1" ]]; then
    echo "SEED: running scripts/seed.sh"
    "${repo_root}/scripts/seed.sh"
  else
    echo "SEED: using ${seed_dir}"
  fi

  shopt -s nullglob
  local tests=("${test_dir}"/test-*.sh)
  shopt -u nullglob

  if [[ "${#tests[@]}" -eq 0 ]]; then
    echo "NO TESTS DISCOVERED: ${test_dir}/test-*.sh" >&2
    printf 'PASS: 0, FAIL: 1, TOTAL: 0\n' >&2
    return 1
  fi

  for test_file in "${tests[@]}"; do
    test_name="$(basename "${test_file}")"
    total=$((total + 1))
    log_file="$(mktemp)"

    if [[ "${test_name}" == "test-sit-evidence-commands.sh" && "${NETWORK_LABS_RUN_SIT_EVIDENCE_COMMANDS:-0}" != "1" ]]; then
      skipped=$((skipped + 1))
      printf 'TEST: %s SKIP reason=live-sit-evidence opt_in=NETWORK_LABS_RUN_SIT_EVIDENCE_COMMANDS=1\n' "${test_name}"
      rm -f "${log_file}"
      continue
    fi

    if [[ "${test_name}" == "test-hat-policy-nft-rules.sh" && "${NETWORK_LABS_RUN_HAT_EVIDENCE_COMMANDS:-0}" != "1" ]]; then
      skipped=$((skipped + 1))
      printf 'TEST: %s SKIP reason=live-hat-evidence-after-runtime-readiness opt_in=NETWORK_LABS_RUN_HAT_EVIDENCE_COMMANDS=1\n' "${test_name}"
      rm -f "${log_file}"
      continue
    fi

    if NETWORK_REPO_DIRECT_TEST_OK=1 bash "${test_file}" >"${log_file}" 2>&1; then
      passed=$((passed + 1))
      printf 'TEST: %s PASS\n' "${test_name}"
    else
      failures=$((failures + 1))
      printf 'TEST: %s FAIL\n' "${test_name}" >&2
      sed "s/^/[${test_name}] /" "${log_file}" >&2
    fi

    rm -f "${log_file}"
  done

  echo
  echo "=== Results: ${passed} passed, ${failures} failed, ${skipped} skipped ==="
  printf 'PASS: %s, FAIL: %s, TOTAL: %s\n' "${passed}" "${failures}" "${total}" >&2

  if [[ "${failures}" -gt 0 ]]; then
    return 1
  fi
  return 0
}

if [[ -f "${cache_file}" && "${NETWORK_REPO_DIRECT_TEST_OK:-0}" != "1" ]]; then
  replay_cached_result
fi

set +e
run_suite 2>&1 | tee "/tmp/network-labs-tests.out"
suite_status="${PIPESTATUS[0]}"
set -e

printf 'CACHE_EXIT_STATUS=%s\n' "${suite_status}" | tee -a "/tmp/network-labs-tests.out"

summary="$(grep -E '^PASS: [0-9]+, FAIL: [0-9]+, TOTAL: [0-9]+' "${cache_file}" | tail -1 || true)"
if [[ -n "${summary}" ]]; then
  printf '%s\n' "${summary}" >&2
fi

if [[ "${suite_status}" -ne 0 ]]; then
  exit 1
fi

exit 0
