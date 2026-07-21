#!/usr/bin/env bash
# GAMP-ID: FS-981-HDS-010-SDS-010-SMS-030
# GAMP-SCOPE: deterministic SMS test-entrypoint discovery contract
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
agent_root="${NETWORK_CODEX_AGENT_ROOT:-${repo_root}/../network-codex-agent}"
workspace_root="${NETWORK_WORKSPACE_ROOT:-$(cd "${repo_root}/.." && pwd)}"
manifest="${repo_root}/GAMP/SMT/mini-smt/tests.nix"
runner="${repo_root}/tests/run-active-lab-mini-smt.sh"
live_dispatcher="${agent_root}/scripts/helpers/run-live-sms.sh"
construction_dispatcher="${repo_root}/tests/lib/run-sms-cases.sh"
cross_repo_dispatcher="${repo_root}/tests/lib/run-construction-sms.sh"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  printf 'FAIL FS-981-HDS-010-SDS-010-SMS-030: %s\n' "$1" >&2
  exit 1
}

must_fail_with() {
  local label="$1"
  local diagnostic="$2"
  shift 2
  if "$@" >"${tmp_dir}/${label}.out" 2>"${tmp_dir}/${label}.err"; then
    fail "${label} unexpectedly passed"
  fi
  grep -F "${diagnostic}" "${tmp_dir}/${label}.err" >/dev/null \
    || fail "${label} did not emit ${diagnostic}"
}

case_directory_has_test() {
  local case_directory="$1"
  [[ -d "${case_directory}" ]] \
    && find "${case_directory}" -maxdepth 1 \( -type f -o -type l \) \
      -name '*.sh' -print -quit | grep -q .
}

trace_has_construction_case() {
  local trace_id="$1"
  local repository

  for repository in "${workspace_root}"/network-*; do
    case_directory_has_test "${repository}/tests/lib/${trace_id}" && return 0
  done
  return 1
}

case_declares_trace() {
  local trace_id="$1"
  local case_path="$2"
  local declared_ids

  declared_ids="$(
    awk '/^#[[:space:]]*GAMP-ID:/ {
      for (i = 1; i <= NF; i++)
        if ($i ~ /^FS-[0-9]+-HDS-[0-9]+-SDS-[0-9]+-SMS-[0-9]+$/)
          print $i
    }' "${case_path}" | LC_ALL=C sort -u
  )"

  [[ -z "${declared_ids}" ]] && return 0
  if ! grep -Fx "${trace_id}" <<<"${declared_ids}" >/dev/null; then
    printf 'diagnostic.sms-test-case-trace-mismatch trace=%s case=%s declared=%s\n' \
      "${trace_id}" "${case_path}" "$(paste -sd, <<<"${declared_ids}")" >&2
    return 1
  fi
}

