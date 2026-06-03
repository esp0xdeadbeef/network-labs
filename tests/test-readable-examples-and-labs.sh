#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
hits_file="$(mktemp)"
trap 'rm -f "${hits_file}"' EXIT

for root in examples labs HAT; do
  [[ -d "${repo_root}/${root}" ]] || continue

  rg -n 'builtins\.fromJSON|import +(\.\./|"\.\./)|=\s*(\.\./|"\.\./)' \
    "${repo_root}/${root}" \
    --glob '*.nix' \
    >"${hits_file}" || true

  if [[ -s "${hits_file}" ]]; then
    cat >&2 <<'EOF'
FATAL network-labs examples/labs/HAT readability contract failed.

Rules:
  - examples/, labs/, and HAT/ must be readable Nix attrsets, not builtins.fromJSON blobs
  - examples/, labs/, and HAT/ must not import parent-relative ../ paths
  - tests/ may use fixtures/helpers; this guard intentionally skips tests/

Reason:
  Lab, example, and HAT inputs are model fixtures. They must be reviewable by
  humans and smaller agents without evaluating generated JSON or chasing
  cross-folder imports.

Current offending lines:
EOF
    cat "${hits_file}" >&2
    exit 1
  fi
done

echo "PASS readable-examples-and-labs"
