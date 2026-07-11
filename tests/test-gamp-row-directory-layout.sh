#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
manifest_file="${repo_root}/GAMP/SMT/mini-smt/tests.nix"

fail() {
  echo "FAIL gamp-row-directory-layout: $*" >&2
  exit 1
}

while IFS= read -r name || [[ -n "${name}" ]]; do
  case "${name}" in
    mini-smt) ;;
    FS-[0-9][0-9][0-9]-HDS-[0-9][0-9][0-9]-SDS-[0-9][0-9][0-9]-SMS-[0-9][0-9][0-9]) ;;
    *) fail "SMT top-level directory must be canonical SMS-scoped or mini-smt manifest: ${name}" ;;
  esac
done < <(find "${repo_root}/GAMP/SMT" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort)

while IFS= read -r name || [[ -n "${name}" ]]; do
  case "${name}" in
    FS-[0-9][0-9][0-9]-HDS-[0-9][0-9][0-9]-SDS-[0-9][0-9][0-9]) ;;
    *) fail "SIT top-level directory must be canonical SDS-scoped: ${name}" ;;
  esac
done < <(find "${repo_root}/GAMP/SIT" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort)

validate_row_dir() {
  local layer="$1"
  local dir="$2"
  local name
  name="$(basename "${dir}")"

  case "${layer}:${name}" in
    SDS:FS-[0-9][0-9][0-9]-HDS-[0-9][0-9][0-9]-SDS-[0-9][0-9][0-9]) ;;
    SMS:FS-[0-9][0-9][0-9]-HDS-[0-9][0-9][0-9]-SDS-[0-9][0-9][0-9]-SMS-[0-9][0-9][0-9]) ;;
    SMT:FS-[0-9][0-9][0-9]-HDS-[0-9][0-9][0-9]-SDS-[0-9][0-9][0-9]-SMS-[0-9][0-9][0-9]) ;;
    SIT:FS-[0-9][0-9][0-9]-HDS-[0-9][0-9][0-9]-SDS-[0-9][0-9][0-9]) ;;
    SDS:*) fail "SDS row directory must be SDS-scoped: ${dir}" ;;
    SMS:*) fail "SMS row directory must be SMS-scoped: ${dir}" ;;
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
      sourceInputNames = builtins.attrNames (row.sourceInputs or {});
      smsPrefixOk =
        builtins.all
          (sms: builtins.match \"${name}-SMS-[0-9][0-9][0-9]\" sms != null)
          smsInputNames;
      parentSds =
        let match = builtins.match \"(FS-[0-9][0-9][0-9]-HDS-[0-9][0-9][0-9]-SDS-[0-9][0-9][0-9])-SMS-[0-9][0-9][0-9]\" \"${name}\";
        in if match == null then null else builtins.head match;
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
      sdsSmsInputShapeOk =
        builtins.all
          (sms:
            let input = builtins.getAttr sms row.smsInputs;
            in
              input ? smsRow
              && input ? miniSmtIds
              && input ? inputKinds
              && input.miniSmtIds != [ ]
              && input.inputKinds != [ ]
              && toString input.smsRow == \"${repo_root}/GAMP/SMS/\" + sms
          )
          smsInputNames;
      sourceInputShapeOk =
        builtins.all
          (inputName:
            let input = builtins.getAttr inputName row.sourceInputs;
            in
              input ? kind
              && input ? sourcePath
              && input ? test
              && input ? maxRuntimeTargets
              && builtins.pathExists (\"${repo_root}/\" + input.sourcePath)
              && builtins.pathExists (\"${repo_root}/\" + input.test)
          )
          sourceInputNames;
    in
      require (row.layer == \"${layer}\") \"${dir}: row.layer mismatch\"
      && require (row.traceId == \"${name}\") \"${dir}: traceId must equal directory name\"
      && require (
        if \"${layer}\" == \"SIT\" then
          smsInputNames != [ ] && smsPrefixOk && smsInputShapeOk
        else
          true
      ) \"${dir}: SIT rows must define one or more matching SMS inputs\"
      && require (
        if \"${layer}\" == \"SDS\" then
          smsInputNames != [ ] && smsPrefixOk && sdsSmsInputShapeOk
        else
          true
      ) \"${dir}: SDS rows must define one or more matching SMS template inputs\"
      && require (
        if \"${layer}\" == \"SMS\" then
          parentSds != null
          && toString row.parentSds == \"${repo_root}/GAMP/SDS/\" + parentSds
          && sourceInputNames != [ ]
          && sourceInputShapeOk
        else
          true
      ) \"${dir}: SMS rows must define sourceInputs and parent SDS\"
  " >/dev/null || fail "${dir} metadata check failed"
}

while IFS= read -r dir || [[ -n "${dir}" ]]; do
  validate_row_dir SDS "${dir}"
done < <(find "${repo_root}/GAMP/SDS" -mindepth 1 -maxdepth 1 -type d -name 'FS-*' | sort)

while IFS= read -r dir || [[ -n "${dir}" ]]; do
  validate_row_dir SMS "${dir}"
done < <(find "${repo_root}/GAMP/SMS" -mindepth 1 -maxdepth 1 -type d -name 'FS-*' | sort)

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
    smsTrace =
      trace:
        let match = builtins.match \"(FS-[0-9][0-9][0-9]-HDS-[0-9][0-9][0-9]-SDS-[0-9][0-9][0-9]-SMS-[0-9][0-9][0-9]).*\" trace;
        in if match == null then null else builtins.head match;
    smsTracePrefix =
      trace:
        let match = builtins.match \"(FS-[0-9][0-9][0-9]-HDS-[0-9][0-9][0-9]-SDS-[0-9][0-9][0-9])-SMS-[0-9][0-9][0-9]\" trace;
        in if match == null then null else builtins.head match;
    intentRows =
      builtins.filter
        (name:
          let entry = builtins.getAttr name manifest.tests;
          in entry ? source && entry.source != null && (entry.source.kind or null) == \"intent-source\")
        names;
    rowOk =
      name:
        let
          entry = builtins.getAttr name manifest.tests;
          entrySmsTrace = smsTrace entry.traceId;
          sdsTrace = if entrySmsTrace == null then null else smsTracePrefix entrySmsTrace;
          sdsDir = toString entry.rowDirectories.SDS;
          smsDir = toString entry.rowDirectories.SMS;
          smsRow = import (entry.rowDirectories.SMS + \"/default.nix\");
          sourceInputs = smsRow.sourceInputs or {};
          sourceInputNames = builtins.attrNames sourceInputs;
          hasMatchingSourceInput =
            builtins.any
              (sourceName: ((builtins.getAttr sourceName sourceInputs).traceId or null) == entry.traceId)
              sourceInputNames;
          isConstructionSourceMap =
            (entry.source or null) == null
            && (entry.evidenceBoundary or null) == \"construction-only\"
            && (entry.maxRuntimeTargets or null) == 0
            && sourceInputNames != [ ]
            && builtins.all
              (sourceName:
                let childTrace = (builtins.getAttr sourceName sourceInputs).traceId or null;
                in childTrace != null && smsTracePrefix childTrace == sdsTrace)
              sourceInputNames;
        in
          entry ? rowDirectories
          && entry.rowDirectories ? SDS
          && entry.rowDirectories ? SMS
          && entrySmsTrace != null
          && sdsTrace != null
          && sdsDir == \"${repo_root}/GAMP/SDS/\" + sdsTrace
          && smsDir == \"${repo_root}/GAMP/SMS/\" + entrySmsTrace
          && (hasMatchingSourceInput || isConstructionSourceMap);
    intentRowOk =
      name:
        let
          entry = builtins.getAttr name manifest.tests;
          sitTrace = smsTracePrefix entry.traceId;
          smtDir = toString entry.rowDirectories.SMT;
          sitDir = toString entry.rowDirectories.SIT;
        in
          rowOk name
          && entry.rowDirectories ? SMT
          && entry.rowDirectories ? SIT
          && smtDir == \"${repo_root}/GAMP/SMT/\" + entry.traceId
          && sitTrace != null
          && sitDir == \"${repo_root}/GAMP/SIT/\" + sitTrace
          && toString entry.source.intent == smtDir + \"/intent.nix\";
  in
    require (intentRows != [ ]) \"manifest must have at least one intent-source row\"
    && require (builtins.all rowOk names) \"all mini SMT inputs must map to SDS and SMS template dirs or a construction-only child source map\"
    && require (builtins.all intentRowOk intentRows) \"intent-source rows must use SMT SMS dirs and SIT SDS dirs\"
" >/dev/null || fail "mini SMT manifest row-directory contract failed"

echo "PASS gamp-row-directory-layout"
