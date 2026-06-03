#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
doc="${repo_root}/tests/SMT.md"

[[ -f "${doc}" ]] || {
  echo "FAIL smt-traceability-docs: missing tests/SMT.md" >&2
  exit 1
}

required=(
  "examples-only SMT"
  "network-labs/examples"
  "LAB-SMT-001"
  "LAB-SMT-011"
  "LAB-SMT-014"
  "LAB-SMT-015"
  "LAB-SMT-016"
  "LAB-SMT-017"
  "LAB-SMT-020"
  "LAB-SMT-025"
  "PPPoE"
  "SMT-PPPOE-001"
  "isolated Ethernet PPPoE handoff"
  "203.0.113.0/24"
  "2001:db8::/32"
  "no intermediate router GUA"
  "delegatedPrefixLength = 48"
  "perTenantPrefixLength = 52"
  "network-compiler/tests/test-dual-wan-branch-overlay.sh"
  "network-forwarding-model/tests/test-overlay-core-local-hostile-return-routes.sh"
  "network-control-plane-model/tests/test-overlay-core-local-hostile-return-routes.sh"
  "network-renderer-nixos/tests/test-overlay-core-local-hostile-return-routes.sh"
  "network-renderer-nebula/tests/test-nebula-delegated-default-exit.sh"
  "network-renderer-containerlab-linux-backend/tests/test-hostile-dns-east-west.sh"
  "network-renderer-containerlab-linux-backend/tests/test-dns-service-policy-routes.sh"
  "network-renderer-nixos/tests/test-host-uplink-vlan-dhcp.sh"
  "network-renderer-containerlab-linux-backend/tests/test-routing-mode-required.sh"
  "examples/tri-site-s-router-overlay-egress"
  "examples/s-router-overlay-dns-lane-policy"
  "examples/ipv6-pd-downstream-delegation"
)

missing=()
for phrase in "${required[@]}"; do
  if ! grep -Fq "${phrase}" "${doc}"; then
    missing+=("${phrase}")
  fi
done

if ((${#missing[@]} > 0)); then
  echo "FAIL smt-traceability-docs: missing required traceability phrases" >&2
  printf '  - %s\n' "${missing[@]}" >&2
  exit 1
fi

if grep -Eq 'labs/lab-sigma|labs/lab-s-sigma|s-router-full-lab-rebuild-loop' "${doc}"; then
  cat >&2 <<'EOF'
FAIL smt-traceability-docs: examples-only SMT doc must not cite SAT source paths or the full lab loop.

SMT rows belong to stable network-labs/examples fixtures. SAT source/runtime
evidence is tracked separately in network-codex-agent GAMP/SAT and regression
notes.
EOF
  exit 1
fi

duplicate_ids="$(
  grep -E '^\| `LAB-SMT-[0-9]{3}` \|' "${doc}" | grep -Eo 'LAB-SMT-[0-9]{3}' | sort | uniq -d
)"
if [[ -n "${duplicate_ids}" ]]; then
  echo "FAIL smt-traceability-docs: duplicate SMT IDs" >&2
  printf '%s\n' "${duplicate_ids}" >&2
  exit 1
fi

echo "PASS smt-traceability-docs"
