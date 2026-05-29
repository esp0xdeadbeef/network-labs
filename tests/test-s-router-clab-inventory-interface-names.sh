#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

examples=(
  "${repo_root}/examples/s-router-overlay-dns-lane-policy/inventory-clab.nix"
  "${repo_root}/examples/s-router-public-overlay-service/inventory-clab.nix"
)

status=0
for inventory in "${examples[@]}"; do
  if rg -n 'interface = \{[[:space:]]*name = "ens[0-9]+"' "${inventory}" >/dev/null; then
    printf 'FATAL %s still contains NixOS-style ens* interface realization names.\n' "${inventory#"${repo_root}/"}" >&2
    status=1
  fi
  if rg -n 'name = "ens[0-9]+"' "${inventory}" >/dev/null; then
    printf 'FATAL %s still contains stale ens* names in CLAB inventory.\n' "${inventory#"${repo_root}/"}" >&2
    status=1
  fi
  invalid_names="$(
    python3 - "${inventory}" <<'PY'
import pathlib
import re
import sys

text = pathlib.Path(sys.argv[1]).read_text()
pattern = re.compile(r'interface\s*=\s*\{\s*name\s*=\s*"([^"]+)"', re.S)
for name in sorted(set(pattern.findall(text))):
    if len(name) > 15 or re.match(r"^[A-Za-z0-9_.-]{1,15}$", name) is None:
        print(name)
PY
  )"
  if [[ -n "${invalid_names}" ]]; then
    printf 'FATAL %s contains CLAB interface names that are not valid Linux target names:\n%s\n' \
      "${inventory#"${repo_root}/"}" "${invalid_names}" >&2
    status=1
  fi
done

if (( status == 0 )); then
  echo "PASS s-router-clab-inventory-interface-names"
fi

exit "${status}"
