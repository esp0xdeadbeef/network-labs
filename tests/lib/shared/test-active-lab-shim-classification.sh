#!/usr/bin/env bash
# GAMP-SCOPE: active-lab selector inventory and source-stub classification; not HAT/SAT runtime evidence
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
canonical_sms_dir="${CANONICAL_SMS_DIR:-/home/deadbeef/github/network-codex-agent/GAMP/SMS}"

fail() {
  echo "FAIL active-lab-shim-classification: $*" >&2
  exit 1
}

require_file() {
  [[ -f "$1" ]] || fail "missing file: $1"
}

tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

require_file "${repo_root}/GAMP/SMT/mini-smt/tests.nix"
require_file "${repo_root}/scripts/select-current-lab.sh"
require_file "${repo_root}/tests/run-active-lab-mini-smt.sh"
[[ -d "${canonical_sms_dir}" ]] || fail "canonical SMS directory not found: ${canonical_sms_dir}"

find "${canonical_sms_dir}" -maxdepth 1 -type f -name 'FS-*-HDS-*-SDS-*-SMS-*.md' -printf '%f\n' \
  | sed -E 's/^(FS-[0-9]+-HDS-[0-9]+-SDS-[0-9]+-SMS-[0-9]+).*/\1/' \
  | sort >"${tmp_dir}/canonical-sms.txt"

[[ -s "${tmp_dir}/canonical-sms.txt" ]] || fail "no canonical SMS files found"

uniq -d "${tmp_dir}/canonical-sms.txt" >"${tmp_dir}/duplicate-sms.txt"
[[ ! -s "${tmp_dir}/duplicate-sms.txt" ]] || {
  cat "${tmp_dir}/duplicate-sms.txt" >&2
  fail "duplicate canonical SMS IDs"
}

if rg -n 'RDR-FS|RDR-SMS|RDR-[0-9]|RDR_' "${canonical_sms_dir}" "${repo_root}/GAMP" >/dev/null; then
  rg -n 'RDR-FS|RDR-SMS|RDR-[0-9]|RDR_' "${canonical_sms_dir}" "${repo_root}/GAMP" >&2
  fail "disallowed RDR-prefixed form remains"
fi

find "${repo_root}/GAMP/SMS" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' \
  | awk '/^FS-[0-9]+-HDS-[0-9]+-SDS-[0-9]+-SMS-[0-9]+$/ { print }' \
  | sort >"${tmp_dir}/labs-sms.txt"
find "${repo_root}/GAMP/SMT" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' \
  | awk '/^FS-[0-9]+-HDS-[0-9]+-SDS-[0-9]+-SMS-[0-9]+$/ { print }' \
  | sort >"${tmp_dir}/labs-smt.txt"
find "${repo_root}/GAMP/SDS" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' \
  | awk '/^FS-[0-9]+-HDS-[0-9]+-SDS-[0-9]+$/ { print }' \
  | sort >"${tmp_dir}/labs-sds.txt"
find "${repo_root}/GAMP/SIT" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' \
  | awk '/^FS-[0-9]+-HDS-[0-9]+-SDS-[0-9]+$/ { print }' \
  | sort >"${tmp_dir}/labs-sit.txt"

sed -E 's/-SMS-[0-9]+$//' "${tmp_dir}/canonical-sms.txt" | sort -u >"${tmp_dir}/canonical-sds.txt"

comm -23 "${tmp_dir}/canonical-sms.txt" "${tmp_dir}/labs-sms.txt" >"${tmp_dir}/missing-labs-sms.txt"
comm -23 "${tmp_dir}/canonical-sms.txt" "${tmp_dir}/labs-smt.txt" >"${tmp_dir}/missing-labs-smt.txt"
comm -13 "${tmp_dir}/canonical-sms.txt" "${tmp_dir}/labs-sms.txt" >"${tmp_dir}/extra-labs-sms.txt"
comm -13 "${tmp_dir}/canonical-sms.txt" "${tmp_dir}/labs-smt.txt" >"${tmp_dir}/extra-labs-smt.txt"
comm -23 "${tmp_dir}/canonical-sds.txt" "${tmp_dir}/labs-sds.txt" >"${tmp_dir}/missing-labs-sds.txt"
comm -23 "${tmp_dir}/canonical-sds.txt" "${tmp_dir}/labs-sit.txt" >"${tmp_dir}/missing-labs-sit.txt"

