#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

"${repo_root}/tests/test-nix-file-loc.sh"
"${repo_root}/tests/test-s-router-clab-access-vlans.sh"
