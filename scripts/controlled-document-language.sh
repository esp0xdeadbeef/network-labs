#!/usr/bin/env bash
set -euo pipefail

contract="${CONTROLLED_DOCUMENT_LANGUAGE_CONTRACT:?CONTROLLED_DOCUMENT_LANGUAGE_CONTRACT is required}"
trace_id="$(jq -er '.traceId' "${contract}")"
rule_identity="$(jq -er '.ruleIdentity' "${contract}")"
diagnostic_count=0
corpus_count=0
exclusion_count=0

usage() {
  printf 'usage: controlled-document-language {scan ROOT...|probe CLASS PATH LINE VALUE}\n' >&2
  exit 64
}

emit_record() {
  local code="$1"
  local path="$2"
  local line="$3"
  local rule="$4"

  jq -nc \
    --arg code "${code}" \
    --arg path "${path}" \
    --arg line "${line}" \
    --arg rule "${rule}" \
    --arg traceId "${trace_id}" \
    '{code: $code, path: $path, line: (if $line == "" then null else ($line | tonumber) end), rule: $rule, traceId: $traceId}' \
    >&2
  diagnostic_count=$((diagnostic_count + 1))
}

emit_diagnostic() {
  local code="$1"
  local path="$2"
  local line="$3"
  local rule="$4"
  local classification="${5:-safe}"
  local candidate_detail="${6:-}"

  if [[ "${classification}" != "safe" ]] \
    || grep -Eq '(^|[^0-9])([0-9]{1,3}[.]){3}[0-9]{1,3}([^0-9]|$)|[[:xdigit:]]*:[[:xdigit:].:]+' <<<"${candidate_detail}"; then
    emit_record "DOC_DIAGNOSTIC_PRIVACY_LEAK" "${path}" "" "diagnostic-safety"
  else
    emit_record "${code}" "${path}" "${line}" "${rule}"
  fi
}

scan_files() {
  local root_name="$1"
  local root="$2"
  shift 2
  local files=("$@")
  local decodable=()
  local file
  local relative
  local rule
  local line
  local path
  local rule_data

  ((${#files[@]} > 0)) || return
  corpus_count=$((corpus_count + ${#files[@]}))

  if iconv -f UTF-8 -t UTF-8 "${files[@]}" >/dev/null 2>&1; then
    decodable=("${files[@]}")
  else
    for file in "${files[@]}"; do
      relative="${file#"${root}/"}"
      if iconv -f UTF-8 -t UTF-8 "${file}" >/dev/null 2>&1; then
        decodable+=("${file}")
      else
        emit_diagnostic "DOC_DECODE_FAILED" "${root_name}/${relative}" "" "utf8" "safe"
      fi
    done
  fi

  ((${#decodable[@]} > 0)) || return
  rule_data="$(jq -r '.indicators[] | [.rule, .token] | @tsv' "${contract}")"
  while IFS=$'\t' read -r path line rule; do
    [[ -n "${path}" ]] || continue
    relative="${path#"${root}/"}"
    emit_diagnostic \
      "DOC_NON_ENGLISH_NORMATIVE" \
      "${root_name}/${relative}" \
      "${line}" \
      "${rule}" \
      "safe"
  done < <(
    CONTROLLED_DOCUMENT_LANGUAGE_RULES="${rule_data}" LC_ALL=C awk '
      BEGIN {
        count = split(ENVIRON["CONTROLLED_DOCUMENT_LANGUAGE_RULES"], rows, "\n")
        for (i = 1; i <= count; i++) {
          split(rows[i], columns, "\t")
          rules[i] = columns[1]
          tokens[i] = columns[2]
        }
      }
      {
        lowered = tolower($0)
        for (i = 1; i <= count; i++) {
          pattern = "(^|[^[:alnum:]_])" tokens[i] "([^[:alnum:]_]|$)"
          if (lowered ~ pattern) {
            print FILENAME "\t" FNR "\t" rules[i]
          }
        }
      }
    ' "${decodable[@]}"
  )
}

scan_root() {
  local root
  root="$(realpath "$1")"
  local root_name
  root_name="$(basename "${root}")"
  local controlled_root="${root}/GAMP"
  local relative
  local file
  local has_git=false
  local normative_files=()
  declare -A tracked=()

  [[ -d "${controlled_root}" ]] || {
    emit_diagnostic "DOC_UNCLASSIFIED_TEXT" "${root_name}/GAMP" "" "controlled-root-missing" "safe"
    return
  }

  if git -C "${root}" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    has_git=true
    while IFS= read -r -d '' relative; do
      tracked["${relative}"]=1
    done < <(git -C "${root}" ls-files -z -- GAMP)
  fi

  while IFS= read -r -d '' file; do
    relative="${file#"${root}/"}"
    case "${relative}" in
      *.md|*.txt)
        if [[ "${has_git}" == true && -z "${tracked[${relative}]+present}" ]]; then
          emit_diagnostic "DOC_UNCLASSIFIED_TEXT" "${root_name}/${relative}" "" "git-controlled-corpus" "safe"
        else
          normative_files+=("${file}")
        fi
        ;;
      *)
        exclusion_count=$((exclusion_count + 1))
        ;;
    esac
  done < <(find "${controlled_root}" -type f -print0 | LC_ALL=C sort -z)

  scan_files "${root_name}" "${root}" "${normative_files[@]}"
}

command="${1:-}"
shift || true
case "${command}" in
  scan)
    (($# > 0)) || usage
    for root in "$@"; do
      scan_root "${root}"
    done
    if ((diagnostic_count > 0)); then
      exit 2
    fi
    jq -nc \
      --arg traceId "${trace_id}" \
      --arg ruleIdentity "${rule_identity}" \
      --argjson corpusFiles "${corpus_count}" \
      --argjson exclusions "${exclusion_count}" \
      '{traceId: $traceId, ruleIdentity: $ruleIdentity, corpusFiles: $corpusFiles, exclusions: $exclusions, violations: 0}'
    ;;
  probe)
    (($# == 4)) || usage
    emit_diagnostic "DOC_NON_ENGLISH_NORMATIVE" "$2" "$3" "probe" "$1" "$4"
    exit 2
    ;;
  *)
    usage
    ;;
esac
