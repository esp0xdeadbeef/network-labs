#!/usr/bin/env bash
set -euo pipefail

repo_root="${SMS_TEST_REPO_ROOT:-$(git -C "$(dirname "${BASH_SOURCE[0]}")" rev-parse --show-toplevel)}"
manifest_file="${repo_root}/GAMP/SMT/mini-smt/tests.nix"
runner="${repo_root}/tests/run-active-lab-mini-smt.sh"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

nix eval --impure --expr '
let
  manifest = import '"${manifest_file}"';
  names = builtins.attrNames manifest.tests;
  require = cond: msg: if cond then true else throw msg;
  allowedRendererTargets = [
    "access-endpoint-nixos"
    "clab"
    "nebula"
    "nixos"
    "openconfig"
    "wireguard"
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
  allBoundariesConsistent =
    builtins.all
      (name:
        let
          entry = builtins.getAttr name manifest.tests;
          boundary = entry.evidenceBoundary or "runtime";
          max = entry.maxRuntimeTargets;
        in
          if boundary == "construction-only" || boundary == "source-stub-only" || max == 0
          then max == 0
          else max > 0)
      names;
  rendererTargetsAreKnown =
    builtins.all
      (name:
        let target = (builtins.getAttr name manifest.tests).rendererTarget;
        in target == null || builtins.elem target allowedRendererTargets)
      names;
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
  && require allBoundariesConsistent "construction rows must declare zero runtime targets and runtime rows must declare a positive target count"
  && require rendererTargetsAreKnown "rendererTarget must name a supported renderer family"
  && require allIntentSourcesHaveRelations "intent-source mini SMTs must bind at least one relation id"
  && require allSourcesAreMini "mini SMT sources must come from row-local GAMP/SMT/FS-* dirs"
  && require allRowsHaveLayerDirs "mini SMTs must declare SMT SMS-level and SIT SDS-level row directories"
  && require noHatSatEvidence "mini SMT manifest must not claim HAT/SAT evidence levels"
' >/dev/null

while IFS=$'\t' read -r id script; do
  [[ -x "${script}" ]] || fail "${id} canonical entrypoint is missing or not executable: ${script}"
done < <("${runner}" --test-paths)

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
