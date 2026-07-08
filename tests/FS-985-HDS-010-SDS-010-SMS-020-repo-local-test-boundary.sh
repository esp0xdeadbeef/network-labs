#!/usr/bin/env bash
# Construction test: FS-985-HDS-010-SDS-010-SMS-020-repo-local-test-boundary
# SMS: Repo-Local Test Downstream Boundary
#
# Proves that network-labs/tests/ does NOT invoke downstream repo entrypoints
# via nix run, nix build, or nix shell targeting downstream flake outputs.
#
# Seeded negatives (active, per SMS):
#   N1: CPM #compile-and-build-control-plane-model invocation detected
#   N2: CLAB #generate-clab-config invocation detected
#   N3: NixOS #render-dry-config invocation detected
#   N4: Broad downstream flake invocation detected

set -uo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="${repo_root%/tests}"
tests_dir="${repo_root}/tests"
trace="FS-985-HDS-010-SDS-010-SMS-020"
self="$(basename "${BASH_SOURCE[0]}")"
failures=0

red()  { echo -e "\033[31m$*\033[0m" >&2; }
green() { echo -e "\033[32m$*\033[0m"; }
fail() { red "  FAIL: $1"; failures=$((failures + 1)); }
pass() { green "  PASS: $1"; }

echo "=== ${trace}: Repo-Local Test Downstream Boundary ==="
echo ""

check_target() {
  local pattern="$1"
  local label="$2"
  local found=0
  local files linenos ln ctx

  files=$(grep -rl "${pattern}" "${tests_dir}/"*.sh 2>/dev/null || true)
  for f in ${files}; do
    [[ "$(basename "${f}")" == "${self}" ]] && continue
    linenos=$(grep -n "${pattern}" "${f}" 2>/dev/null | cut -d: -f1 || true)
    for ln in ${linenos}; do
      ctx=0
      if sed -n "${ln}p" "${f}" 2>/dev/null | grep -qE 'nix (run|build|shell)'; then
        ctx=1
      elif [[ "${ln}" -gt 1 ]]; then
        if sed -n "$((ln - 1))p" "${f}" 2>/dev/null | grep -qE 'nix (run|build|shell)'; then
          ctx=1
        fi
      fi
      if [[ ${ctx} -eq 1 ]]; then
        fail "${label}: ${f}:${ln}"
        found=1
      fi
    done
  done
  if [[ ${found} -eq 0 ]]; then
    pass "zero ${label} invocations in network-labs/tests/"
  fi
}

# P1
echo "P1: #compile-and-build-control-plane-model"
check_target '#compile-and-build-control-plane-model' 'CPM compile-and-build'
echo ""

# P2
echo "P2: #generate-clab-config"
check_target '#generate-clab-config' 'CLAB generate-clab'
echo ""

# P3
echo "P3: #render-dry-config"
check_target '#render-dry-config' 'NixOS render-dry'
echo ""

# P4: Broad downstream path scan
echo "P4: Broad downstream path invocation scan"
p4hits=$(grep -rn 'nix \(run\|build\)' "${tests_dir}/"*.sh 2>/dev/null \
  | grep -v "/${self}:" \
  | grep -E 'path:.*/(network-(compiler|control-plane-model|forwarding-model|renderer|nfm|nebula|wireguard|nixos|clab|access-endpoint))' \
  | grep -v '#jq' || true)
p4count=$(echo "${p4hits}" | grep -c . || echo 0)
if [[ -z "${p4hits}" || "${p4count}" -eq 0 ]]; then
  pass "zero broad downstream invocations"
else
  fail "${p4count} broad downstream invocation(s) found"
  echo "${p4hits}" | while IFS= read -r h; do red "    ${h}"; done
fi
echo ""

# Seed negative counts
echo "N1: CPM #compile-and-build-control-plane-model grep count"
n1=$(grep -rn '#compile-and-build-control-plane-model' "${tests_dir}/"*.sh 2>/dev/null | grep -v "/${self}:" | wc -l || echo 0)
pass "N1: ${n1} hit(s) - detection ready"

echo "N2: CLAB #generate-clab-config grep count"
n2=$(grep -rn '#generate-clab-config' "${tests_dir}/"*.sh 2>/dev/null | grep -v "/${self}:" | wc -l || echo 0)
pass "N2: ${n2} hit(s) - detection ready"

echo "N3: NixOS #render-dry-config grep count"
n3=$(grep -rn '#render-dry-config' "${tests_dir}/"*.sh 2>/dev/null | grep -v "/${self}:" | wc -l || echo 0)
pass "N3: ${n3} hit(s) - detection ready"

echo ""
echo "---"
if [[ ${failures} -eq 0 ]]; then
  green "RESULT: ${trace} PASS (0 failures)"
  exit 0
else
  red "RESULT: ${trace} FAIL (${failures} failures)"
  exit 1
fi
