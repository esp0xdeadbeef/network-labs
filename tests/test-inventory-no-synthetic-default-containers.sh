#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mapfile -t hits < <(
  find "${repo_root}/examples" "${repo_root}/labs" \
    -type f \( -name 'inventory*.nix' -o -name 'getInventory*.nix' -o -name 'getResolvedInventory*.nix' \) \
    -print0 2>/dev/null \
    | xargs -0 -r rg -n 'containers[[:space:]]*=[[:space:]]*\{' || true
)

if ((${#hits[@]} > 0)); then
  cat >&2 <<'EOF'
FATAL inventory-no-synthetic-default-containers:
Inventory must not invent containers.default bindings for forwarding nodes.

containers in inventory are only valid when the forwarding model declares real
logical node containers. A target's runtime node/container name belongs in the
renderer/realization target identity, not as a fake forwarding-model container.

Remove this guard only after CPM and renderers have a first-class runtime target
name field that is not confused with logical containers.
EOF
  printf '%s\n' "${hits[@]}" | sed 's/^/FATAL inventory-no-synthetic-default-containers: /' >&2
  exit 1
fi

echo "PASS inventory-no-synthetic-default-containers"
