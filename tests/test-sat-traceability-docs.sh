#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
doc="${repo_root}/tests/SAT.md"

fail() {
  echo "FAIL sat-traceability-docs: $*" >&2
  exit 1
}

[[ -f "${doc}" ]] || fail "missing tests/SAT.md"

required=(
  "SAT Validation Stub Index"
  "stub, not acceptance evidence"
  "LAB-SAT-STUB-001"
  "live execution records command"
  'no SAT `OK` claim'
  "eth0.2"
  "DHCP"
)

missing=()
for phrase in "${required[@]}"; do
  if ! grep -Fq "${phrase}" "${doc}"; then
    missing+=("${phrase}")
  fi
done

if ((${#missing[@]} > 0)); then
  printf 'missing required SAT stub phrase: %s\n' "${missing[@]}" >&2
  exit 1
fi

if grep -Eq '\|[[:space:]]*OK[[:space:]]*\|' "${doc}"; then
  fail "SAT stub must not claim OK"
fi

echo "PASS sat-traceability-docs"
