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
  poc = import (repoRoot + "/GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/layer-entry-poc");
  renderer = builtins.getFlake ("path:" + rendererRoot);
  pkgs = import renderer.inputs.nixpkgs { inherit system; };
  lib = pkgs.lib;
  contract = import poc.meta.rendererTargets.wireguard.fixture;
  result = renderer.libBySystem.${system}.renderer.buildWireGuardProviderRenderResult contract;
  targets = builtins.attrNames contract.control_plane_model.data.acme.lab.runtimeTargets;
  overlay = contract.control_plane_model.data.acme.lab.overlays.wg-layer-entry;
  wgInventory = contract.control_plane_model.wgInventory.wg-layer-entry;
  hostModule = renderer.libBySystem.${system}.renderer.hostModule {
    hostName = "s-router-nixos";
    controlPlane = contract;
  };
  hostModuleOutput = (hostModule { config = {}; inherit lib pkgs; }).content;
  wgContainer = hostModuleOutput.containers.wireguard-egress;
  require = cond: msg: if cond then true else throw msg;
in
  require (poc.boundaryInputs."renderer-input".entryBoundary == "renderer-input") "renderer mini SMT must start at renderer-input boundary"
  && require (poc.meta.rendererTargets.wireguard.rendererRepo == "network-renderer-wireguard") "wrong wireguard renderer repo"
  && require (contract.control_plane_model.meta.traceId == "FS-166-HDS-010-SDS-010-SMS-905") "wireguard source trace mismatch"
  && require (targets == [ "wireguard-egress" ]) "wireguard row must declare exactly one runtime target"
  && require (contract.control_plane_model.data.acme.lab.runtimeTargets.wireguard-egress.placement.host == "s-router-nixos") "wireguard row must target s-router-nixos only"
  && require (overlay.terminateOn == [ "wireguard-egress" ]) "wireguard overlay must terminate on the row runtime target"
  && require (overlay.nodes.wireguard-egress.addr4 == "10.66.90.2/32") "wireguard overlay IPv4 address mismatch"
  && require (wgInventory.interface == "wg-layer-entry") "wireguard inventory interface mismatch"
  && require (wgInventory.privateKeyFile == "/run/secrets/wireguard-mini-provider-private-key") "wireguard inventory must use the row-local sops secret path"
  && require (result.targetRenderer == "wireguard-provider") "wireguard target renderer mismatch"
  && require (result.rendererClass == "provider") "wireguard renderer class mismatch"
  && require (result.artifacts.nixosModules ? providerRuntime) "wireguard provider runtime module missing"
  && require (result.diagnostics == []) "wireguard renderer diagnostics must be empty"
  && require (hostModuleOutput.containers ? wireguard-egress) "wireguard hostModule must materialize the row runtime container"
  && require (wgContainer.bindMounts."/run/secrets/wireguard-mini-provider-private-key".hostPath == "/run/secrets/wireguard-mini-provider-private-key")
    "wireguard hostModule must bind the row-local sops secret into the container"
' >/dev/null

echo "PASS active-lab mini SMT wireguard renderer-only POC"
