#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
manifest_file="${repo_root}/active-lab/mini-smt/tests.nix"

list_ids() {
  nix eval --impure --raw --expr \
    "let manifest = import ${manifest_file}; in builtins.concatStringsSep \"\n\" (builtins.attrNames manifest.tests)"
}

script_for() {
  local id="$1"
  nix eval --impure --raw --expr \
    "let manifest = import ${manifest_file}; in manifest.tests.\"${id}\".script"
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
  bash "${script_path}"
done
