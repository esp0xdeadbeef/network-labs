#!/usr/bin/env bash
# GAMP-ID: FS-162-HDS-010-SDS-020-SMS-010
# GAMP-SCOPE: construction-only locked OpenConfig YANG validation
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
cd "$repo_root"
system="$(nix eval --impure --raw --expr builtins.currentSystem)"
nix build ".#checks.${system}.openconfig-yang-validation" --no-link
printf '%s\n' 'PASS FS-162-HDS-010-SDS-020-SMS-010: locked offline YANG validation and recovery assertions'
