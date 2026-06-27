#!/usr/bin/env bash
# GAMP-ID: FS-960-HDS-010-SDS-010-SMS-080
# GAMP-SCOPE: test infrastructure seed entrypoint for network-labs
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
seed_dir="${NETWORK_LABS_SEED_DIR:-/tmp/network-labs-seed}"
force="${NETWORK_FORCE_RESEED:-0}"

usage() {
  cat >&2 <<'EOF'
Usage: scripts/seed.sh [--output DIR] [--force]

Creates the standard network-labs test seed under /tmp/network-labs-seed by
evaluating the repo-owned lab index and copying representative example inputs.

Environment:
  NETWORK_FORCE_RESEED=1  Regenerate even when provenance matches HEAD.
  NETWORK_LABS_SEED_DIR   Override seed output directory.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --output)
      seed_dir="$2"
      shift 2
      ;;
    --force)
      force=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "seed.sh: unknown option: $1" >&2
      usage
      exit 2
      ;;
  esac
done

head_commit="$(git -C "${repo_root}" rev-parse HEAD)"
provenance="${seed_dir}/PROVENANCE"

if [[ "${force}" != "1" && -s "${seed_dir}/labs.json" && -f "${provenance}" ]]; then
  if grep -qx "network-labs.commit=${head_commit}" "${provenance}"; then
    echo "seed.sh: /tmp seed is current for network-labs ${head_commit}"
    exit 0
  fi
fi

rm -rf "${seed_dir}"
mkdir -p "${seed_dir}/examples"

timestamp="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

echo "seed.sh: evaluating network-labs flake lab index"
nix eval \
  --extra-experimental-features 'nix-command flakes' \
  --json "path:${repo_root}#labs" \
  > "${seed_dir}/labs.json"

for example_dir in "${repo_root}/examples"/*; do
  [[ -d "${example_dir}" ]] || continue
  name="$(basename "${example_dir}")"
  out_dir="${seed_dir}/examples/${name}"
  mkdir -p "${out_dir}"

  for source_file in intent.nix inventory.nix inventory-nixos.nix inventory-clab.nix; do
    if [[ -f "${example_dir}/${source_file}" ]]; then
      cp "${example_dir}/${source_file}" "${out_dir}/${source_file}"
    fi
  done
done

{
  echo "trace=FS-960-HDS-010-SDS-010-SMS-080"
  echo "network-labs.repo=${repo_root}"
  echo "network-labs.commit=${head_commit}"
  echo "generated_at=${timestamp}"
  echo "seed_dir=${seed_dir}"
  echo "compiled_index=labs.json"
} > "${provenance}"

echo "seed.sh: wrote ${seed_dir}/labs.json"
echo "seed.sh: wrote ${provenance}"
