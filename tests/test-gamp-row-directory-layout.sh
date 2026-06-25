#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
manifest_file="${repo_root}/GAMP/SMT/mini-smt/tests.nix"

fail() {
  echo "FAIL gamp-row-directory-layout: $*" >&2
  exit 1
}

validate_row_dir() {
  local layer="$1"
  local dir="$2"
  local name
  name="$(basename "${dir}")"

  case "${layer}:${name}" in
    SMT:FS-[0-9][0-9][0-9]-HDS-[0-9][0-9][0-9]-SDS-[0-9][0-9][0-9]-SMS-[0-9][0-9][0-9]) ;;
    SIT:FS-[0-9][0-9][0-9]-HDS-[0-9][0-9][0-9]-SDS-[0-9][0-9][0-9]) ;;
    SMT:*) fail "SMT row directory must be SMS-scoped: ${dir}" ;;
    SIT:*) fail "SIT row directory must be SDS-scoped, not SMS-scoped: ${dir}" ;;
  esac

  [[ -f "${dir}/default.nix" ]] || fail "${dir} missing default.nix"
  [[ -f "${dir}/README.md" ]] || fail "${dir} missing README.md"

  nix eval --impure --expr "
    let
      row = import ${dir}/default.nix;
      require = cond: msg: if cond then true else throw msg;
      smsInputNames = builtins.attrNames (row.smsInputs or {});
      smsPrefixOk =
        builtins.all
          (sms: builtins.match \"${name}-SMS-[0-9][0-9][0-9]\" sms != null)
          smsInputNames;
      smsInputShapeOk =
        builtins.all
          (sms:
            let input = builtins.getAttr sms row.smsInputs;
            in
              input ? smtRow
              && input ? sourcePath
              && toString input.smtRow == \"${repo_root}/GAMP/SMT/\" + sms
          )
          smsInputNames;
    in
      require (row.layer == \"${layer}\") \"${dir}: row.layer mismatch\"
      && require (row.traceId == \"${name}\") \"${dir}: traceId must equal directory name\"
      && require (
        if \"${layer}\" == \"SIT\" then
          smsInputNames != [ ] && smsPrefixOk && smsInputShapeOk
        else
          true
      ) \"${dir}: SIT rows must define one or more matching SMS inputs\"
  " >/dev/null || fail "${dir} metadata check failed"
}

while IFS= read -r dir || [[ -n "${dir}" ]]; do
  validate_row_dir SMT "${dir}"
done < <(find "${repo_root}/GAMP/SMT" -mindepth 1 -maxdepth 1 -type d -name 'FS-*' | sort)

while IFS= read -r dir || [[ -n "${dir}" ]]; do
  validate_row_dir SIT "${dir}"
done < <(find "${repo_root}/GAMP/SIT" -mindepth 1 -maxdepth 1 -type d -name 'FS-*' | sort)

nix eval --impure --expr "
  let
    sitRoot = \"${repo_root}/GAMP/SIT\";
    names =
      builtins.filter
        (name: builtins.match \"FS-[0-9][0-9][0-9]-HDS-[0-9][0-9][0-9]-SDS-[0-9][0-9][0-9]\" name != null)
        (builtins.attrNames (builtins.readDir sitRoot));
    rows = map (name: import (sitRoot + \"/\" + name + \"/default.nix\")) names;
    require = cond: msg: if cond then true else throw msg;
    hasMultiSmsInput =
      builtins.any
        (row: builtins.length (builtins.attrNames (row.smsInputs or {})) > 1)
        rows;
  in
    require hasMultiSmsInput \"at least one SIT SDS row must declare multiple SMS inputs\"
" >/dev/null || fail "SIT SDS multi-SMS input contract failed"

nix eval --impure --expr "
  let
    manifest = import ${manifest_file};
    names = builtins.attrNames manifest.tests;
    require = cond: msg: if cond then true else throw msg;
    smsTracePrefix =
      trace:
        let match = builtins.match \"(FS-[0-9][0-9][0-9]-HDS-[0-9][0-9][0-9]-SDS-[0-9][0-9][0-9])-SMS-[0-9][0-9][0-9]\" trace;
        in if match == null then null else builtins.head match;
    intentRows =
      builtins.filter
        (name: (builtins.getAttr name manifest.tests).source.kind == \"intent-source\")
        names;
    rowOk =
      name:
        let
          entry = builtins.getAttr name manifest.tests;
          sitTrace = smsTracePrefix entry.traceId;
          smtDir = toString entry.rowDirectories.SMT;
          sitDir = toString entry.rowDirectories.SIT;
        in
          entry ? rowDirectories
          && entry.rowDirectories ? SMT
          && entry.rowDirectories ? SIT
          && smtDir == \"${repo_root}/GAMP/SMT/\" + entry.traceId
          && sitTrace != null
          && sitDir == \"${repo_root}/GAMP/SIT/\" + sitTrace
          && toString entry.source.intent == smtDir + \"/intent.nix\";
  in
    require (intentRows != [ ]) \"manifest must have at least one intent-source row\"
    && require (builtins.all rowOk intentRows) \"intent-source rows must use SMT SMS dirs and SIT SDS dirs\"
" >/dev/null || fail "mini SMT manifest row-directory contract failed"

echo "PASS gamp-row-directory-layout"
