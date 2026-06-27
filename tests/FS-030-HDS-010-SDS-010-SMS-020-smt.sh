#!/usr/bin/env bash
# GAMP-ID: FS-030-HDS-010-SDS-010-SMS-020
# GAMP-SCOPE: software-module-test
# Row-local focused test for CPM realization binder authority boundary.
# Uses GAMP/SMT/FS-030-HDS-010-SDS-010-SMS-020/intent.nix
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
smt_dir="${repo_root}/GAMP/SMT/FS-030-HDS-010-SDS-010-SMS-020"
intent_path="${smt_dir}/intent.nix"

echo "=== FS-030-HDS-010-SDS-010-SMS-020 row-local SMT ==="
echo "intent: ${intent_path}"

# Verify the row-local intent.nix is valid Nix
if ! nix eval --impure --raw --expr "
  let
    intent = import ${intent_path};
    rel = intent.\"mini-smt\".\"binder-authority-boundary\".communicationContract.relations;
    rid = builtins.head rel;
  in
    if rid.id == \"FS-030-HDS-010-SDS-010-SMS-020__mini-allow-client-to-testnet\"
    then \"OK\"
    else \"FAIL: unexpected relation id \${rid.id}\"
" 2>&1 | grep -qx OK; then
  echo "FAIL: row-local intent.nix relation id mismatch" >&2
  exit 1
fi

echo "PASS: row-local intent.nix validates"
echo ""

# Delegate to the authoritative CPM construction test for full binder proof
echo "=== Delegating to CPM construction test ==="
cpm_test="tests/FS-030-HDS-010-SDS-010-SMS-020-cpm-realization-binder-source-audit.sh"
cpm_repo="${HOME}/github/network-control-plane-model"

if [ ! -f "${cpm_repo}/${cpm_test}" ]; then
  echo "SKIP: CPM test not found at ${cpm_repo}/${cpm_test}"
  echo "Row-local fixture valid. Full binder proof requires CPM repo."
  exit 0
fi

echo "Running: NETWORK_REPO_DIRECT_TEST_OK=1 bash ${cpm_test}"
(cd "${cpm_repo}" && NETWORK_REPO_DIRECT_TEST_OK=1 bash "${cpm_test}")
