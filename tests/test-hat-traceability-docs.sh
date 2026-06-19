#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
doc="${repo_root}/tests/HAT.md"

fail() {
  echo "FAIL hat-traceability-docs: $*" >&2
  exit 1
}

[[ -f "${doc}" ]] || fail "missing tests/HAT.md"

required=(
  "host-acceptance preparation fixtures"
  "not SAT"
  "LAB-HAT-001"
  "network-labs/tests/test-hat-emulated-isp-residential-testnet.sh"
  "REQUIRED LIVE FOLLOW-UP"
  "DHCP lease state"
  "PPPoE session state"
  "bounded reachability probes"
)

missing=()
for phrase in "${required[@]}"; do
  if ! grep -Fq "${phrase}" "${doc}"; then
    missing+=("${phrase}")
  fi
done

if ((${#missing[@]} > 0)); then
  printf 'missing required HAT traceability phrase: %s\n' "${missing[@]}" >&2
  exit 1
fi

if grep -Eq '\|[[:space:]]*OK[[:space:]]*\|' "${doc}"; then
  fail "HAT fixture index must not claim acceptance OK"
fi

echo "PASS hat-traceability-docs"
