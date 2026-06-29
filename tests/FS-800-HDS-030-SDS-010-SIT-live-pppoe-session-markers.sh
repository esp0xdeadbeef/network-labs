#!/usr/bin/env bash
# GAMP-ID: FS-800-HDS-030-SDS-010
# GAMP-SCOPE: focused live SIT probe for provider-side PPPoE session markers; not a HAT runner
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
exec "${repo_root}/tests/fs800-live-pppoe-session-common.sh" \
  FS-800-HDS-030-SDS-010 \
  provider-side
