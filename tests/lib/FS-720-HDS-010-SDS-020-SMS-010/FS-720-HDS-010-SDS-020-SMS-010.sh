#!/usr/bin/env bash
# GAMP-ID: FS-720-HDS-010-SDS-020-SMS-010
# GAMP-SCOPE: software-module-test
#
# SPEC:   GAMP/SMS/FS-720-HDS-010-SDS-020-SMS-010.md
# OWNER:  network-labs
# MODULE: hat-inventory-fixture-parse
#
# Not executed before commit.
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
source "${repo_root}/tests/lib/direct-test-guard.sh"

fail() { echo "FAIL hat-inventory-fixture-parse: $*" >&2; exit 1; }


# P1: NixOS and CLAB HAT inventory fixture declarations must both be parseable. The
# invariant is that both inventories exist and each declares endpoint fixtures.
nixos_inv="$(find "${repo_root}/examples" -name "inventory-nixos.nix" 2>/dev/null | head -1)"
clab_inv="$(find "${repo_root}/examples" -name "inventory-clab.nix" 2>/dev/null | head -1)"

[[ -n "${nixos_inv}" ]] || fail "P1 no NixOS HAT inventory exists to parse"
[[ -n "${clab_inv}" ]] || fail "P1 no CLAB HAT inventory exists to parse"

# P2: each must declare endpoint fixtures rather than leaving them implicit.
grep -qE "endpoints|interfaces" "${nixos_inv}" || fail "P2 the NixOS inventory declares no endpoint facts"
grep -qE "endpoints|interfaces" "${clab_inv}" || fail "P2 the CLAB inventory declares no access-client facts"

