#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
labs_dir="${repo_root}/labs"

if [[ ! -d "${labs_dir}" ]]; then
  echo "PASS lab-intent-derived-topology-contract (no labs/ directory yet)"
  exit 0
fi

hits_file="$(mktemp)"
trap 'rm -f "${hits_file}"' EXIT

find "${labs_dir}" -type f -name 'intent.nix' -print0 \
  | xargs -0 -r rg -n 'topology\.links|transit\.ordering|p2p-[A-Za-z0-9_-]+-[A-Za-z0-9_-]+' \
  >"${hits_file}" || true

if [[ -s "${hits_file}" ]]; then
  cat >&2 <<'EOF'
FATAL network-labs lab intent is hand-modeling derived topology.

New prod-like labs must not draw the canonical fabric link layout in intent:

  access -> downstream-selector -> policy -> upstream-selector -> core

Reason:

  The compiler owns canonical staged architecture. The forwarding model owns
  dedicated lane and p2p derivation. Intent should declare tenants, services,
  overlay/uplink domains, communication policy, and route ownership. If intent
  also draws the canonical p2p chain, the same invariant is modeled twice and
  future bugs can hide in mismatched hand-authored links.

Inventory is still expected to bind the derived p2p link names to concrete
bridges/VLANs/direct links/interfaces. That binding belongs in
inventory-<renderer>.nix or resolved SOPS/runtime inventory, not in intent.

Allowed edge cases:

  - extra stage cardinality, such as multiple cores or multiple access classes
  - explicit overlay membership or route ownership
  - route-exporting overlay participants that are real forwarding authorities

Offending lines:
EOF
  cat "${hits_file}" >&2
  exit 1
fi

echo "PASS lab-intent-derived-topology-contract"
