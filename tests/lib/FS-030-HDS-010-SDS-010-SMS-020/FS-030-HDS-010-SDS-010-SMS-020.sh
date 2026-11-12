#!/usr/bin/env bash
# GAMP-ID: FS-030-HDS-010-SDS-010-SMS-020
# GAMP-SCOPE: software-module-test
# Row-local focused test for CPM realization binder authority boundary.
# Uses GAMP/SMT/FS-030-HDS-010-SDS-010-SMS-020/intent.nix
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
trace_id="FS-030-HDS-010-SDS-010-SMS-020"
smt_dir="${repo_root}/GAMP/SMT/${trace_id}"
intent_path="${smt_dir}/intent.nix"

echo "=== ${trace_id} row-local SMT ==="
echo "intent: ${intent_path}"

# Verify the row-local intent.nix carries this row's own contract.
#
# The fixture is keyed by trace id under the mini-smt root. Assert the relation
# the row actually declares, named explicitly, so a fixture edit that renames or
# drops it fails here instead of passing on a looser match.
relation_check="$(
  nix eval --impure --raw --expr "
    let
      intent = import ${intent_path};
      contract = intent.\"mini-smt\".\"${trace_id}\".communicationContract;
      ids = map (r: r.id) contract.relations;
      expected = \"${trace_id}__mini-verify\";
    in
      if builtins.elem expected ids then
        \"OK\"
      else
        \"FAIL: relation ids were \${builtins.concatStringsSep \",\" ids}\"
  " 2>&1
)"

if [[ "${relation_check}" != "OK" ]]; then
  echo "FAIL: row-local intent.nix relation id mismatch" >&2
  [[ "${relation_check}" == FAIL:* ]] && echo "${relation_check}" >&2
  exit 1
fi

echo "PASS: row-local intent.nix validates"
echo ""

# Delegate to the authoritative CPM construction test for full binder proof
echo "=== Delegating to CPM construction test ==="
cpm_test="tests/${trace_id}.sh"
# Resolve the sibling checkout from the workspace, never from a machine-local
# home-directory path: the suite and CI both place siblings beside this repo.
workspace_root="${NETWORK_WORKSPACE_ROOT:-$(cd "${repo_root}/.." && pwd)}"
cpm_repo="${NETWORK_CPM_PATH:-${workspace_root}/network-control-plane-model}"

if [ ! -f "${cpm_repo}/${cpm_test}" ]; then
  echo "SKIP: CPM test not found at ${cpm_repo}/${cpm_test}"
  echo "Row-local fixture valid. Full binder proof requires CPM repo."
  exit 0
fi

echo "Running: NETWORK_REPO_DIRECT_TEST_OK=1 bash ${cpm_test}"
(cd "${cpm_repo}" && NETWORK_REPO_DIRECT_TEST_OK=1 bash "${cpm_test}")
