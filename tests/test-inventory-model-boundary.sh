#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() {
  echo "FAIL inventory-model-boundary: $*" >&2
  exit 1
}

hits="$(
  rg -n \
    'wan_firewall|masquerade[[:space:]]*=|pool[[:space:]]*=[[:space:]]*\{|pd[[:space:]]*=[[:space:]]*\{|routedPrefixes\.[A-Za-z0-9_-]+[[:space:]]*=' \
    "${repo_root}/examples" "${repo_root}/labs" \
    -g 'inventory*.nix' || true
)"

if [[ -n "${hits}" ]]; then
  printf '%s\n' "${hits}" >&2
  fail "inventory must not carry WAN NAT, DHCP pool, IPv6 PD, or routed-prefix semantics"
fi

echo "PASS inventory-model-boundary"
