#!/usr/bin/env bash
# GAMP-ID: FS-166-HDS-010-SDS-010-SMS-900
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
cd "$repo_root"
system="$(nix eval --impure --raw --expr builtins.currentSystem)"
nix build \
  ".#checks.${system}.controlled-validation-scheme" \
  ".#checks.${system}.controlled-validation-negatives" \
  --no-link
printf '%s\n' 'PASS FS-166-HDS-010-SDS-010-SMS-900: controlled flow and exact seeded negatives'
