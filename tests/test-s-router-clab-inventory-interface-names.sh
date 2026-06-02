#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

inventories=(
  "${repo_root}/examples/s-router-overlay-dns-lane-policy/inventory-clab.nix"
  "${repo_root}/examples/s-router-overlay-dns-lane-policy/inventory-nixos.nix"
  "${repo_root}/examples/s-router-public-overlay-service/inventory-clab.nix"
  "${repo_root}/examples/s-router-public-overlay-service/inventory-nixos.nix"
  "${repo_root}/examples/tri-site-s-router-overlay-egress/inventory.nix"
  "${repo_root}/sat/inventory.nix"
)

status=0
for inventory in "${inventories[@]}"; do
  if rg -n 'interface = \{[[:space:]]*name = "ens[0-9]+"' "${inventory}" >/dev/null; then
    printf 'FATAL %s still contains stale ens* interface realization names.\n' "${inventory#"${repo_root}/"}" >&2
    status=1
  fi
  if rg -n 'name = "ens[0-9]+"' "${inventory}" >/dev/null; then
    printf 'FATAL %s still contains stale ens* runtime names.\n' "${inventory#"${repo_root}/"}" >&2
    status=1
  fi
  invalid_names="$(
    nix eval --impure --json --expr "import ${inventory}" \
      | jq -r '
          paths(scalars) as $p
          | getpath($p) as $value
          | select($value | type == "string")
          | select(
              (($p | length) >= 2 and $p[-2] == "interface" and $p[-1] == "name")
              or (($p | index("advertisements")) != null and $p[-1] == "interface")
            )
          | select(
              (($value | length) > 15)
              or (($value | test("^[A-Za-z0-9_.-]{1,15}$")) | not)
            )
          | "\($p | join("."))=\($value)"
        '
  )"
  if [[ -n "${invalid_names}" ]]; then
    printf 'FATAL %s contains Linux runtime interface names that are not valid target names:\n%s\n' \
      "${inventory#"${repo_root}/"}" "${invalid_names}" >&2
    status=1
  fi
done

if (( status == 0 )); then
  echo "PASS s-router-clab-inventory-interface-names"
fi

exit "${status}"
