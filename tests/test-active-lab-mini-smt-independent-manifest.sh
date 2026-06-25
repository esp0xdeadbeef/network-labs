#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
manifest_file="${repo_root}/active-lab/mini-smt/tests.nix"

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
        builtins.match ".*/active-lab/mini-smt/intents/[^/]+/intent[.]nix" (toString source.intent) != null
      else if source ? cpm then
        builtins.match ".*/active-lab/(mini-smt|layer-entry-poc/renderer-input)/.*[.]nix" (toString source.cpm) != null
      else
        false;
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
  && require allSourcesAreMini "mini SMT sources must come from active-lab/mini-smt or layer-entry renderer-input fixtures"
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

echo "PASS active-lab mini SMT manifest is independently runnable"
