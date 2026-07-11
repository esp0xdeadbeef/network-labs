#!/usr/bin/env bash
# GAMP-SCOPE: active-lab source-to-NixOS dry-run compile sweep; not live HAT/SAT runtime evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
nixos_repo="${NIXOS_REPO:-/home/deadbeef/github/nixos}"
selector="${repo_root}/scripts/select-current-lab.sh"
current_dir="${repo_root}/current-lab"
log_root="${LOG_ROOT:-$(mktemp -d /tmp/network-labs-active-lab-shim-dry-runs.XXXXXX)}"
restore_dir="$(mktemp -d)"
scope="${ACTIVE_LAB_SHIM_DRY_RUN_SCOPE:-bounded}"
target_words="${ACTIVE_LAB_SHIM_DRY_RUN_TARGETS:-s-router-clab s-router-nixos s-router-test-clients}"
dry_run_timeout_seconds="${ACTIVE_LAB_SHIM_DRY_RUN_TIMEOUT_SECONDS:-600}"

read -r -a targets <<<"${target_words}"

fail() {
  echo "FAIL active-lab-shim-nixos-dry-runs: $*" >&2
  exit 1
}

restore_current_lab() {
  find "${current_dir}" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
  cp -a "${restore_dir}/." "${current_dir}/"
}

cleanup() {
  restore_current_lab
  rm -rf "${restore_dir}"
}
trap cleanup EXIT

[[ -x "${selector}" ]] || fail "selector script missing or not executable: ${selector}"
[[ -d "${current_dir}" ]] || fail "current-lab directory missing: ${current_dir}"
[[ -d "${nixos_repo}" ]] || fail "NixOS repo missing: ${nixos_repo}"
[[ "${scope}" == "bounded" || "${scope}" == "all" ]] || fail "unknown scope '${scope}'; use ACTIVE_LAB_SHIM_DRY_RUN_SCOPE=bounded|all"
((${#targets[@]} > 0)) || fail "no NixOS targets selected"
[[ "${dry_run_timeout_seconds}" =~ ^[1-9][0-9]*$ ]] || fail "timeout must be a positive integer number of seconds: ${dry_run_timeout_seconds}"

cp -a "${current_dir}/." "${restore_dir}/"
mkdir -p "${log_root}"

sanitize() {
  printf '%s' "$1" | tr ' /:' '___'
}

select_source() {
  local kind="$1"
  local value="${2:-}"
  case "${kind}" in
    SMT)
      "${selector}" SMT "${value}" >/dev/null
      ;;
    SIT)
      "${selector}" SIT "${value}" >/dev/null
      ;;
    HAT)
      "${selector}" HAT "${value}" >/dev/null
      ;;
    SAT)
      "${selector}" SAT >/dev/null
      ;;
    *)
      fail "unknown selector kind: ${kind}"
      ;;
  esac
}

mapfile -t all_selector_rows < <("${selector}" --list | awk '
  $1 == "SMT" { print $1 "\t" $2 }
  $1 == "SIT" { print $1 "\t" $2 }
  $1 == "HAT" { print $1 "\t" $2 }
  $1 == "SAT" { print $1 "\t" "SAT" }
')

((${#all_selector_rows[@]} > 0)) || fail "selector did not expose runnable rows"

find_selector_row() {
  local want_kind="$1"
  local want_value="$2"
  local row kind value

  for row in "${all_selector_rows[@]}"; do
    IFS=$'\t' read -r kind value <<<"${row}"
    if [[ "${kind}" == "${want_kind}" && "${value}" == "${want_value}" ]]; then
      printf '%s\n' "${row}"
      return 0
    fi
  done

  return 1
}

add_required_selector_row() {
  local row

  row="$(find_selector_row "$1" "$2")" || fail "required bounded selector row missing: $1 $2"
  selector_rows+=("${row}")
}

selector_rows=()

case "${scope}" in
  bounded)
    # FS-940 requires a focused warm-cache check before broad repository sweeps
    # or live SAT/HAT loops become the first discovery surface.
    add_required_selector_row SAT SAT
    add_required_selector_row HAT emulated-isp-residential-testnet
    add_required_selector_row SMT FS-010-HDS-010-SDS-010-SMS-010
    add_required_selector_row SIT FS-010-HDS-010-SDS-010
    ;;
  all)
    selector_rows=("${all_selector_rows[@]}")
    ;;
esac

failures=0
total=0

echo "LOG_ROOT=${log_root}"
echo "ACTIVE_LAB_SHIM_DRY_RUN_SCOPE=${scope}"
echo "ACTIVE_LAB_SHIM_DRY_RUN_TARGETS=${targets[*]}"

for row in "${selector_rows[@]}"; do
  IFS=$'\t' read -r kind value <<<"${row}"
  label="${kind} ${value}"
  select_source "${kind}" "${value}"

  for target in "${targets[@]}"; do
    total=$((total + 1))
    safe_label="$(sanitize "${kind}_${value}_${target}")"
    log_file="${log_root}/${safe_label}.log"
    attr="${nixos_repo}#nixosConfigurations.${target}.config.system.build.toplevel"

    if timeout --foreground "${dry_run_timeout_seconds}" nix build --dry-run --show-trace \
      --override-input network-labs "path:${repo_root}" \
      "${attr}" >"${log_file}" 2>&1; then
      printf 'PASS %s target=%s log=%s\n' "${label}" "${target}" "${log_file}"
    else
      status=$?
      failures=$((failures + 1))
      printf 'FAIL %s target=%s log=%s\n' "${label}" "${target}" "${log_file}" >&2
      if [[ "${status}" -eq 124 ]]; then
        printf 'TIMEOUT %s target=%s after=%ss\n' "${label}" "${target}" "${dry_run_timeout_seconds}" >&2
      fi
      tail -n 80 "${log_file}" >&2 || true
    fi
  done
done

if ((failures > 0)); then
  fail "${failures}/${total} dry-run compile checks failed; logs in ${log_root}"
fi

printf 'PASS active-lab-shim-nixos-dry-runs: scope=%s selectors=%s targets=%s checks=%s timeout=%ss log_root=%s\n' \
  "${scope}" \
  "${#selector_rows[@]}" \
  "${#targets[@]}" \
  "${total}" \
  "${dry_run_timeout_seconds}" \
  "${log_root}"
