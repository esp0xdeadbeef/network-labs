#!/usr/bin/env bash
# GAMP-SCOPE: executes recorded SIT evidence commands; not HAT/SAT evidence
set -eo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

failures=0
total=0
rows=()
commands=()

while IFS= read -r -d '' row && IFS= read -r -d '' cmd; do
  rows+=("${row}")
  commands+=("${cmd}")
done < <(
  cd "${repo_root}"
  for file in GAMP/SIT/*/default.nix; do
    cmd_json="$(nix eval --impure --json --expr "let row = import ./${file}; in row.evidence.command or null" 2>/dev/null || true)"
    if [[ -n "${cmd_json}" && "${cmd_json}" != "null" ]]; then
      printf '%s\0%s\0' "${file}" "$(jq -r . <<<"${cmd_json}")"
    fi
  done
)

for index in "${!rows[@]}"; do
  row="${rows[${index}]}"
  cmd="${commands[${index}]}"
  total=$((total + 1))
  echo "RUN ${row}: ${cmd}"
  if (cd "${repo_root}" && bash -c "${cmd}"); then
    echo "PASS ${row}"
  else
    rc=$?
    failures=$((failures + 1))
    echo "FAIL ${row}: rc=${rc} cmd=${cmd}" >&2
  fi
  echo
done

echo "SUMMARY total=${total} failures=${failures}"
if [[ "${failures}" -ne 0 ]]; then
  exit 1
fi
