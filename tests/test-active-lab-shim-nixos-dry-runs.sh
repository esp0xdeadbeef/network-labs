#!/usr/bin/env bash
# GAMP-SCOPE: active-lab source-to-NixOS dry-run compile sweep; not live HAT/SAT runtime evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
nixos_repo="${NIXOS_REPO:-/home/deadbeef/github/nixos}"
selector="${repo_root}/scripts/select-current-lab.sh"
current_dir="${repo_root}/current-lab"
log_root="${LOG_ROOT:-$(mktemp -d /tmp/network-labs-active-lab-shim-dry-runs.XXXXXX)}"
restore_dir="$(mktemp -d)"

targets=(
  s-router-clab
  s-router-nixos
  s-router-test-clients
)

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

mapfile -t selector_rows < <("${selector}" --list | awk '
  $1 == "SMT" { print $1 "\t" $2 }
  $1 == "SIT" { print $1 "\t" $2 }
  $1 == "HAT" { print $1 "\t" $2 }
  $1 == "SAT" { print $1 "\t" "SAT" }
')

((${#selector_rows[@]} > 0)) || fail "selector did not expose runnable rows"

failures=0
total=0

echo "LOG_ROOT=${log_root}"

for row in "${selector_rows[@]}"; do
  IFS=$'\t' read -r kind value <<<"${row}"
  label="${kind} ${value}"
  select_source "${kind}" "${value}"

  for target in "${targets[@]}"; do
    total=$((total + 1))
    safe_label="$(sanitize "${kind}_${value}_${target}")"
    log_file="${log_root}/${safe_label}.log"
    attr="${nixos_repo}#nixosConfigurations.${target}.config.system.build.toplevel"

    if nix build --dry-run --show-trace \
      --override-input network-labs "path:${repo_root}" \
      "${attr}" >"${log_file}" 2>&1; then
      printf 'PASS %s target=%s log=%s\n' "${label}" "${target}" "${log_file}"
    else
      failures=$((failures + 1))
      printf 'FAIL %s target=%s log=%s\n' "${label}" "${target}" "${log_file}" >&2
      tail -n 80 "${log_file}" >&2 || true
    fi
  done
done

if ((failures > 0)); then
  fail "${failures}/${total} dry-run compile checks failed; logs in ${log_root}"
fi

printf 'PASS active-lab-shim-nixos-dry-runs: selectors=%s targets=%s checks=%s log_root=%s\n' \
  "${#selector_rows[@]}" \
  "${#targets[@]}" \
  "${total}" \
  "${log_root}"
