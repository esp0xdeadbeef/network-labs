#!/usr/bin/env bash
# GAMP-SCOPE: SMT/SIT row-local source stub coverage; not HAT/SAT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
manifest_file="${repo_root}/GAMP/SMT/mini-smt/tests.nix"

fail() {
  echo "FAIL gamp-row-source-stubs: $*" >&2
  exit 1
}

mapfile -t rows < <(find "${repo_root}/GAMP/SMT" -mindepth 1 -maxdepth 1 -type d -name 'FS-*-HDS-*-SDS-*-SMS-*' -printf '%f\n' | sort)
((${#rows[@]} > 0)) || fail "no SMT SMS row directories found"

mapfile -t non_intent_manifest_rows < <(
  nix eval --impure --raw --expr \
    "let
       manifest = import ${manifest_file};
       names = builtins.attrNames manifest.tests;
       nonIntent = builtins.filter (name: ((builtins.getAttr name manifest.tests).source.kind or \"\") != \"intent-source\") names;
     in
       builtins.concatStringsSep \"\n\" nonIntent"
)

is_non_intent_manifest_row() {
  local trace_id="$1"
  local known
  for known in "${non_intent_manifest_rows[@]}"; do
    [[ "${known}" == "${trace_id}" ]] && return 0
  done
  return 1
}

for trace_id in "${rows[@]}"; do
  row_dir="${repo_root}/GAMP/SMT/${trace_id}"
  if is_non_intent_manifest_row "${trace_id}"; then
    [[ -f "${row_dir}/default.nix" ]] || fail "${trace_id} missing default.nix"
    continue
  fi
  for name in intent.nix inventory-nixos.nix inventory-clab.nix inventory-test-clients.nix; do
    [[ -f "${row_dir}/${name}" ]] || fail "${trace_id} missing ${name}"
  done
done

REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  names =
    builtins.filter
      (name: builtins.match "FS-[0-9][0-9][0-9]-HDS-[0-9][0-9][0-9]-SDS-[0-9][0-9][0-9]-SMS-[0-9][0-9][0-9]" name != null)
      (builtins.attrNames (builtins.readDir (repoRoot + "/GAMP/SMT")));
  require = cond: msg: if cond then true else throw msg;
  manifest = import (repoRoot + "/GAMP/SMT/mini-smt/tests.nix");
  manifestNames = builtins.attrNames manifest.tests;
  nonIntentManifestRows =
    builtins.filter
      (name: ((builtins.getAttr name manifest.tests).source.kind or "") != "intent-source")
      manifestNames;
  checkRow = traceId:
    if builtins.elem traceId nonIntentManifestRows then
      true
    else
      let
        base = repoRoot + "/GAMP/SMT/" + traceId;
        intent = import (base + "/intent.nix");
        nixos = import (base + "/inventory-nixos.nix");
        clab = import (base + "/inventory-clab.nix");
        testClients = import (base + "/inventory-test-clients.nix");
      in
        require (builtins.isAttrs intent)
          (traceId + ": intent.nix must import to an attrset")
        && require (!(intent ? meta) || intent.meta.traceId == traceId)
          (traceId + ": intent.nix meta.traceId must match when present")
        && require (nixos ? meta && nixos.meta.traceId == traceId && nixos.meta.renderer == "nixos")
          (traceId + ": inventory-nixos.nix must expose matching nixos metadata")
        && require (clab ? meta && clab.meta.traceId == traceId && clab.meta.renderer == "clab")
          (traceId + ": inventory-clab.nix must expose matching clab metadata")
        && require (
          testClients == { }
          || (testClients ? meta && testClients.meta.traceId == traceId && testClients.meta.renderer == "test-clients")
        )
          (traceId + ": inventory-test-clients.nix must be an empty attrset or expose matching test-clients metadata");
in
  builtins.all checkRow names
' >/dev/null || fail "row-local source stubs are not importable"

echo "PASS gamp-row-source-stubs"
