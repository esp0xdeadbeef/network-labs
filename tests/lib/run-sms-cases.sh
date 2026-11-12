#!/usr/bin/env bash
set -euo pipefail

helper_path="$(readlink -f "${BASH_SOURCE[0]}")"
tests_root="$(cd "$(dirname "${helper_path}")/.." && pwd)"
repo_root="$(cd "${tests_root}/.." && pwd)"
trace_id="${1:-$(basename "$0" .sh)}"
[[ "${trace_id}" == FS-*-HDS-*-SDS-*-SMS-* ]] || {
  printf 'usage: %s <trace-id>\n' "$0" >&2
  exit 2
}

mapfile -t cases < <(find "${tests_root}/lib/${trace_id}" -maxdepth 1 \( -type f -o -type l \) -name '*.sh' -print | LC_ALL=C sort)
((${#cases[@]} > 0)) || {
  printf 'FAIL %s: no internal test cases found\n' "${trace_id}" >&2
  exit 1
}
for test_case in "${cases[@]}"; do
  # SMS_TEST_REPO_ROOT tells a case which repository owns it. These cases are
  # row-local to this repository, so it is correct here, but any case that
  # delegates onward (`bash "${repo_root}/tests/<trace>.sh"`) inherits the
  # value. When the delegated entrypoint lives in a sibling repository that
  # symlinks its entrypoints back to a shared dispatcher, the inherited value
  # points the delegation at this repository's dispatcher instead, which
  # re-enters the same case: FS-380-HDS-010-SDS-010-SMS-010 and
  # FS-800-HDS-020-SDS-040-SMS-010 called each other without bound. Do not
  # leak the root into cases that run other repositories' entrypoints; each
  # dispatcher sets it for the cases it owns.
  SMS_TEST_REPO_ROOT="${repo_root}" SMS_TEST_TRACE_ID="${trace_id}" bash "${test_case}"
done
