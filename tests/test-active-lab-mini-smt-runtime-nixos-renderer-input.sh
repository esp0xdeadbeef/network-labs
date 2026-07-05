#!/usr/bin/env bash
# GAMP-ID: FS-166-HDS-010-SDS-010-SMS-901
# GAMP-SCOPE: active-lab mini runtime SMT; not HAT/SAT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
nixos_renderer_root="${NETWORK_RENDERER_NIXOS_ROOT:-${repo_root}/../network-renderer-nixos}"

fail() {
  echo "FAIL active-lab-mini-smt-runtime-nixos-renderer-input: $*" >&2
  exit 1
}

[[ -d "${nixos_renderer_root}" ]] || fail "missing network-renderer-nixos repo at ${nixos_renderer_root}"

nix eval --extra-experimental-features 'nix-command flakes' --impure --expr "
  let
    repoRoot = \"${repo_root}\";
    nixosRenderer = builtins.getFlake \"path:${nixos_renderer_root}\";
    system = builtins.currentSystem;
    sms = import (repoRoot + \"/GAMP/SMS/FS-166-HDS-010-SDS-010-SMS-900/default.nix\");
    row = sms.sourceInputs.\"FS-166-HDS-010-SDS-010-SMS-901\";
    sourcePath = repoRoot + \"/\" + row.sourcePath;
    cpm = import sourcePath;
    host = nixosRenderer.libBySystem.\${system}.renderer.buildHostFromControlPlane {
      controlPlaneOut = cpm;
      selector = \"s-router-nixos\";
      inherit system;
    };
    mini = import (repoRoot + \"/GAMP/SMT/mini-smt/default.nix\");
    traceId = cpm.control_plane_model.meta.traceId;
    managementUplink = cpm.deploymentHosts.s-router-nixos.uplinks.management or { };
    layerEntry = cpm.control_plane_model.meta.layerEntry;
    warningCodes = map (warning: warning.code) layerEntry.warnings;
    runtimeTarget = cpm.control_plane_model.data.acme.lab.runtimeTargets.poc-router;
    containerNames = builtins.attrNames (host.renderedHost.containers or { });
    require = cond: msg: if cond then true else throw msg;
  in
    require (row.kind == \"renderer-input\")
      \"renderer-nixos SMS source must be a renderer-input mini SMT\"
    && require (row.rendererTarget == \"nixos\")
      \"renderer-nixos SMS source must target the NixOS renderer\"
    && require (row.sourcePath == \"GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/runtime-nixos-cpm.nix\")
      \"renderer-nixos SMS source path mismatch\"
    && require (row.test == \"../network-codex-agent/scripts/smt-live-FS-166-HDS-010-SDS-010-SMS-901.sh\")
      \"renderer-nixos SMS source test mismatch\"
    && require (traceId == \"FS-166-HDS-010-SDS-010-SMS-901\")
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
    && require (runtimeTarget.routingMode == \"static\")
      \"active-lab mini runtime target must declare renderer routingMode\"
    && require (
      managementUplink.bridge == \"vlan2\"
      && managementUplink.mode == \"vlan\"
      && managementUplink.parent == \"eth0\"
      && managementUplink.vlan == 2
      && (managementUplink.ipv4.enable or false)
    )
      \"active-lab mini runtime must preserve the VLAN2 management uplink\"
    && require (mini.meta.defaultRule == \"A mini SMT may start only the runtime targets declared by that mini-lab.\")
      \"mini SMT default rule must stay explicit\"
" >/dev/null || fail "active-lab mini runtime renderer-input contract failed"

echo "PASS active-lab-mini-smt-runtime-nixos-renderer-input"
