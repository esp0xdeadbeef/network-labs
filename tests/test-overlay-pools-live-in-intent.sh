#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() {
  echo "FAIL overlay-pools-live-in-intent: $*" >&2
  exit 1
}

inventory_hits="$(
  rg -n 'ipam = \{|perNodePrefixLength|offsetStart|prefix = "100\.|prefix = "fd[^"]*::/' \
    "${repo_root}/examples" "${repo_root}/labs" \
    -g 'inventory*.nix' || true
)"

if [[ -n "${inventory_hits}" ]]; then
  printf '%s\n' "${inventory_hits}" >&2
  fail "overlay allocator pools must not live in inventory files"
fi

while IFS= read -r intent; do
  if ! rg -q 'pools = \{' "${intent}" || ! rg -q 'overlay = \{' "${intent}"; then
    fail "overlay intent is missing pools.overlay: ${intent}"
  fi
done < <(rg -l 'transport\s*=\s*\{\s*overlays\s*=\s*\[' "${repo_root}/examples" "${repo_root}/labs" -g 'intent.nix')

echo "PASS overlay-pools-live-in-intent"
