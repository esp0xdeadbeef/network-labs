#!/usr/bin/env bash
# GAMP-ID: FS-270-HDS-010-SDS-010-SMS-040
# GAMP-SCOPE: software-module-test
# Focused test: validates selector handoff transport forwarding boundary
# at the owning CPM construction boundary.
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
trace_id="FS-270-HDS-010-SDS-010-SMS-040"
cpm_root="${NETWORK_CONTROL_PLANE_MODEL_ROOT:-${NETWORK_CPM_REPO:-${repo_root}/../network-control-plane-model}}"
cpm_test="${cpm_root}/tests/FS-270-HDS-010-SDS-010-SMS-040.sh"

echo "--- Source verification ---"
source_output="$("${repo_root}/tests/run-active-lab-mini-smt.sh" --source "${trace_id}")"
printf '%s\n' "${source_output}"

grep -Fxq "traceId=${trace_id}" <<<"${source_output}" || {
  echo "FAIL selector-handoff-focused-test: mini-SMT source did not resolve ${trace_id}" >&2
  exit 1
}
grep -Fxq "kind=construction-only" <<<"${source_output}" || {
  echo "FAIL selector-handoff-focused-test: ${trace_id} must remain construction-only" >&2
  exit 1
}
grep -Fxq "evidenceBoundary=construction-only" <<<"${source_output}" || {
  echo "FAIL selector-handoff-focused-test: ${trace_id} evidence boundary drifted" >&2
  exit 1
}
grep -Fxq "maxRuntimeTargets=0" <<<"${source_output}" || {
  echo "FAIL selector-handoff-focused-test: construction-only row must not declare runtime targets" >&2
  exit 1
}

[[ -x "${cpm_test}" ]] || {
  echo "FAIL selector-handoff-focused-test: missing owning CPM test ${cpm_test}" >&2
  exit 1
}

echo "--- Owning CPM selector-forwarding-rule validation ---"
NETWORK_LABS_PATH="${NETWORK_LABS_PATH:-${repo_root}}" \
NETWORK_REPO_DIRECT_TEST_OK="${NETWORK_REPO_DIRECT_TEST_OK:-1}" \
  bash "${cpm_test}"

echo "PASS selector-handoff-focused-test"
