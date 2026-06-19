#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
doc="${repo_root}/tests/SIT.md"

fail() {
  echo "FAIL sit-traceability-docs: $*" >&2
  exit 1
}

[[ -f "${doc}" ]] || fail "missing tests/SIT.md"

required=(
  "SIT Validation Stub Index"
  "stub, not validation evidence"
  "LAB-SIT-STUB-001"
  "Locked source-to-artifact integration evidence"
  'no SIT `OK` claim'
  "executable integration command"
)

missing=()
for phrase in "${required[@]}"; do
  if ! grep -Fq "${phrase}" "${doc}"; then
    missing+=("${phrase}")
  fi
done

if ((${#missing[@]} > 0)); then
  printf 'missing required SIT stub phrase: %s\n' "${missing[@]}" >&2
  exit 1
fi

if grep -Eq '\|[[:space:]]*OK[[:space:]]*\|' "${doc}"; then
  fail "SIT stub must not claim OK"
fi

echo "PASS sit-traceability-docs"
