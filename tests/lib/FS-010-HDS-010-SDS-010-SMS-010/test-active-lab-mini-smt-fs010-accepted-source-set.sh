#!/usr/bin/env bash
# GAMP-SCOPE: FS-010 active-lab mini SMT source-set construction; not HAT/SAT evidence.
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
trace="FS-010-HDS-010-SDS-010-SMS-010"
agent_repo="${NETWORK_CODEX_AGENT_ROOT:-${repo_root}/../network-codex-agent}"
canonical_test="${agent_repo}/tests/test-gamp-sms-input-contracts.sh"
intent_path="${MINI_SMT_INTENT_PATH:-${repo_root}/GAMP/SMT/${trace}/intent.nix}"

fail() {
  echo "FAIL ${trace}: $*" >&2
  exit 1
}

[[ "${MINI_SMT_ID:-${trace}}" == "${trace}" ]] \
  || fail "runner invoked for ${MINI_SMT_ID:-unset}"
[[ "${MINI_SMT_MANIFEST_KEY:-${trace}}" == "${trace}" ]] \
  || fail "manifest key mismatch: ${MINI_SMT_MANIFEST_KEY:-unset}"
[[ "${MINI_SMT_SOURCE_KIND:-intent-source}" == "intent-source" ]] \
  || fail "source kind must be intent-source, got ${MINI_SMT_SOURCE_KIND:-unset}"
[[ -f "${intent_path}" ]] \
  || fail "intent source is missing: ${intent_path}"
[[ -x "${canonical_test}" ]] \
  || fail "canonical source-set construction test is missing or not executable: ${canonical_test}"

expected_relation="${trace}__mini-verify"
relation_ids="$(
  INTENT_PATH="${intent_path}" TRACE_ID="${trace}" nix eval --impure --raw --expr '
    let
      intent = import (builtins.getEnv "INTENT_PATH");
      traceId = builtins.getEnv "TRACE_ID";
      site = builtins.getAttr traceId intent.mini-smt;
    in builtins.concatStringsSep "\n" (map (relation: relation.id) site.communicationContract.relations)
  '
)"

grep -Fxq "${expected_relation}" <<<"${relation_ids}" \
  || fail "intent source does not expose expected relation ${expected_relation}"

bash "${canonical_test}"

echo "PASS ${trace}: accepted source-set construction"