for missing in missing-labs-sms missing-labs-smt missing-labs-sds missing-labs-sit; do
  if [[ -s "${tmp_dir}/${missing}.txt" ]]; then
    cat "${tmp_dir}/${missing}.txt" >&2
    fail "${missing}"
  fi
done

cat >"${tmp_dir}/expected-extra-sms.txt" <<'EOF'
FS-166-HDS-010-SDS-010-SMS-901
FS-166-HDS-010-SDS-010-SMS-902
FS-166-HDS-010-SDS-010-SMS-903
FS-720-HDS-010-SDS-020-SMS-040
FS-800-HDS-030-SDS-030-SMS-040
EOF

diff -u "${tmp_dir}/expected-extra-sms.txt" "${tmp_dir}/extra-labs-sms.txt" \
  || fail "unexpected lab-local SMS row set"
diff -u "${tmp_dir}/expected-extra-sms.txt" "${tmp_dir}/extra-labs-smt.txt" \
  || fail "unexpected lab-local SMT row set"

"${repo_root}/tests/run-active-lab-mini-smt.sh" --list | sed '/^$/d' | sort >"${tmp_dir}/runner-smt.txt"
"${repo_root}/scripts/select-current-lab.sh" --list >"${tmp_dir}/selector.txt"
awk '$1 == "SMT" { print $2 }' "${tmp_dir}/selector.txt" | sort >"${tmp_dir}/selector-smt.txt"
awk '$1 == "SIT" { print $2 }' "${tmp_dir}/selector.txt" | sort >"${tmp_dir}/selector-sit.txt"
awk '$1 == "HAT" { print $0 }' "${tmp_dir}/selector.txt" | sort >"${tmp_dir}/selector-hat.txt"
awk '$1 == "SAT" { print $0 }' "${tmp_dir}/selector.txt" | sort >"${tmp_dir}/selector-sat.txt"

diff -u "${tmp_dir}/runner-smt.txt" "${tmp_dir}/selector-smt.txt" \
  || fail "selector SMT rows must match mini-SMT manifest rows"

