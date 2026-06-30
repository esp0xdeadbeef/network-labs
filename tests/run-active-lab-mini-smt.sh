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
  MINI_SMT_ID="${trace_id}" \
    MINI_SMT_MANIFEST_KEY="${key}" \
    MINI_SMT_SOURCE_KIND="${source_kind}" \
    MINI_SMT_INTENT_PATH="${intent_path}" \
    MINI_SMT_CPM_PATH="${cpm_path}" \
    bash "${script_path}"
done
