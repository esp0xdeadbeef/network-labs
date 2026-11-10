#!/usr/bin/env bash
# GAMP-ID: FS-750-HDS-010-SDS-010-SMS-010
# GAMP-SCOPE: software-module-test
#
# SPEC:   GAMP/SMS/FS-750-HDS-010-SDS-010-SMS-010.md
# OWNER:  network-labs
# MODULE: receiver-simulation-fixture
#
# Not executed before commit.
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
source "${repo_root}/tests/lib/direct-test-guard.sh"

fail() { echo "FAIL receiver-simulation-fixture: $*" >&2; exit 1; }


# P1: the receiver simulation must be modelled as a VM or containerized fixture with
# a stable host identity and a tenant or access-space assignment.
search=( "${repo_root}/examples" "${repo_root}/GAMP" )
found=""
for c in "${search[@]}"; do
  [[ -e "${c}" ]] || continue
  found="${found}$(grep -rlE "receiver|receiverSimulation" "${c}" 2>/dev/null | head -1)"
done
[[ -n "${found}" ]] || fail "P1 no receiver-simulation fixture exists in the labs tree"

# P2: the fixture must carry a modeled host identity, not an ad-hoc name.
grep -rqiE "host(name)?\\s*=" "${search[@]}" 2>/dev/null || fail "P2 no stable modeled host identity appears alongside the receiver fixture"

