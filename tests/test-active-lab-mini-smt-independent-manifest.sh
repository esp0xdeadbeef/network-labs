#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
manifest_file="${repo_root}/GAMP/SMT/mini-smt/tests.nix"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

nix eval --impure --expr '
let
  manifest = import '"${manifest_file}"';
  names = builtins.attrNames manifest.tests;
  require = cond: msg: if cond then true else throw msg;
  rendererNames =
    builtins.filter
      (name: (builtins.getAttr name manifest.tests).rendererTarget != null)
      names;
  expectedRendererNames = [
    "FS-166-HDS-010-SDS-010-SMS-901"
    "FS-166-HDS-010-SDS-010-SMS-902"
    "FS-166-HDS-010-SDS-010-SMS-903"
    "FS-166-HDS-010-SDS-010-SMS-904"
    "FS-166-HDS-010-SDS-010-SMS-905"
    "FS-166-HDS-010-SDS-010-SMS-906"
    "FS-470-HDS-010-SDS-010-SMS-010"
  ];
  allIndependent =
    builtins.all
      (name:
        let entry = builtins.getAttr name manifest.tests;
        in entry.independent == true && entry.aggregateOnly == false)
      names;
  allHaveSource =
    builtins.all
      (name:
        let entry = builtins.getAttr name manifest.tests;
            boundary = entry.evidenceBoundary or "runtime";
        in
          if boundary == "construction-only" || boundary == "source-stub-only" then
            entry ? source && entry.source == null
          else
            entry ? source && entry.source ? kind)
      names;
  allBoundedMiniRuntime =
    builtins.all
      (name:
        let max = (builtins.getAttr name manifest.tests).maxRuntimeTargets;
        in
          max >= 0
          && (
            max <= 5
            || (name == "FS-030-HDS-010-SDS-030-SMS-010" && max == 6)
            || (name == "FS-270-HDS-010-SDS-010-SMS-020" && max == 6)
            || (name == "FS-540-HDS-010-SDS-010-SMS-045" && max == 6)
            || (name == "FS-800-HDS-010-SDS-020-SMS-040" && max == 6)
          ))
      names;
  fiveTargetRowsAreExplicit =
    manifest.tests."FS-370-HDS-010-SDS-010-SMS-050".maxRuntimeTargets == 5
    && manifest.tests."FS-540-HDS-010-SDS-010-SMS-020".maxRuntimeTargets == 5;
  allIntentSourcesHaveRelations =
    builtins.all
      (name:
        let entry = builtins.getAttr name manifest.tests;
        in
          if entry.source != null && entry.source.kind == "intent-source" then
            builtins.length (entry.source.expectedRelationIds or [ ]) >= 1
          else
            true)
      names;
  noHatSatEvidence =
    builtins.all
      (name:
        let levels = (builtins.getAttr name manifest.tests).evidenceLevels or [ ];
        in !(builtins.elem "HAT" levels) && !(builtins.elem "SAT" levels))
      names;
  sourcePathIsMini =
    source:
      if source ? intent then
        builtins.match ".*/GAMP/SMT/FS-[0-9][0-9][0-9]-HDS-[0-9][0-9][0-9]-SDS-[0-9][0-9][0-9]-SMS-[0-9][0-9][0-9]/intent[.]nix" (toString source.intent) != null
      else if source ? cpm then
        builtins.match ".*/GAMP/SMT/FS-[0-9][0-9][0-9]-HDS-[0-9][0-9][0-9]-SDS-[0-9][0-9][0-9]-SMS-[0-9][0-9][0-9]/.*[.]nix" (toString source.cpm) != null
      else
        false;
  allRowsHaveLayerDirs =
    builtins.all
      (name:
        let entry = builtins.getAttr name manifest.tests;
        in
          entry ? rowDirectories
          && entry.rowDirectories ? SMT
          && entry.rowDirectories ? SIT
          && builtins.match ".*/GAMP/SMT/FS-[0-9][0-9][0-9]-HDS-[0-9][0-9][0-9]-SDS-[0-9][0-9][0-9]-SMS-[0-9][0-9][0-9]" (toString entry.rowDirectories.SMT) != null
          && builtins.match ".*/GAMP/SIT/FS-[0-9][0-9][0-9]-HDS-[0-9][0-9][0-9]-SDS-[0-9][0-9][0-9]" (toString entry.rowDirectories.SIT) != null)
      names;
  allSourcesAreMini =
    builtins.all
      (name:
        let entry = builtins.getAttr name manifest.tests;
            boundary = entry.evidenceBoundary or "runtime";
        in
          if entry.source == null then
            boundary == "construction-only" || boundary == "source-stub-only"
          else
            sourcePathIsMini entry.source)
      names;
