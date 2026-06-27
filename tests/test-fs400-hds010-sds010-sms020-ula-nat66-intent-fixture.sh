#!/usr/bin/env bash
# GAMP-ID: FS-400-HDS-010-SDS-010-SMS-020
# GAMP-SCOPE: software-module-test
# Focused row-local test for ULA NAT66 selection mini-SMT intent fixture.
# Verifies the intent.nix structure without requiring tests.nix registration.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
intent_file="${repo_root}/GAMP/SMT/FS-400-HDS-010-SDS-010-SMS-020/intent.nix"

echo "=== FS-400-HDS-010-SDS-010-SMS-020 row-local intent fixture verification ==="

failures=0

check() {
  local label="$1"
  local pattern="$2"
  if grep -q "${pattern}" "${intent_file}" 2>/dev/null; then
    echo "PASS: ${label}"
  else
    echo "FAIL: ${label}"
    failures=$((failures + 1))
  fi
}

# 1. File exists
if [[ -f "${intent_file}" ]]; then
  echo "PASS: intent file exists"
else
  echo "FAIL: intent file not found: ${intent_file}"
  exit 1
fi

# 2. Expected relation ID
check "expected relation ID" \
  "FS-400-HDS-010-SDS-010-SMS-020__mini-ula-nat66-tenant-to-wan"

# 3. ULA tenant with NAT66 mode (Nix format: = "nat66")
check "ULA tenant internetMode = nat66" \
  'internetMode = "nat66"'

# 4. NAT66 egress prefix
check "NAT66 egress prefix 2001:db8:abcd::/48" \
  'nat66EgressPrefix = "2001:db8:abcd::/48"'

# 5. WAN external NAT66 egress prefix
check "WAN external nat66Egress prefix" \
  'nat66Egress ='

# 6. Topology nodes
check "topology residential-edge node" \
  "residential-edge"

check "topology wan-edge node" \
  "wan-edge"

# 7. Allow action
check "relation action = allow" \
  'action = "allow"'

echo ""
if [[ "${failures}" -eq 0 ]]; then
  echo "=== 0 failures — PASS ==="
  echo "FS-400-HDS-010-SDS-010-SMS-020 row-local intent fixture verified."
  exit 0
else
  echo "=== ${failures} FAILURES ==="
  exit 1
fi
