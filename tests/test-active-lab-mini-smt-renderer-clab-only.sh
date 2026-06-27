#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
clab_renderer_root="${NETWORK_RENDERER_CLAB_ROOT:-/home/deadbeef/github/network-renderer-containerlab-linux-backend}"
tmpdir="$(mktemp -d)"
trap 'rm -rf "${tmpdir}"' EXIT

REPO_ROOT="${repo_root}" nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  poc = import (repoRoot + "/GAMP/SMT/layer-entry-poc");
  require = cond: msg: if cond then true else throw msg;
in
  require (poc.boundaryInputs."renderer-input".entryBoundary == "renderer-input") "renderer mini SMT must start at renderer-input boundary"
  && require (poc.meta.rendererTargets.clab.rendererRepo == "network-renderer-containerlab-linux-backend") "wrong clab renderer repo"
' >/dev/null

nix eval --impure --json --expr \
  "import ${repo_root}/GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/renderer-input/minimal-clab-cpm.nix" \
  >"${tmpdir}/cpm.json"

nix run --no-warn-dirty --no-write-lock-file --extra-experimental-features 'nix-command flakes' \
  "path:${clab_renderer_root}#generate-clab-config" -- \
  "${tmpdir}/cpm.json" \
  "${tmpdir}/fabric.clab.yml" \
  "${tmpdir}/bridges.nix" >/dev/null

grep -Fq "acme-lab-edge-a:" "${tmpdir}/fabric.clab.yml"
grep -Fq "acme-lab-edge-b:" "${tmpdir}/fabric.clab.yml"
grep -Fq "clab.link.bridge: br-layer-entry" "${tmpdir}/fabric.clab.yml"
grep -Fq "br-layer-entry" "${tmpdir}/bridges.nix"

echo "PASS active-lab mini SMT clab renderer-only POC"
