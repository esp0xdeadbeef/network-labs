#!/usr/bin/env bash
# GAMP-ID: FS-500-HDS-010-SDS-010-SMS-050
# GAMP-SCOPE: software-module-test
# Mini-SMT construction test: p2p bridge co-location
# Delegates to focused construction tests in owning renderer repos
set -euo pipefail

trace="FS-500-HDS-010-SDS-010-SMS-050"
failures=0

# Find renderer repo paths relative to network-labs
repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
nixos_renderer="${NETWORK_RENDERER_NIXOS_PATH:-$repo_root/../network-renderer-nixos}"
clab_renderer="${NETWORK_RENDERER_CLAB_PATH:-$repo_root/../network-renderer-containerlab-linux-backend}"

echo "=== FS-500-HDS-010-SDS-010-SMS-050 p2p bridge co-location mini-SMT ==="
echo ""

# --- NixOS bridge co-location test ---
nixos_test="${nixos_renderer}/tests/FS-500-HDS-010-SDS-010-SMS-050.sh"
if [ -f "$nixos_test" ]; then
  echo "--- NixOS renderer bridge co-location ---"
  if NETWORK_REPO_DIRECT_TEST_OK=1 bash "$nixos_test"; then
    echo "PASS FS-500-HDS-010-SDS-010-SMS-050: NixOS bridge co-location"
  else
    echo "FAIL FS-500-HDS-010-SDS-010-SMS-050: NixOS bridge co-location"
    ((failures++)) || true
  fi
else
  echo "MISSING FS-500-HDS-010-SDS-010-SMS-050: NixOS renderer test not found at $nixos_test"
  ((failures++)) || true
fi
echo ""

# --- CLAB link co-location test ---
clab_test="${clab_renderer}/tests/FS-500-HDS-010-SDS-010-SMS-050.sh"
if [ -f "$clab_test" ]; then
  echo "--- CLAB renderer link co-location ---"
  if NETWORK_REPO_DIRECT_TEST_OK=1 bash "$clab_test"; then
    echo "PASS FS-500-HDS-010-SDS-010-SMS-050: CLAB link co-location"
  else
    echo "FAIL FS-500-HDS-010-SDS-010-SMS-050: CLAB link co-location"
    ((failures++)) || true
  fi
else
  echo "MISSING FS-500-HDS-010-SDS-010-SMS-050: CLAB renderer test not found at $clab_test"
  ((failures++)) || true
fi
echo ""

if [ "$failures" -eq 0 ]; then
  echo "PASS FS-500-HDS-010-SDS-010-SMS-050: all construction tests passed"
  exit 0
else
  echo "FAIL FS-500-HDS-010-SDS-010-SMS-050: $failures failure(s)"
  exit 1
fi
