#!/usr/bin/env bash
# GAMP-ID: FS-950-HDS-010-SDS-010-SMS-050
# GAMP-SCOPE: focused SMT construction test — s-router-prod offline latest-pin
#             migration documentation module.
# Delegates to the canonical shared test.
set -euo pipefail

repo_root="$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)"
canonical="${repo_root}/tests/lib/shared/FS-950-HDS-010-SDS-010-SMS-050.sh"

[[ -f "${canonical}" ]] || {
  echo "FAIL FS-950-HDS-010-SDS-010-SMS-050: canonical test not found: ${canonical}" >&2
  exit 1
}

SMS_TEST_REPO_ROOT="${repo_root}" bash "${canonical}"
