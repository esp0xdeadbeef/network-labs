#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
manifest_file="${repo_root}/GAMP/SMT/mini-smt/tests.nix"

list_keys() {
  nix eval --impure --raw --expr \
    "let manifest = import ${manifest_file}; in builtins.concatStringsSep \"\n\" (builtins.attrNames manifest.tests)"
  printf '\n'
}

list_ids() {
  nix eval --impure --raw --expr \
    "let
       manifest = import ${manifest_file};
       keys = builtins.attrNames manifest.tests;
     in
       builtins.concatStringsSep \"\n\" (map (key: (builtins.getAttr key manifest.tests).traceId) keys)"
  printf '\n'
}

trace_for_key() {
  local key="$1"
  nix eval --impure --raw --expr \
    "let manifest = import ${manifest_file}; in manifest.tests.\"${key}\".traceId"
}

key_for_trace() {
  local trace="$1"
  nix eval --impure --raw --expr \
    "let
       manifest = import ${manifest_file};
       keys = builtins.attrNames manifest.tests;
       matches = builtins.filter (key: (builtins.getAttr key manifest.tests).traceId == \"${trace}\") keys;
     in
       if matches == [ ] then \"\" else builtins.head matches"
}

key_exists() {
  local requested="$1"
  local known
  while IFS= read -r known || [[ -n "${known}" ]]; do
    [[ "${known}" == "${requested}" ]] && return 0
  done < <(list_keys)
  return 1
}

resolve_key() {
  local requested="$1"
  local key trace

  key="$(key_for_trace "${requested}")"
  if [[ -n "${key}" ]]; then
    printf '%s\n' "${key}"
    return 0
  fi

  if key_exists "${requested}"; then
    trace="$(trace_for_key "${requested}")"
    if [[ "${NETWORK_LABS_ALLOW_LEGACY_MINI_SMT_ALIAS:-0}" == "1" ]]; then
      printf '%s\n' "${requested}"
      return 0
    fi
    echo "Alias mini-SMT selector rejected: ${requested}" >&2
    echo "Use full trace ID: ${trace}" >&2
    return 2
  fi

  echo "Unknown active-lab SMT trace ID: ${requested}" >&2
  echo "Known trace IDs:" >&2
  list_ids >&2
  return 2
}

script_for() {
  local key="$1"
  nix eval --impure --raw --expr \
    "let manifest = import ${manifest_file}; in manifest.tests.\"${key}\".script"
}

source_kind_for() {
  local key="$1"
  nix eval --impure --raw --expr \
    "let manifest = import ${manifest_file}; entry = manifest.tests.\"${key}\"; in entry.source.kind or \"unspecified\""
}

intent_path_for() {
  local key="$1"
  nix eval --impure --raw --expr \
    "let manifest = import ${manifest_file}; source = manifest.tests.\"${key}\".source or {}; in if source ? intent then toString source.intent else \"\""
}

cpm_path_for() {
  local key="$1"
  nix eval --impure --raw --expr \
    "let manifest = import ${manifest_file}; source = manifest.tests.\"${key}\".source or {}; in if source ? cpm then toString source.cpm else \"\""
}

run_script_validator() {
  local trace_id="$1"
  local key="$2"
  local source_kind="$3"
  local intent_path="$4"
  local cpm_path="$5"
  local script_path="$6"

  MINI_SMT_ID="${trace_id}" \
    MINI_SMT_MANIFEST_KEY="${key}" \
    MINI_SMT_SOURCE_KIND="${source_kind}" \
    MINI_SMT_INTENT_PATH="${intent_path}" \
    MINI_SMT_CPM_PATH="${cpm_path}" \
    bash "${script_path}"
}

run_offline_verifier() {
  local trace_id="$1"
  local source_kind="$2"
  local work_dir="$3"

  if [[ "${MINI_SMT_OFFLINE_VERIFY:-1}" == "0" ]]; then
    echo "SKIP ${trace_id}: offline compiler/NFM/CPM verifier disabled"
    return 0
  fi

  if [[ "${source_kind}" != "intent-source" ]]; then
    echo "SKIP ${trace_id}: offline compiler/NFM/CPM verifier requires intent-source, got ${source_kind}"
    return 0
  fi

  local cpm_root
  cpm_root="${NETWORK_CONTROL_PLANE_MODEL_ROOT:-${NETWORK_CPM_REPO:-${repo_root}/../network-control-plane-model}}"
  [[ -d "${cpm_root}" ]] || {
    echo "Offline verifier missing network-control-plane-model repo: ${cpm_root}" >&2
    return 1
  }

  mkdir -p "${work_dir}"
  ln -s "${repo_root}/GAMP" "${work_dir}/GAMP"

  NETWORK_LABS_CURRENT_LAB_DIR="${work_dir}/current-lab" \
    NETWORK_FORWARDING_MODEL_ROOT="${NETWORK_FORWARDING_MODEL_ROOT:-${repo_root}/../network-forwarding-model}" \
    bash "${repo_root}/scripts/select-current-lab.sh" SMT "${trace_id}" >/dev/null

  local inventory
  for inventory in inventory-nixos.nix inventory-clab.nix; do
    [[ -f "${work_dir}/current-lab/${inventory}" ]] || continue
    echo "OFFLINE ${trace_id}: compiler/NFM/CPM ${inventory}"
    nix run --show-trace --no-warn-dirty --no-write-lock-file \
      "path:${cpm_root}#compile-and-build-control-plane-model" -- \
      "${work_dir}/current-lab/intent.nix" \
      "${work_dir}/current-lab/${inventory}" \
      "${work_dir}/${inventory%.nix}.cpm.json" >/dev/null
  done

  echo "PASS ${trace_id}: offline compiler/NFM/CPM verifier"
}

run_pinned_active_lab_build() {
  local trace_id="$1"
  local work_dir="$2"

  if [[ "${MINI_SMT_PINNED_NIXOS_BUILD:-1}" == "0" ]]; then
    echo "SKIP ${trace_id}: pinned s-router-nixos build disabled"
    return 0
  fi

  local nixos_root attr out_link
  nixos_root="${NETWORK_LABS_NIXOS_REPO:-${NIXOS_REPO:-${repo_root}/../nixos}}"
  attr="${MINI_SMT_PINNED_NIXOS_ATTR:-nixosConfigurations.s-router-nixos.config.system.build.nixos-shell}"
  out_link="${work_dir}/s-router-nixos-pinned"

  [[ -f "${nixos_root}/flake.nix" ]] || {
    echo "FAIL ${trace_id}: pinned s-router-nixos build missing NixOS flake: ${nixos_root}" >&2
    return 1
  }
  [[ -f "${nixos_root}/flake.lock" ]] || {
    echo "FAIL ${trace_id}: pinned s-router-nixos build missing flake.lock: ${nixos_root}/flake.lock" >&2
    return 1
  }

  echo "PINNED ${trace_id}: nixos .#${attr} using ${nixos_root}/flake.lock"
  (
    cd "${nixos_root}"
    nix build --show-trace --no-write-lock-file --impure \
      --out-link "${out_link}" \
      ".#${attr}" >/dev/null
  )
  echo "PASS ${trace_id}: pinned s-router-nixos build"
}

usage() {
  cat <<'EOF'
Usage:
  tests/run-active-lab-mini-smt.sh --list
  tests/run-active-lab-mini-smt.sh --source <FS-...-SMS-... trace-id>
  tests/run-active-lab-mini-smt.sh all
  tests/run-active-lab-mini-smt.sh <FS-...-SMS-... trace-id> [<FS-...-SMS-... trace-id>...]
EOF
}

if [[ "$#" -eq 0 ]]; then
  usage >&2
  exit 2
fi

if [[ "$1" == "--list" ]]; then
  list_ids
  exit 0
fi

if [[ "$1" == "--source" ]]; then
  if [[ "$#" -ne 2 ]]; then
    usage >&2
    exit 2
  fi
  requested="$2"
  key="$(resolve_key "${requested}")"
  trace_id="$(trace_for_key "${key}")"
  echo "traceId=${trace_id}"
  echo "kind=$(source_kind_for "${key}")"
  intent_path="$(intent_path_for "${key}")"
  cpm_path="$(cpm_path_for "${key}")"
  [[ -z "${intent_path}" ]] || echo "intent=${intent_path}"
  [[ -z "${cpm_path}" ]] || echo "cpm=${cpm_path}"
  exit 0
fi

if [[ "$1" == "all" ]]; then
  mapfile -t selected < <(list_keys)
else
  selected=()
  for requested in "$@"; do
    selected+=("$(resolve_key "${requested}")")
  done
fi

run_root="$(mktemp -d)"
trap 'rm -rf "${run_root}"' EXIT

for key in "${selected[@]}"; do
  trace_id="$(trace_for_key "${key}")"
  script="$(script_for "${key}")"
  script_path="${repo_root}/${script}"

  if [[ ! -x "${script_path}" ]]; then
    echo "Mini SMT script is missing or not executable: ${script}" >&2
    exit 1
  fi

  echo "RUN ${trace_id}: ${script}"
  source_kind="$(source_kind_for "${key}")"
  intent_path="$(intent_path_for "${key}")"
  cpm_path="$(cpm_path_for "${key}")"
  case_dir="${run_root}/${trace_id}"
  mkdir -p "${case_dir}"
  script_log="${case_dir}/script.log"
  offline_log="${case_dir}/offline.log"
  pinned_log="${case_dir}/pinned-nixos.log"
  echo "WORKDIR ${trace_id}: ${case_dir}"
  echo "LOGS ${trace_id}: script=${script_log} offline=${offline_log} pinned=${pinned_log}"

  run_script_validator \
    "${trace_id}" \
    "${key}" \
    "${source_kind}" \
    "${intent_path}" \
    "${cpm_path}" \
    "${script_path}" >"${script_log}" 2>&1 &
  script_pid=$!

  run_offline_verifier \
    "${trace_id}" \
    "${source_kind}" \
    "${case_dir}/offline-current-lab" >"${offline_log}" 2>&1 &
  offline_pid=$!

  run_pinned_active_lab_build \
    "${trace_id}" \
    "${case_dir}/pinned-nixos" >"${pinned_log}" 2>&1 &
  pinned_pid=$!

  script_rc=0
  offline_rc=0
  pinned_rc=0
  wait "${script_pid}" || script_rc=$?
  wait "${offline_pid}" || offline_rc=$?
  wait "${pinned_pid}" || pinned_rc=$?

  if ((script_rc == 0)); then
    cat "${script_log}"
  else
    cat "${script_log}" >&2
  fi

  if ((offline_rc == 0)); then
    cat "${offline_log}"
  else
    cat "${offline_log}" >&2
  fi

  if ((pinned_rc == 0)); then
    cat "${pinned_log}"
  else
    cat "${pinned_log}" >&2
  fi

  if ((script_rc != 0 || offline_rc != 0 || pinned_rc != 0)); then
    echo "FAIL ${trace_id}: mini-SMT script rc=${script_rc}, offline verifier rc=${offline_rc}, pinned s-router-nixos build rc=${pinned_rc}" >&2
    exit 1
  fi
done
