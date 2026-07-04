#!/usr/bin/env bash
# GAMP-ID: FS-050-HDS-010-SDS-010-SMS-010
# GAMP-SCOPE: active-lab construction-only SMT wrapper
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
trace_id="FS-050-HDS-010-SDS-010-SMS-010"
cpm_repo="${NETWORK_CPM_REPO:-${NETWORK_CONTROL_PLANE_MODEL_ROOT:-${repo_root}/../network-control-plane-model}}"
cpm_test="${cpm_repo}/tests/FS-050-HDS-010-SDS-010-SMS-010-protected-inventory-boundary.sh"
row_default="${repo_root}/GAMP/SMT/${trace_id}/default.nix"

fail() {
  echo "FAIL ${trace_id}: $*" >&2
  exit 1
}

[[ -f "${row_default}" ]] || fail "missing row default: ${row_default}"
[[ -x "${cpm_test}" ]] || fail "missing executable CPM construction test: ${cpm_test}"

nix eval --impure --expr "
let
  row = import ${row_default};
  require = cond: msg: if cond then true else throw msg;
in
  require (row.traceId == \"${trace_id}\") \"row default must carry the full trace ID\"
  && require (row.evidenceBoundary == \"construction-only\") \"FS-050 row must stay construction-only\"
  && require (row.evidence.owningRepo == \"network-control-plane-model\") \"FS-050 owning repo must be CPM\"
" >/dev/null || fail "row metadata contract failed"

NETWORK_REPO_DIRECT_TEST_OK=1 bash "${cpm_test}"

echo "PASS ${trace_id}: active-lab construction wrapper"
