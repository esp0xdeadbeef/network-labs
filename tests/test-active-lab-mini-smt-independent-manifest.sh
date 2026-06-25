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
  noHatSatEvidence =
    builtins.all
      (name:
        let levels = manifest.tests.${name}.evidenceLevels or [ ];
        in !(builtins.elem "HAT" levels) && !(builtins.elem "SAT" levels))
      names;
in
  require (names != []) "mini SMT manifest is empty"
  && require allIndependent "every mini SMT must be independently runnable and not aggregate-only"
  && require allHaveSource "every mini SMT must declare an explicit source"
  && require noHatSatEvidence "mini SMT manifest must not claim HAT/SAT evidence levels"
  && require (rendererNames == expectedRendererNames) "renderer mini SMT coverage must be clab, nebula, nixos, nixos-clients, and wireguard"
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
