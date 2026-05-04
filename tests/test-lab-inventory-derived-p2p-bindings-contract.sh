#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
labs_dir="${repo_root}/labs"

if [[ ! -d "${labs_dir}" ]]; then
  echo "PASS lab-inventory-derived-p2p-bindings-contract (no labs/ directory yet)"
  exit 0
fi

status=0

while IFS= read -r -d '' lab_dir; do
  lab_name="${lab_dir#"${repo_root}/"}"
  mapfile -d '' inventory_files < <(
    find "${lab_dir}" -maxdepth 1 -type f \( -name 'inventory*.nix' -o -name 'getInventory.nix' -o -name 'getResolvedInventory.nix' \) -print0
  )

  if ((${#inventory_files[@]} == 0)); then
    cat >&2 <<EOF
FATAL ${lab_name}: no inventory entrypoint found.

Labs may stop hand-modeling canonical p2p topology in intent only if inventory
still owns realization bindings for derived p2p links. Add getInventory.nix or
inventory-<renderer>.nix and bind derived links there.
EOF
    status=1
    continue
  fi

  bindings_file="$(mktemp)"
  for inventory_file in "${inventory_files[@]}"; do
    rg -n 'link *= *"p2p-|link = "p2p-|p2p-[A-Za-z0-9_-]+-[A-Za-z0-9_-]+' "${inventory_file}" >>"${bindings_file}" || true
  done

  if [[ ! -s "${bindings_file}" ]]; then
    cat >&2 <<EOF
FATAL ${lab_name}: inventory does not bind any derived p2p links.

Reason:

  The canonical staged layout is derived upstream, but realized p2p links still
  need concrete inventory bindings. Inventory must map derived link identities
  to bridges, VLANs, direct attachments, macvlan/host interfaces, or equivalent
  renderer realization facts. Do not move those bindings back into intent.
EOF
    status=1
  fi

  rm -f "${bindings_file}"
done < <(find "${labs_dir}" -mindepth 2 -maxdepth 2 -type d -print0)

exit "${status}"
