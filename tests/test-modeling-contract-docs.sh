#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readme="${repo_root}/README.md"

required_phrases=(
  "Do not draw that chain by hand in new lab"
  "Inventory still has to bind those derived p2p links"
  "roaming overlay client as overlay membership plus policy/service"
  "route ownership explicitly"
  "SOPS/runtime"
)

missing=()
for phrase in "${required_phrases[@]}"; do
  if ! grep -Fq "${phrase}" "${readme}"; then
    missing+=("${phrase}")
  fi
done

if ((${#missing[@]} > 0)); then
  cat >&2 <<'EOF'
FATAL network-labs modeling guidance is incomplete.

The README must explain the intent/inventory split for derived topology:

  - intent must not hand-draw the canonical staged chain
  - inventory still binds derived p2p links to concrete realization
  - roaming overlay clients are overlay membership plus policy unless they own routes
  - route ownership is explicit when a client/core exports prefixes
  - prod-like runtime facts belong in SOPS/runtime inventory

Missing README phrases:
EOF
  printf '  - %s\n' "${missing[@]}" >&2
  exit 1
fi

echo "PASS modeling-contract-docs"
