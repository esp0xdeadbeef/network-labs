#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
canonical_sms_dir="${CANONICAL_SMS_DIR:-/home/deadbeef/github/network-codex-agent/GAMP/SMS}"
forbidden_renderer_prefix="R""D""R-"
forbidden_renderer_token="R""D""R"

if [[ ! -d "${canonical_sms_dir}" ]]; then
  echo "FAIL canonical SMS directory not found: ${canonical_sms_dir}" >&2
  exit 2
fi

tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

if grep -R --fixed-strings "${forbidden_renderer_token}" "${canonical_sms_dir}" >/dev/null; then
  echo "FAIL disallowed renderer-prefixed token remains under canonical SMS directory:" >&2
  grep -R -n --fixed-strings "${forbidden_renderer_token}" "${canonical_sms_dir}" >&2
  exit 1
fi

trace_for_file() {
  local file="$1"
  local stem="${file%.md}"
  if [[ "${stem}" =~ ^(FS-[0-9]+-HDS-[0-9]+-SDS-[0-9]+-SMS-[0-9]+) ]]; then
    printf '%s\n' "${BASH_REMATCH[1]}"
    return 0
  fi
  return 1
}

canonical="${tmp_dir}/canonical.txt"
while IFS= read -r file; do
  if [[ "${file}" == *"${forbidden_renderer_prefix}"* ]]; then
    echo "FAIL disallowed renderer-prefixed canonical SMS filename: ${file}" >&2
    exit 1
  fi
  trace_for_file "${file}"
done < <(find "${canonical_sms_dir}" -mindepth 1 -maxdepth 1 -type f -name 'FS-*.md' -printf '%f\n' | sort) \
  | sort >"${canonical}"

if find "${repo_root}/GAMP" -path "*${forbidden_renderer_prefix}*" -print -quit | grep -q .; then
  echo "FAIL disallowed renderer-prefixed path under network-labs/GAMP" >&2
  find "${repo_root}/GAMP" -path "*${forbidden_renderer_prefix}*" -print >&2
  exit 1
fi

duplicates="${tmp_dir}/duplicates.txt"
uniq -d "${canonical}" >"${duplicates}"
if [[ -s "${duplicates}" ]]; then
  echo "FAIL duplicate canonical SMS trace IDs:" >&2
  cat "${duplicates}" >&2
  exit 1
fi

canonical_unique="${tmp_dir}/canonical-unique.txt"
sort -u "${canonical}" >"${canonical_unique}"

sms_dirs="${tmp_dir}/sms-dirs.txt"
find "${repo_root}/GAMP/SMS" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' \
  | awk '/^FS-[0-9]+-HDS-[0-9]+-SDS-[0-9]+-SMS-[0-9]+$/ { print }' \
  | sort >"${sms_dirs}"

smt_dirs="${tmp_dir}/smt-dirs.txt"
find "${repo_root}/GAMP/SMT" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' \
  | awk '/^FS-[0-9]+-HDS-[0-9]+-SDS-[0-9]+-SMS-[0-9]+$/ { print }' \
  | sort >"${smt_dirs}"

sds_dirs="${tmp_dir}/sds-dirs.txt"
find "${repo_root}/GAMP/SDS" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' \
  | awk '/^FS-[0-9]+-HDS-[0-9]+-SDS-[0-9]+$/ { print }' \
  | sort >"${sds_dirs}"

missing_sms="${tmp_dir}/missing-sms.txt"
missing_smt="${tmp_dir}/missing-smt.txt"
comm -23 "${canonical_unique}" "${sms_dirs}" >"${missing_sms}"
comm -23 "${canonical_unique}" "${smt_dirs}" >"${missing_smt}"

if [[ -s "${missing_sms}" ]]; then
  echo "FAIL network-labs GAMP/SMS is missing canonical traces:" >&2
  cat "${missing_sms}" >&2
  exit 1
fi

if [[ -s "${missing_smt}" ]]; then
  echo "FAIL network-labs GAMP/SMT is missing canonical traces:" >&2
  cat "${missing_smt}" >&2
  exit 1
fi

canonical_sds="${tmp_dir}/canonical-sds.txt"
sed -E 's/-SMS-[0-9]+$//' "${canonical_unique}" | sort -u >"${canonical_sds}"

missing_sds="${tmp_dir}/missing-sds.txt"
comm -23 "${canonical_sds}" "${sds_dirs}" >"${missing_sds}"
if [[ -s "${missing_sds}" ]]; then
  echo "FAIL network-labs GAMP/SDS is missing canonical SDS traces:" >&2
  cat "${missing_sds}" >&2
  exit 1
fi

sit_dirs="${tmp_dir}/sit-dirs.txt"
find "${repo_root}/GAMP/SIT" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' \
  | awk '/^FS-[0-9]+-HDS-[0-9]+-SDS-[0-9]+$/ { print }' \
  | sort >"${sit_dirs}"

missing_sit="${tmp_dir}/missing-sit.txt"
comm -23 "${canonical_sds}" "${sit_dirs}" >"${missing_sit}"
if [[ -s "${missing_sit}" ]]; then
  echo "FAIL network-labs GAMP/SIT is missing canonical SDS traces:" >&2
  cat "${missing_sit}" >&2
  exit 1
fi

while IFS= read -r trace; do
  for path in \
    "GAMP/SMS/${trace}/README.md" \
    "GAMP/SMS/${trace}/default.nix" \
    "GAMP/SMT/${trace}/README.md" \
    "GAMP/SMT/${trace}/default.nix" \
    "GAMP/SMT/${trace}/intent.nix" \
    "GAMP/SMT/${trace}/inventory-clab.nix" \
    "GAMP/SMT/${trace}/inventory-nixos.nix" \
    "GAMP/SMT/${trace}/inventory-test-clients.nix"; do
    if [[ ! -f "${repo_root}/${path}" ]]; then
      echo "FAIL missing canonical mirror file: ${path}" >&2
      exit 1
    fi
  done
done <"${canonical_unique}"

printf 'PASS canonical SMS mirror: %s SMS traces, %s SIT SDS traces\n' \
  "$(wc -l <"${canonical_unique}")" \
  "$(wc -l <"${canonical_sds}")"