validate_repository_case_declarations() {
  local repository="$1"
  local -a case_paths=()

  mapfile -d '' case_paths < <(
    find "${repository}/tests/lib" -mindepth 2 -maxdepth 2 \
      \( -type f -o -type l \) -name '*.sh' -print0 2>/dev/null
  )
  ((${#case_paths[@]} == 0)) && return 0

  awk '
    function case_trace(path, parts, count) {
      count = split(path, parts, "/")
      return parts[count - 1]
    }
    /^#[[:space:]]*GAMP-ID:/ {
      trace = case_trace(FILENAME)
      if (trace !~ /^FS-[0-9]+-HDS-[0-9]+-SDS-[0-9]+-SMS-[0-9]+$/)
        next
      for (i = 1; i <= NF; i++) {
        if ($i ~ /^FS-[0-9]+-HDS-[0-9]+-SDS-[0-9]+-SMS-[0-9]+$/) {
          declared[FILENAME] = declared[FILENAME] (declared[FILENAME] == "" ? "" : ",") $i
          if ($i == trace)
            matched[FILENAME] = 1
        }
      }
    }
    END {
      failed = 0
      for (path in declared) {
        if (!matched[path]) {
          printf "diagnostic.sms-test-case-trace-mismatch trace=%s case=%s declared=%s\n", \
            case_trace(path), path, declared[path] > "/dev/stderr"
          failed = 1
        }
      }
      exit failed
    }
  ' "${case_paths[@]}"
}

nix eval --impure --json --file "${manifest}" >"${tmp_dir}/manifest.json"
jq -e '
    def has_runner_mapping:
      type == "object" and any(keys[]; test("^(script|liveScript|liveSitScript|aggregateScripts|templateTests|test)$"));
    [.. | objects | select(has_runner_mapping)] | length == 0
  ' "${tmp_dir}/manifest.json" >/dev/null \
  || fail "mini-SMT manifest contains an explicit runner mapping"

if rg -n \
  '^[[:space:]]*((script|test|command|templateTests|liveScript|liveSitScript|aggregateScripts)|[A-Za-z0-9_-]*(Command|Script|Test|Probe|Runner|Tests))[[:space:]]*=' \
  "${repo_root}/GAMP/SDS" "${repo_root}/GAMP/SMS" "${repo_root}/GAMP/SIT" "${repo_root}/GAMP/SMT" \
  --glob default.nix; then
  fail "controlled rows contain explicit runner mappings"
fi

mapfile -t noncanonical < <(
  find "${repo_root}/tests" "${agent_root}/scripts" -maxdepth 1 -type f -name '*.sh' -printf '%f\n' \
    | grep -E '^smt-live-FS-[0-9]+-HDS-[0-9]+-SDS-[0-9]+-SMS-[0-9]+.*\.sh$|^FS-[0-9]+-HDS-[0-9]+-SDS-[0-9]+-SMS-[0-9]+-.+\.sh$|^live-FS-[0-9]+-HDS-[0-9]+-SDS-[0-9]+-SMS-[0-9]+-.+\.sh$' \
    || true
)
((${#noncanonical[@]} == 0)) \
  || fail "noncanonical SMS entrypoints remain: ${noncanonical[*]}"

mapfile -t misplaced_live_cases < <(
  find "${repo_root}/tests/lib" \( -type f -o -type l \) -name '*live*.sh' -print \
    | LC_ALL=C sort
)
((${#misplaced_live_cases[@]} == 0)) \
  || fail "live SMS implementations must be resolved through scripts/live-<trace>.sh, not construction discovery: ${misplaced_live_cases[*]}"

for repository in "${workspace_root}"/network-*; do
  [[ -d "${repository}/tests" ]] || continue
  mapfile -t repository_noncanonical < <(
    find "${repository}/tests" -maxdepth 1 \( -type f -o -type l \) -name '*.sh' -printf '%f\n' \
      | grep -E '^FS-[0-9]+-HDS-[0-9]+-SDS-[0-9]+-SMS-[0-9]+-.+\.sh$|^(test-|run-|fs-).*(FS-|fs-?)[0-9]+.*SMS-[0-9]+.*\.sh$' \
      || true
  )
  ((${#repository_noncanonical[@]} == 0)) \
    || fail "noncanonical SMS entrypoints remain in ${repository}: ${repository_noncanonical[*]}"

  while IFS= read -r -d '' entrypoint; do
    [[ -L "${entrypoint}" ]] || fail "canonical construction entrypoint duplicates test code: ${entrypoint}"
    resolved_dispatcher="$(readlink -f "${entrypoint}")"
    case "${resolved_dispatcher}" in
      */tests/lib/run-sms-cases.sh|"${cross_repo_dispatcher}") ;;
      *) fail "canonical construction entrypoint has non-dispatcher target: ${entrypoint} -> ${resolved_dispatcher}" ;;
    esac
    entrypoint_trace="$(basename "${entrypoint}" .sh)"
    if [[ "${repository}" == "${repo_root}" ]]; then
      trace_has_construction_case "${entrypoint_trace}" \
        || fail "catalog construction entrypoint has no repository-owned case: ${entrypoint}"
    else
      case_directory_has_test "${repository}/tests/lib/${entrypoint_trace}" \
        || fail "repository construction entrypoint has no local case: ${entrypoint}"
    fi
  done < <(
    find "${repository}/tests" -maxdepth 1 -regextype posix-extended -type l \
      -regex '.*/FS-[0-9]+-HDS-[0-9]+-SDS-[0-9]+-SMS-[0-9]+\.sh' -print0
  )

  while IFS= read -r -d '' case_dir; do
    case_trace="$(basename "${case_dir}")"
    case_directory_has_test "${case_dir}" || continue
    [[ -L "${repository}/tests/${case_trace}.sh" ]] \
      || fail "case directory has no canonical symlink: ${case_dir}"

  done < <(
    find "${repository}/tests/lib" -mindepth 1 -maxdepth 1 -type d \
      -name 'FS-*-HDS-*-SDS-*-SMS-*' -print0 2>/dev/null
  )

  validate_repository_case_declarations "${repository}" \
    || fail "${repository} contains a case that declares a different GAMP-ID"
done

printf '#!/usr/bin/env bash\n# GAMP-ID: FS-999-HDS-999-SDS-999-SMS-999\nexit 0\n' \
  >"${tmp_dir}/mismatched-case.sh"
must_fail_with case-trace-mismatch diagnostic.sms-test-case-trace-mismatch \
  case_declares_trace FS-981-HDS-010-SDS-010-SMS-030 "${tmp_dir}/mismatched-case.sh"
printf '#!/usr/bin/env bash\n# GAMP-ID: FS-981-HDS-010-SDS-010-SMS-030\nexit 0\n' \
  >"${tmp_dir}/recovered-case.sh"
case_declares_trace FS-981-HDS-010-SDS-010-SMS-030 "${tmp_dir}/recovered-case.sh" \
  || fail "recovered exact case trace was rejected"

resolved_count=0
construction_count=0
live_count=0
: >"${tmp_dir}/resolved-traces"
while IFS=$'\t' read -r trace_id test_path; do
  [[ -n "${trace_id}" ]] || continue
  resolved_count=$((resolved_count + 1))
  case "$(basename "${test_path}")" in
    "${trace_id}.sh")
      construction_count=$((construction_count + 1))
      [[ -L "${test_path}" ]] || fail "${test_path} duplicates construction test code"
      resolved_dispatcher="$(readlink -f "${test_path}")"
      [[ "${resolved_dispatcher}" == "${construction_dispatcher}" \
        || "${resolved_dispatcher}" == "${cross_repo_dispatcher}" ]] \
        || fail "${test_path} does not resolve to a shared construction dispatcher"
      ;;
    "live-${trace_id}.sh")
      live_count=$((live_count + 1))
      [[ -L "${test_path}" ]] || fail "${test_path} duplicates live dispatcher code"
      [[ "$(readlink -f "${test_path}")" == "$(readlink -f "${live_dispatcher}")" ]] \
        || fail "${test_path} does not resolve to the shared live dispatcher"
      ;;
    *) fail "${trace_id} resolved to noncanonical path ${test_path}" ;;
  esac
  [[ -x "${test_path}" ]] || fail "${test_path} is not executable"
  printf '%s\n' "${trace_id}" >>"${tmp_dir}/resolved-traces"
done < <("${runner}" --test-paths)

manifest_count="$(jq -r '.tests | length' "${tmp_dir}/manifest.json")"
sort -u "${tmp_dir}/resolved-traces" -o "${tmp_dir}/resolved-traces"
jq -r '.tests | keys[]' "${tmp_dir}/manifest.json" \
  | sort -u >"${tmp_dir}/catalog-traces"
comm -23 "${tmp_dir}/catalog-traces" "${tmp_dir}/resolved-traces" >"${tmp_dir}/unimplemented-traces"
unimplemented_count=0
while IFS= read -r trace_id; do
  [[ -n "${trace_id}" ]] || continue
  unimplemented_count=$((unimplemented_count + 1))
  [[ "$(jq -r --arg trace_id "${trace_id}" '.tests[$trace_id].status // ""' "${tmp_dir}/manifest.json")" == "NOT OK" ]] \
    || fail "${trace_id} has no entrypoint but is not explicitly NOT OK"
done <"${tmp_dir}/unimplemented-traces"
[[ $((resolved_count + unimplemented_count)) == "${manifest_count}" ]] \
  || fail "catalog accounting mismatch: runnable=${resolved_count} unimplemented=${unimplemented_count} catalog=${manifest_count}"
((construction_count > 0)) || fail "catalog has no construction entrypoints"
((live_count > 0)) || fail "catalog has no live entrypoints"

seed_trace="$(head -n 1 "${tmp_dir}/unimplemented-traces")"
[[ -n "${seed_trace}" ]] || fail "seeded noncanonical case requires one explicit NOT OK row"
mkdir -p "${tmp_dir}/agent/scripts"
printf '#!/usr/bin/env bash\nexit 0\n' >"${tmp_dir}/agent/scripts/smt-live-${seed_trace}.sh"
chmod +x "${tmp_dir}/agent/scripts/smt-live-${seed_trace}.sh"
must_fail_with noncanonical diagnostic.sms-test-entrypoint-noncanonical \
  env NETWORK_CODEX_AGENT_ROOT="${tmp_dir}/agent" "${runner}" --test-path "${seed_trace}"

mv \
  "${tmp_dir}/agent/scripts/smt-live-${seed_trace}.sh" \
  "${tmp_dir}/agent/scripts/live-${seed_trace}.sh"
printf '#!/usr/bin/env bash\nexit 0\n' >"${tmp_dir}/agent/scripts/live-${seed_trace}-duplicate.sh"
chmod +x "${tmp_dir}/agent/scripts/live-${seed_trace}-duplicate.sh"
must_fail_with ambiguous diagnostic.sms-test-entrypoint-ambiguous \
  env NETWORK_CODEX_AGENT_ROOT="${tmp_dir}/agent" "${runner}" --test-path "${seed_trace}"

rm "${tmp_dir}/agent/scripts/live-${seed_trace}-duplicate.sh"
resolved="$({ NETWORK_CODEX_AGENT_ROOT="${tmp_dir}/agent" "${runner}" --test-path "${seed_trace}"; })"
[[ "${resolved}" == "${tmp_dir}/agent/scripts/live-${seed_trace}.sh" ]] \
  || fail "canonical recovery resolved to ${resolved}"

printf 'PASS FS-981-HDS-010-SDS-010-SMS-030: %s runnable and %s explicit NOT OK rows use trace-derived entrypoints across %s specs\n' \
  "${resolved_count}" "${unimplemented_count}" "${manifest_count}"
