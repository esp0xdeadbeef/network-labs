#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
wireguard_renderer_root="${NETWORK_RENDERER_WIREGUARD_ROOT:-/home/deadbeef/github/network-renderer-wireguard}"

REPO_ROOT="${repo_root}" \
WIREGUARD_RENDERER_ROOT="${wireguard_renderer_root}" \
nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  rendererRoot = builtins.getEnv "WIREGUARD_RENDERER_ROOT";
  system = builtins.currentSystem;
  poc = import (repoRoot + "/GAMP/SMT/layer-entry-poc");
  renderer = builtins.getFlake ("path:" + rendererRoot);
  contract = import poc.meta.rendererTargets.wireguard.fixture;
  result = renderer.libBySystem.${system}.renderer.buildWireGuardProviderRenderResult contract;
  require = cond: msg: if cond then true else throw msg;
in
  require (poc.boundaryInputs."renderer-input".entryBoundary == "renderer-input") "renderer mini SMT must start at renderer-input boundary"
  && require (poc.meta.rendererTargets.wireguard.rendererRepo == "network-renderer-wireguard") "wrong wireguard renderer repo"
  && require (result.targetRenderer == "wireguard-provider") "wireguard target renderer mismatch"
  && require (result.rendererClass == "provider") "wireguard renderer class mismatch"
  && require (result.artifacts.nixosModules ? providerRuntime) "wireguard provider runtime module missing"
  && require (result.diagnostics == []) "wireguard renderer diagnostics must be empty"
' >/dev/null

echo "PASS active-lab mini SMT wireguard renderer-only POC"
