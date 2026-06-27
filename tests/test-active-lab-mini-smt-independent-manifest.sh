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
      (name: manifest.tests.${name}.rendererTarget != null)
      names;
  expectedRendererNames = [
    "renderer-clab"
    "renderer-nebula"
    "renderer-nixos"
    "renderer-nixos-clients"
    "renderer-nixos-p2p"
    "renderer-wireguard"
  ];
  allIndependent =
    builtins.all
      (name: manifest.tests.${name}.independent == true && manifest.tests.${name}.aggregateOnly == false)
      names;
  allHaveSource =
    builtins.all
      (name: manifest.tests.${name} ? source && manifest.tests.${name}.source ? kind)
      names;
  allSmall =
    builtins.all
      (name: manifest.tests.${name}.maxRuntimeTargets <= 2)
      names;
  allSingleRelationIntentSources =
    builtins.all
      (name:
        let entry = manifest.tests.${name};
        in
          if entry.source.kind == "intent-source" then
            builtins.length (entry.source.expectedRelationIds or [ ]) == 1
          else
            true)
      names;
  noHatSatEvidence =
    builtins.all
      (name:
        let levels = manifest.tests.${name}.evidenceLevels or [ ];
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
        let entry = manifest.tests.${name};
        in
          entry ? rowDirectories
          && entry.rowDirectories ? SMT
          && entry.rowDirectories ? SIT
          && builtins.match ".*/GAMP/SMT/FS-[0-9][0-9][0-9]-HDS-[0-9][0-9][0-9]-SDS-[0-9][0-9][0-9]-SMS-[0-9][0-9][0-9]" (toString entry.rowDirectories.SMT) != null
          && builtins.match ".*/GAMP/SIT/FS-[0-9][0-9][0-9]-HDS-[0-9][0-9][0-9]-SDS-[0-9][0-9][0-9]" (toString entry.rowDirectories.SIT) != null)
      names;
  allSourcesAreMini =
    builtins.all
      (name: sourcePathIsMini manifest.tests.${name}.source)
      names;
in
  require (names != []) "mini SMT manifest is empty"
  && require allIndependent "every mini SMT must be independently runnable and not aggregate-only"
  && require allHaveSource "every mini SMT must declare an explicit source"
  && require allSmall "every mini SMT must stay capped at two runtime targets"
  && require allSingleRelationIntentSources "intent-source mini SMTs must bind exactly one relation id"
  && require allSourcesAreMini "mini SMT sources must come from row-local GAMP/SMT/FS-* dirs"
  && require allRowsHaveLayerDirs "mini SMTs must declare SMT SMS-level and SIT SDS-level row directories"
  && require noHatSatEvidence "mini SMT manifest must not claim HAT/SAT evidence levels"
  && require (rendererNames == expectedRendererNames) "renderer mini SMT coverage must be clab, nebula, nixos, nixos-p2p, nixos-clients, and wireguard"
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
  if ! diff -u <(printf '%s\n' "${manifest_ids}") <(printf '%s\n' "${doc_ids}") >/dev/null; then
    echo "FAIL: ${doc_path#${repo_root}/} mini-SMT inventory differs from GAMP/SMT/mini-smt/tests.nix" >&2
    diff -u <(printf '%s\n' "${manifest_ids}") <(printf '%s\n' "${doc_ids}") >&2 || true
    exit 1
  fi
done

echo "PASS active-lab mini SMT manifest is independently runnable"
