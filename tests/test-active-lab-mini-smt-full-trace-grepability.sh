#!/usr/bin/env bash
# GAMP-SCOPE: active-lab mini SMT trace-ID grepability guard; not HAT/SAT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
runner="${repo_root}/tests/run-active-lab-mini-smt.sh"
manifest="${repo_root}/GAMP/SMT/mini-smt/tests.nix"

fail() {
  echo "FAIL active-lab-mini-smt-full-trace-grepability: $*" >&2
  exit 1
}

full_trace_re='FS-[0-9]+-HDS-[0-9]+-SDS-[0-9]+-SMS-[0-9]+'
dotted_trace_re='FS-[0-9]+[.][0-9]+[.][0-9]+'

list_output="$("${runner}" --list)"

printf '%s\n' "${list_output}" | rg -q "${full_trace_re}" \
  || fail "runner --list must emit full FS/HDS/SDS/SMS trace IDs"

if printf '%s\n' "${list_output}" | rg -q "${dotted_trace_re}"; then
  fail "runner --list emitted dotted non-grepable trace aliases"
fi

source_output="$("${runner}" --source FS-400-HDS-010-SDS-010-SMS-010)"
printf '%s\n' "${source_output}" | rg -q '^traceId=FS-400-HDS-010-SDS-010-SMS-010$' \
  || fail "runner --source must emit concrete full traceId"
printf '%s\n' "${source_output}" | rg -q 'FS-400[.]010[.]010' \
  && fail "runner --source emitted dotted FS-400 alias"

rg -q -F 'WORKDIR ${trace_id}: ${case_dir}' "${runner}" \
  || fail "runner must print full-trace workdir locations"
rg -q -F 'RUNROOT ${trace_id}: ${run_root}' "${runner}" \
  || fail "runner must print full-trace persistent runroot locations"
rg -q -F 'SELECT ${trace_id}: scripts/select-current-lab.sh SMT ${trace_id}' "${runner}" \
  || fail "runner must select the requested full trace before runtime/build checks"
rg -q -F '${case_dir}/${trace_id}.select-current-lab.log' "${runner}" \
  || fail "runner selection log filename must include full trace ID"
rg -q -F '${case_dir}/${trace_id}.script.log' "${runner}" \
  || fail "runner script log filename must include full trace ID"
rg -q -F '${case_dir}/${trace_id}.offline.log' "${runner}" \
  || fail "runner offline log filename must include full trace ID"
rg -q -F '${case_dir}/${trace_id}.pinned-nixos.log' "${runner}" \
  || fail "runner pinned log filename must include full trace ID"
rg -q -F 'LOGS ${trace_id}: select=${select_log} script=${script_log} offline=${offline_log} pinned=${pinned_log}' "${runner}" \
  || fail "runner must print full-trace log locations"
if rg -n "trap 'rm -rf" "${runner}" >&2; then
  fail "runner must keep trace-labeled logs after exit for grepability"
fi

if rg -n "${dotted_trace_re}" "${runner}" "${manifest}" >&2; then
  fail "runner or manifest contains dotted non-grepable trace aliases"
fi

if rg -n 'replace[[:space:]]*[(].*-HDS-.*[.]|replace[[:space:]]*[(].*-SDS-.*[.]' "${runner}" "${manifest}" >&2; then
  fail "runner or manifest may shorten trace IDs"
fi

echo "PASS active-lab-mini-smt-full-trace-grepability"
