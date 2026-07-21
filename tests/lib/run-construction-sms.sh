#!/usr/bin/env bash
set -euo pipefail

helper_path="$(readlink -f "${BASH_SOURCE[0]}")"
repo_root="$(cd "$(dirname "${helper_path}")/../.." && pwd)"
workspace_root="${NETWORK_WORKSPACE_ROOT:-$(cd "${repo_root}/.." && pwd)}"
invoked_name="$(basename "$0" .sh)"
trace_id="${1:-${invoked_name}}"

[[ "${trace_id}" == FS-*-HDS-*-SDS-*-SMS-* ]] || {
  printf 'usage: %s <full-trace-id>\n' "$0" >&2
  exit 64
}

local_case_root="${repo_root}/tests/lib/${trace_id}"
run_count=0

if [[ -d "${local_case_root}" ]] \
  && find "${local_case_root}" -maxdepth 1 \( -type f -o -type l \) -name '*.sh' -print -quit | grep -q .; then
  printf 'RUN %s: %s\n' "${trace_id}" "${repo_root}/tests/lib/run-sms-cases.sh"
  SMS_TEST_TRACE_ID="${trace_id}" bash "${repo_root}/tests/lib/run-sms-cases.sh" "${trace_id}"
  run_count=$((run_count + 1))
fi

mapfile -t candidates < <(
  for repository in "${workspace_root}"/network-*; do
    [[ -d "${repository}/tests" ]] || continue
    [[ "$(realpath "${repository}")" != "$(realpath "${repo_root}")" ]] || continue
    candidate="${repository}/tests/${trace_id}.sh"
    [[ -x "${candidate}" ]] || continue
    [[ "$(readlink -f "${candidate}")" != "${helper_path}" ]] || continue
    printf '%s\n' "${candidate}"
  done | LC_ALL=C sort -u
)

((${#candidates[@]} > 0 || run_count > 0)) || {
  printf 'FAIL %s: no canonical construction implementation found under %s/network-*/tests\n' \
    "${trace_id}" "${workspace_root}" >&2
  exit 1
}

for candidate in "${candidates[@]}"; do
  printf 'RUN %s: %s\n' "${trace_id}" "${candidate}"
  candidate_repo="$(cd "$(dirname "${candidate}")/.." && pwd)"
  (
    cd "${candidate_repo}"
    NETWORK_LABS_PATH="${workspace_root}/network-labs" \
      NETWORK_REPO_DIRECT_TEST_OK=1 \
      SMS_TEST_TRACE_ID="${trace_id}" \
      bash "${candidate}"
  )
  run_count=$((run_count + 1))
done

printf 'PASS %s: %d canonical construction implementation(s) completed\n' \
  "${trace_id}" "${run_count}"
