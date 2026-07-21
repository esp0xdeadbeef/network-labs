#!/usr/bin/env bash
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
checker="${CONTROLLED_DOCUMENT_LANGUAGE_CHECKER:-$(nix build --no-link --print-out-paths "${repo_root}#controlled-document-language")/bin/controlled-document-language}"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

fail() {
  printf 'FAIL FS-164-HDS-010-SDS-010-SMS-010: %s\n' "$*" >&2
  exit 1
}

init_fixture() {
  local root="$1"
  mkdir -p "${root}/GAMP/FS"
  git -C "${root}" init -q
  printf '# Controlled English baseline\n\nThis document is written in English.\n' >"${root}/GAMP/FS/README.md"
  git -C "${root}" add GAMP/FS/README.md
}

expect_failure() {
  local label="$1"
  local expected_code="$2"
  shift 2
  local stdout="${tmp_dir}/${label}.stdout"
  local stderr="${tmp_dir}/${label}.stderr"
  local status

  set +e
  "$@" >"${stdout}" 2>"${stderr}"
  status=$?
  set -e
  [[ "${status}" -eq 2 ]] || fail "${label} exit=${status}, expected=2"
  [[ ! -s "${stdout}" ]] || fail "${label} emitted admitted output"
  jq -s -e --arg code "${expected_code}" 'length > 0 and all(.[]; .code == $code)' "${stderr}" >/dev/null \
    || fail "${label} diagnostic mismatch"
}

baseline="$(${checker} scan "${repo_root}")"
jq -e '
  .traceId == "FS-164-HDS-010-SDS-010-SMS-010"
  and .ruleIdentity != ""
  and .corpusFiles > 0
  and .exclusions >= 0
  and .violations == 0
' <<<"${baseline}" >/dev/null || fail "controlled baseline result mismatch"

n1="${tmp_dir}/DOC-LANG-N1"
init_fixture "${n1}"
tokens=(de module gebruikt een regel voor het pad)
printf '%s\n' "${tokens[*]}" >"${n1}/GAMP/FS/FS-164-negative.md"
git -C "${n1}" add GAMP/FS/FS-164-negative.md
expect_failure DOC-LANG-N1 DOC_NON_ENGLISH_NORMATIVE "${checker}" scan "${n1}"
jq -s -e '
  length == 3
  and ([.[].line] | unique) == [1]
  and ([.[].rule] | sort) == ["nl-article-de", "nl-article-een", "nl-article-het"]
  and all(.[]; .path | endswith("/GAMP/FS/FS-164-negative.md"))
' "${tmp_dir}/DOC-LANG-N1.stderr" >/dev/null || fail "DOC-LANG-N1 exact hit set mismatch"
printf '%s\n' 'The module uses one rule for the path.' >"${n1}/GAMP/FS/FS-164-negative.md"
"${checker}" scan "${n1}" >/dev/null || fail "DOC-LANG-N1 recovery failed"

n2="${tmp_dir}/DOC-LANG-N2"
init_fixture "${n2}"
printf '%s\n' 'The deduplicated ethernet screen remains valid.' >"${n2}/GAMP/FS/FS-164-substrings.md"
git -C "${n2}" add GAMP/FS/FS-164-substrings.md
"${checker}" scan "${n2}" >/dev/null || fail "DOC-LANG-N2 substring false positive"

n3="${tmp_dir}/DOC-LANG-N3"
init_fixture "${n3}"
printf '%s\n' 'This draft is not yet classified.' >"${n3}/GAMP/FS/unclassified.md"
expect_failure DOC-LANG-N3 DOC_UNCLASSIFIED_TEXT "${checker}" scan "${n3}"
jq -s -e '
  length == 1
  and .[0].line == null
  and (.[0].path | endswith("/GAMP/FS/unclassified.md"))
' "${tmp_dir}/DOC-LANG-N3.stderr" >/dev/null || fail "DOC-LANG-N3 path or line mismatch"
git -C "${n3}" add GAMP/FS/unclassified.md
"${checker}" scan "${n3}" >/dev/null || fail "DOC-LANG-N3 recovery failed"

n4="${tmp_dir}/DOC-LANG-N4"
init_fixture "${n4}"
printf '\377\376\375' >"${n4}/GAMP/FS/FS-164-invalid-utf8.md"
git -C "${n4}" add GAMP/FS/FS-164-invalid-utf8.md
expect_failure DOC-LANG-N4 DOC_DECODE_FAILED "${checker}" scan "${n4}"
jq -s -e '
  length == 1
  and .[0].line == null
  and (.[0].path | endswith("/GAMP/FS/FS-164-invalid-utf8.md"))
' "${tmp_dir}/DOC-LANG-N4.stderr" >/dev/null || fail "DOC-LANG-N4 path or line mismatch"
printf '%s\n' 'The repaired document is valid UTF-8.' >"${n4}/GAMP/FS/FS-164-invalid-utf8.md"
"${checker}" scan "${n4}" >/dev/null || fail "DOC-LANG-N4 recovery failed"

public_address="$(printf '%s.%s.%s.%s' 8 8 4 4)"
expect_failure DOC-LANG-N5 DOC_DIAGNOSTIC_PRIVACY_LEAK \
  "${checker}" probe public-address GAMP/FS/FS-164-private.md 1 "${public_address}"
if grep -Fq "${public_address}" "${tmp_dir}/DOC-LANG-N5.stderr"; then
  fail "DOC-LANG-N5 leaked the classified value"
fi
n5="${tmp_dir}/DOC-LANG-N5-recovery"
init_fixture "${n5}"
printf '%s\n' 'The diagnostic value is redacted.' >"${n5}/GAMP/FS/FS-164-private.md"
git -C "${n5}" add GAMP/FS/FS-164-private.md
"${checker}" scan "${n5}" >/dev/null || fail "DOC-LANG-N5 recovery failed"

printf 'PASS FS-164-HDS-010-SDS-010-SMS-010: baseline plus DOC-LANG-N1..N5 and recovery\n'
