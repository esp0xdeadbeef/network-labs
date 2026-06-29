#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
manifest_file="${repo_root}/GAMP/SMT/mini-smt/tests.nix"

list_ids() {
  nix eval --impure --raw --expr \
    "let manifest = import ${manifest_file}; in builtins.concatStringsSep \"\n\" (builtins.attrNames manifest.tests)"
  printf '\n'
}

script_for() {
  local id="$1"
  nix eval --impure --raw --expr \
    "let manifest = import ${manifest_file}; in manifest.tests.\"${id}\".script"
}

source_kind_for() {
  local id="$1"
  nix eval --impure --raw --expr \
    "let manifest = import ${manifest_file}; entry = manifest.tests.\"${id}\"; in entry.source.kind or \"unspecified\""
}

intent_path_for() {
  local id="$1"
  nix eval --impure --raw --expr \
    "let manifest = import ${manifest_file}; source = manifest.tests.\"${id}\".source or {}; in if source ? intent then toString source.intent else \"\""
}

cpm_path_for() {
  local id="$1"
  nix eval --impure --raw --expr \
    "let manifest = import ${manifest_file}; source = manifest.tests.\"${id}\".source or {}; in if source ? cpm then toString source.cpm else \"\""
}

id_exists() {
  local requested="$1"
  local known
  while IFS= read -r known || [[ -n "${known}" ]]; do
    [[ "${known}" == "${requested}" ]] && return 0
  done < <(list_ids)
  return 1
}

usage() {
  cat <<'EOF'
Usage:
  tests/run-active-lab-mini-smt.sh --list
  tests/run-active-lab-mini-smt.sh --source <mini-smt-id>
  tests/run-active-lab-mini-smt.sh all
  tests/run-active-lab-mini-smt.sh <mini-smt-id> [<mini-smt-id>...]
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
  id="$2"
  if ! id_exists "${id}"; then
    echo "Unknown mini SMT id: ${id}" >&2
    echo "Known ids:" >&2
    list_ids >&2
    exit 2
  fi
  echo "id=${id}"
  echo "kind=$(source_kind_for "${id}")"
  intent_path="$(intent_path_for "${id}")"
  cpm_path="$(cpm_path_for "${id}")"
  [[ -z "${intent_path}" ]] || echo "intent=${intent_path}"
  [[ -z "${cpm_path}" ]] || echo "cpm=${cpm_path}"
  exit 0
fi

if [[ "$1" == "all" ]]; then
  mapfile -t selected < <(list_ids)
else
  selected=("$@")
fi

for id in "${selected[@]}"; do
  if ! id_exists "${id}"; then
    echo "Unknown mini SMT id: ${id}" >&2
    echo "Known ids:" >&2
    list_ids >&2
    exit 2
  fi

  script="$(script_for "${id}")"
  script_path="${repo_root}/${script}"

  if [[ ! -x "${script_path}" ]]; then
    echo "Mini SMT script is missing or not executable: ${script}" >&2
    exit 1
  fi

  echo "RUN ${id}: ${script}"
  source_kind="$(source_kind_for "${id}")"
  intent_path="$(intent_path_for "${id}")"
  cpm_path="$(cpm_path_for "${id}")"
  MINI_SMT_ID="${id}" \
    MINI_SMT_SOURCE_KIND="${source_kind}" \
    MINI_SMT_INTENT_PATH="${intent_path}" \
    MINI_SMT_CPM_PATH="${cpm_path}" \
    bash "${script_path}"
done
