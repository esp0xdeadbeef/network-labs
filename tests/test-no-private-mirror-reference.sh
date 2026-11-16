#!/usr/bin/env bash
# GAMP-SCOPE: repository hygiene; no private-repository names in public trees
#
# A private repository's name must not appear in any public repository, in code,
# tests, generated rows, or spec files. The name is assembled at runtime so this
# guard never contains the literal it forbids.
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
workspace_root="${NETWORK_WORKSPACE_ROOT:-$(cd "${repo_root}/.." && pwd)}"

head="network"
tail="codex-agent"
private_name="${head}-${tail}"

self_path="$(readlink -f "${BASH_SOURCE[0]}")"

fail() {
  echo "FAIL no-private-mirror-reference: $*" >&2
  exit 1
}

# Public checkouts: this repository plus every sibling that is not the private
# mirror itself.
mapfile -t repositories < <(
  printf '%s\n' "${repo_root}"
  for candidate in "${workspace_root}"/network-*/; do
    candidate="${candidate%/}"
    [[ -d "${candidate}/.git" ]] || continue
    [[ "$(basename "${candidate}")" == "${private_name}" ]] && continue
    printf '%s\n' "${candidate}"
  done | LC_ALL=C sort -u
)

violations=0
for repository in "${repositories[@]}"; do
  mapfile -t hits < <(
    rg -n --hidden --no-messages --glob '!**/.git/**' --glob '!*.lock' \
      --fixed-strings "${private_name}" "${repository}" \
      | grep -v -F "${self_path}:" || true
  )
  if ((${#hits[@]} > 0)); then
    for hit in "${hits[@]}"; do
      location="${hit%%:*}"
      echo "PRIVATE_REFERENCE: ${location#"${workspace_root}/"} (line $(echo "${hit}" | cut -d: -f2))" >&2
    done
    violations=$((violations + ${#hits[@]}))
  fi

  # A public tree must not carry a GitHub token or a workflow secret that
  # fetches a private repository.
  mapfile -t token_hits < <(
    rg -n --hidden --no-messages --glob '!**/.git/**' \
      'ghp_[A-Za-z0-9]{20,}|github_pat_[A-Za-z0-9_]{20,}|ghs_[A-Za-z0-9]{20,}|gho_[A-Za-z0-9]{20,}' \
      "${repository}" || true
  )
  if ((${#token_hits[@]} > 0)); then
    for hit in "${token_hits[@]}"; do
      location="${hit%%:*}"
      echo "TOKEN_LITERAL: ${location#"${workspace_root}/"} (line $(echo "${hit}" | cut -d: -f2))" >&2
    done
    violations=$((violations + ${#token_hits[@]}))
  fi
done

((violations == 0)) || fail "${violations} private-name or token reference(s) in public trees"

echo "PASS no-private-mirror-reference: no private repository name or token in ${#repositories[@]} public tree(s)"
