#!/usr/bin/env bash
# GAMP-ID: FS-166-HDS-010-SDS-010-SMS-900
# GAMP-SCOPE: active-lab mini runtime SMT; not HAT/SAT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cpm_root="${NETWORK_CONTROL_PLANE_MODEL_ROOT:-${repo_root}/../network-control-plane-model}"
nixos_renderer_root="${NETWORK_RENDERER_NIXOS_ROOT:-${repo_root}/../network-renderer-nixos}"

fail() {
  echo "FAIL active-lab-mini-smt-runtime-nixos-renderer-input: $*" >&2
  exit 1
}

[[ -d "${cpm_root}" ]] || fail "missing network-control-plane-model repo at ${cpm_root}"
[[ -d "${nixos_renderer_root}" ]] || fail "missing network-renderer-nixos repo at ${nixos_renderer_root}"

nix eval --extra-experimental-features 'nix-command flakes' --impure --expr "
  let
    repoRoot = \"${repo_root}\";
    cpmRepo = builtins.getFlake \"path:${cpm_root}\";
    nixosRenderer = builtins.getFlake \"path:${nixos_renderer_root}\";
    system = builtins.currentSystem;
    cpm = cpmRepo.libBySystem.\${system}.compileAndBuildFromPaths {
      inputPath = repoRoot + \"/active-lab/intent.nix\";
      inventoryPath = repoRoot + \"/active-lab/inventory-nixos.nix\";
    };
    host = nixosRenderer.libBySystem.\${system}.renderer.buildHostFromControlPlane {
      controlPlaneOut = cpm;
      selector = \"s-router-nixos\";
      inherit system;
    };
    mini = import (repoRoot + \"/active-lab/mini-smt/default.nix\");
    traceId = cpm.control_plane_model.meta.traceId;
    layerEntry = cpm.control_plane_model.meta.layerEntry;
    warningCodes = map (warning: warning.code) layerEntry.warnings;
    containerNames = builtins.attrNames (host.renderedHost.containers or { });
    require = cond: msg: if cond then true else throw msg;
  in
    require (traceId == \"FS-166-HDS-010-SDS-010-SMS-900__active-lab-mini-runtime\")
      \"active-lab runtime CPM must carry the mini runtime trace id\"
    && require (layerEntry.entryBoundary == \"renderer-input\")
      \"active-lab runtime CPM must be treated as renderer-input\"
    && require (warningCodes == [
      \"WARN_LAYER_ENTRY_SKIPS_NETWORK_LABS_INTENT_SOURCE\"
      \"WARN_LAYER_ENTRY_SKIPS_NETWORK_COMPILER\"
      \"WARN_LAYER_ENTRY_SKIPS_NFM\"
      \"WARN_LAYER_ENTRY_SKIPS_CPM\"
    ])
      \"active-lab runtime CPM must carry all skipped-stage warnings\"
    && require (containerNames == [ \"poc-router\" ])
      \"active-lab mini runtime must render exactly poc-router\"
    && require (mini.meta.defaultRule == \"A mini SMT may start only the runtime targets declared by that mini-lab.\")
      \"mini SMT default rule must stay explicit\"
" >/dev/null || fail "active-lab mini runtime renderer-input contract failed"

echo "PASS active-lab-mini-smt-runtime-nixos-renderer-input"
