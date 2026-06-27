#!/usr/bin/env bash
# GAMP-ID: FS-165-HDS-010-SDS-010-SMS-010
# Row-local focused test: source-value necessity validation
# Evidence tier: construction/local-build
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
checker="$HOME/github/network-codex-agent/scripts/helpers/gamp-sms-input-contracts.py"
intent="${repo_root}/GAMP/SMT/FS-165-HDS-010-SDS-010-SMS-010/intent.nix"
scratch="$(mktemp -d "/tmp/fs165-sms010-smt-XXXXXX")"
trap 'rm -rf "'"${scratch}"'"' EXIT

fail() { echo "FAIL FS-165-HDS-010-SDS-010-SMS-010: $*" >&2; exit 1; }

nix eval --impure --json --expr "import ${intent}" >"${scratch}/fixture.json" \
  || fail "nix eval intent.nix failed"

# Checker fs165-source-form-minimality validates fixture structural coverage
# of all SMS-010/020/030 predicates: module checks, failure conditions,
# readability padding diagnostics, and downstream gap cases.
if ! "${checker}" fs165-source-form-minimality "${scratch}/fixture.json" \
    >"${scratch}/out" 2>"${scratch}/err"; then
  echo "STDERR:"; cat "${scratch}/err"
  fail "checker rejected fixture — missing predicate coverage"
fi

# Verify checker reported PASS
grep -q 'PASS fs165-source-form-minimality' "${scratch}/out" \
  || fail "checker did not report PASS"

# Verify fixture includes SMS-010 seeded negatives
jq -e '[.source_value_cases[] | select(.failure_reason == "source_value_duplicates_downstream_detail")] | length > 0' \
  "${scratch}/fixture.json" >/dev/null \
  || fail "SN1 not present: downstream-detail duplication case"

jq -e '[.source_value_cases[] | select(.failure_reason == "source_value_has_no_allowed_class_or_downstream_derivation_reason")] | length > 0' \
  "${scratch}/fixture.json" >/dev/null \
  || fail "SN2 not present: no-allowed-class case"

# Verify all seven SMS-020 readability padding diagnostics covered
jq -e '[.readability_cases[] | select(.case_kind == "failure")] | length == 7' \
  "${scratch}/fixture.json" >/dev/null \
  || fail "not all 7 readability padding diagnostics covered"

# Verify SMS-030 gap case present
jq -e '[.downstream_gap_cases[] | select(.case_kind == "gap")] | length > 0' \
  "${scratch}/fixture.json" >/dev/null \
  || fail "no downstream contract gap case"

echo "PASS FS-165-HDS-010-SDS-010-SMS-010 (source-value necessity, row-local SMT)"
