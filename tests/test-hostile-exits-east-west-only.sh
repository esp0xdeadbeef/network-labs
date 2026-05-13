#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

check_intent() {
  local intent_path="$1"
  local label="$2"

  if grep -q 'id = "allow-hostile-to-wan"' "${intent_path}"; then
    echo "${label}: hostile tenant must not be allowed to local WAN" >&2
    exit 1
  fi

  grep -q 'id = "allow-hostile-to-east-west"' "${intent_path}" || {
    echo "${label}: hostile tenant must retain east-west egress" >&2
    exit 1
  }
}

check_intent \
  "${repo_root}/examples/s-router-overlay-dns-lane-policy/intent.nix" \
  "examples/s-router-overlay-dns-lane-policy"

check_intent \
  "${repo_root}/labs/lab-s-sigma/s-router-test-three-site/intent.nix" \
  "labs/lab-s-sigma/s-router-test-three-site"

echo "PASS hostile-exits-east-west-only"