in
  require (names != []) "mini SMT manifest is empty"
  && require allIndependent "every mini SMT must be independently runnable and not aggregate-only"
  && require allHaveSource "every runtime mini SMT must declare an explicit source and every construction-only mini SMT must declare source = null"
  && require allBoundedMiniRuntime "mini SMTs must stay capped at five runtime targets or fewer, except rows whose isolated contract needs a six-role spine"
  && require fiveTargetRowsAreExplicit "FS-370-HDS-010-SDS-010-SMS-050 and FS-540-HDS-010-SDS-010-SMS-020 must explicitly declare five-target mini paths"
  && require allIntentSourcesHaveRelations "intent-source mini SMTs must bind at least one relation id"
  && require allSourcesAreMini "mini SMT sources must come from row-local GAMP/SMT/FS-* dirs"
  && require allRowsHaveLayerDirs "mini SMTs must declare SMT SMS-level and SIT SDS-level row directories"
  && require noHatSatEvidence "mini SMT manifest must not claim HAT/SAT evidence levels"
  && require (rendererNames == expectedRendererNames) "renderer mini SMT coverage must include the FS-166 renderer rows and FS-470-HDS-010-SDS-010-SMS-010"
' >/dev/null

while IFS= read -r id || [[ -n "${id}" ]]; do
  script="$(nix eval --impure --raw --expr "let manifest = import ${manifest_file}; in manifest.tests.\"${id}\".script")"
  [[ -x "${repo_root}/${script}" ]] || fail "${id} script is missing or not executable: ${script}"

  case "${script}" in
    *layer-entry-construction-cycles*|*layer-entry-renderer-input-poc*)
      fail "${id} points at an aggregate script: ${script}"
      ;;
  esac
done < <(
  nix eval --impure --raw --expr \
    "let manifest = import ${manifest_file}; in builtins.concatStringsSep \"\n\" (builtins.attrNames manifest.tests)"
)

manifest_ids="$(
  nix eval --impure --raw --expr \
    "let manifest = import ${manifest_file}; in builtins.concatStringsSep \"\n\" (builtins.attrNames manifest.tests)" \
    | sort
)"

extract_mini_inventory_ids() {
  local doc="$1"
  local start="$2"
  local stop="$3"
  awk -v start="${start}" -v stop="${stop}" '
    $0 ~ start { in_table = 1; next }
    in_table && $0 ~ stop { in_table = 0 }
    in_table { print }
  ' "${doc}" \
    | sed -nE 's/^\| `([^`]+)` \|.*/\1/p' \
    | sort
}

for doc in \
  "${repo_root}/GAMP/SMT/README.md:## Current Mini-SMT Row Inventory:## Status" \
  "${repo_root}/GAMP/SMT/mini-smt/README.md:Current mini-labs::Worked row examples:"; do
  IFS=: read -r doc_path start_heading stop_heading <<<"${doc}"
  doc_ids="$(extract_mini_inventory_ids "${doc_path}" "${start_heading}" "${stop_heading}")"
  [[ -n "${doc_ids}" ]] || fail "${doc_path#${repo_root}/} mini-SMT inventory table is empty"
  missing_doc_ids="$(comm -23 <(printf '%s\n' "${doc_ids}") <(printf '%s\n' "${manifest_ids}"))"
  if [[ -n "${missing_doc_ids}" ]]; then
    echo "FAIL: ${doc_path#${repo_root}/} mini-SMT inventory contains rows missing from GAMP/SMT/mini-smt/tests.nix" >&2
    printf '%s\n' "${missing_doc_ids}" >&2
    exit 1
  fi
done

echo "PASS active-lab mini SMT manifest is independently runnable"
