#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
nebula_renderer_root="${NETWORK_RENDERER_NEBULA_ROOT:-/home/deadbeef/github/network-renderer-nebula}"

REPO_ROOT="${repo_root}" \
NEBULA_RENDERER_ROOT="${nebula_renderer_root}" \
nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  rendererRoot = builtins.getEnv "NEBULA_RENDERER_ROOT";
  system = builtins.currentSystem;
  poc = import (repoRoot + "/GAMP/SMT/layer-entry-poc");
  renderer = builtins.getFlake ("path:" + rendererRoot);
  cpm = import poc.meta.rendererTargets.nebula.fixture;
  result = renderer.libBySystem.${system}.renderer.buildNebulaPlan {
    controlPlane = cpm;
  };
  require = cond: msg: if cond then true else throw msg;
in
  require (poc.boundaryInputs."renderer-input".entryBoundary == "renderer-input") "renderer mini SMT must start at renderer-input boundary"
  && require (poc.meta.rendererTargets.nebula.rendererRepo == "network-renderer-nebula") "wrong nebula renderer repo"
  && require (builtins.attrNames result.overlays == [ "acme::lab::nebula-layer-entry" ]) "nebula overlay mismatch"
  && require (builtins.attrNames result.nodes == [ "lab-client-nebula" "lab-lighthouse" ]) "nebula nodes mismatch"
  && require (result.nodes.lab-lighthouse.groups == [ "lighthouse" ]) "nebula lighthouse group mismatch"
  && require (result.nodes.lab-client-nebula.groups == [ "client" ]) "nebula client group mismatch"
' >/dev/null

echo "PASS active-lab mini SMT nebula renderer-only POC"