nix eval --impure --raw --expr "
let
  manifest = import ${repo_root}/GAMP/SMT/mini-smt/tests.nix;
  ids = builtins.attrNames manifest.tests;
  sdsFor = id:
    let trace = manifest.tests.\${id}.traceId;
    in builtins.elemAt (builtins.match \"(FS-[0-9]+-HDS-[0-9]+-SDS-[0-9]+)-SMS-[0-9]+.*\" trace) 0;
  addUnique = acc: value: if builtins.elem value acc then acc else acc ++ [ value ];
  unique = builtins.foldl' addUnique [ ] (map sdsFor ids);
in
  builtins.concatStringsSep \"\n\" (builtins.sort (left: right: left < right) unique)
" | sed '/^$/d' | sort >"${tmp_dir}/manifest-sit.txt"

diff -u "${tmp_dir}/manifest-sit.txt" "${tmp_dir}/selector-sit.txt" \
  || fail "selector SIT rows must match manifest-derived SDS rows"

grep -qx 'HAT emulated-isp-residential-testnet' "${tmp_dir}/selector-hat.txt" \
  || fail "missing HAT selector"
grep -qx 'SAT' "${tmp_dir}/selector-sat.txt" \
  || fail "missing SAT selector"

canonical_sms_count="$(wc -l <"${tmp_dir}/canonical-sms.txt")"
labs_sms_count="$(wc -l <"${tmp_dir}/labs-sms.txt")"
labs_smt_count="$(wc -l <"${tmp_dir}/labs-smt.txt")"
labs_sds_count="$(wc -l <"${tmp_dir}/labs-sds.txt")"
labs_sit_count="$(wc -l <"${tmp_dir}/labs-sit.txt")"
runnable_smt_count="$(wc -l <"${tmp_dir}/runner-smt.txt")"
runnable_sit_count="$(wc -l <"${tmp_dir}/selector-sit.txt")"
runnable_hat_count="$(wc -l <"${tmp_dir}/selector-hat.txt")"
runnable_sat_count="$(wc -l <"${tmp_dir}/selector-sat.txt")"
source_stub_smt_count="$(rg -l 'evidenceBoundary = "source-stub-only"' "${repo_root}"/GAMP/SMT/*/default.nix | wc -l)"
source_stub_sit_count="$(rg -l 'evidenceBoundary = "source-stub-only"' "${repo_root}"/GAMP/SIT/*/default.nix | wc -l)"

for fs165_trace in \
  FS-165-HDS-010-SDS-010-SMS-020 \
  FS-165-HDS-010-SDS-010-SMS-030
do
  fs165_source="$("${repo_root}/tests/run-active-lab-mini-smt.sh" --source "${fs165_trace}")"
  grep -Fx 'kind=construction-only' <<<"${fs165_source}" >/dev/null \
    || fail "${fs165_trace} must be classified as construction-only despite stale manifest source"
  grep -Fx 'evidenceBoundary=construction-only' <<<"${fs165_source}" >/dev/null \
    || fail "${fs165_trace} effective boundary must be construction-only"
  grep -Fx 'maxRuntimeTargets=0' <<<"${fs165_source}" >/dev/null \
    || fail "${fs165_trace} construction-only shim must expose zero runtime targets"
  grep -q '^intent=' <<<"${fs165_source}" \
    && fail "${fs165_trace} construction-only shim must not expose a runtime intent source"
  grep -q '^cpm=' <<<"${fs165_source}" \
    && fail "${fs165_trace} construction-only shim must not expose a runtime CPM source"
done
grep -F 'MINI_SMT_OFFLINE_VERIFY:-0' "${repo_root}/tests/run-active-lab-mini-smt.sh" >/dev/null \
  || fail "offline compiler/NFM/CPM verifier must be opt-in, not default"

for fs165_trace in \
  FS-165-HDS-010-SDS-010-SMS-020 \
  FS-165-HDS-010-SDS-010-SMS-030
do
  fs165_current="${tmp_dir}/fs165-current-lab-${fs165_trace}"
  NETWORK_LABS_CURRENT_LAB_DIR="${fs165_current}" \
    "${repo_root}/scripts/select-current-lab.sh" SMT "${fs165_trace}" >/dev/null
  grep -F 'sourceKind = "construction-only";' "${fs165_current}/metadata.nix" >/dev/null \
    || fail "${fs165_trace} selector metadata must use construction-only sourceKind"
  grep -F 'constructionOnly = true;' "${fs165_current}/intent.nix" >/dev/null \
    || fail "${fs165_trace} selector must write construction-only active-lab stub"
done

[[ "${canonical_sms_count}" == "533" ]] || fail "canonical SMS count changed: ${canonical_sms_count}"
[[ "${labs_sms_count}" == "538" ]] || fail "network-labs SMS dir count changed: ${labs_sms_count}"
[[ "${labs_smt_count}" == "538" ]] || fail "network-labs SMT dir count changed: ${labs_smt_count}"
[[ "${labs_sds_count}" == "178" ]] || fail "network-labs SDS dir count changed: ${labs_sds_count}"
[[ "${labs_sit_count}" == "178" ]] || fail "network-labs SIT dir count changed: ${labs_sit_count}"
[[ "${runnable_smt_count}" == "529" ]] || fail "runnable SMT selector count changed: ${runnable_smt_count}"
[[ "${runnable_sit_count}" == "177" ]] || fail "runnable SIT selector count changed: ${runnable_sit_count}"
[[ "${runnable_hat_count}" == "1" ]] || fail "runnable HAT selector count changed: ${runnable_hat_count}"
[[ "${runnable_sat_count}" == "1" ]] || fail "runnable SAT selector count changed: ${runnable_sat_count}"

printf 'PASS active-lab-shim-classification: canonical_sms=%s lab_sms=%s lab_smt=%s lab_sds=%s lab_sit=%s source_stub_smt=%s source_stub_sit=%s runnable_smt=%s runnable_sit=%s runnable_hat=%s runnable_sat=%s\n' \
  "${canonical_sms_count}" \
  "${labs_sms_count}" \
  "${labs_smt_count}" \
  "${labs_sds_count}" \
  "${labs_sit_count}" \
  "${source_stub_smt_count}" \
  "${source_stub_sit_count}" \
  "${runnable_smt_count}" \
  "${runnable_sit_count}" \
  "${runnable_hat_count}" \
  "${runnable_sat_count}"
