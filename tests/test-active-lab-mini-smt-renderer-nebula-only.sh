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
  poc = import (repoRoot + "/GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/layer-entry-poc");
  renderer = builtins.getFlake ("path:" + rendererRoot);
  pkgs = import renderer.inputs.nixpkgs { inherit system; };
  lib = pkgs.lib;
  api = renderer.libBySystem.${system}.renderer;
  cpm = import poc.meta.rendererTargets.nebula.fixture;
  result = api.buildNebulaPlan {
    controlPlane = cpm;
  };
  hosted = api.selectHostedNebulaRuntimePlan {
    nebulaRuntimePlan = result;
    cpmData = cpm.control_plane_model.data;
    hostName = "s-router-nixos";
  };
  hostModule = api.hostModule {
    hostName = "s-router-nixos";
    controlPlane = cpm;
  };
  hostModuleOutput = hostModule { config = {}; inherit lib pkgs; };
  lighthouseRuntimeModule = api.buildNebulaRuntimeNixosModule {
    inherit pkgs;
    nodeName = "lab-lighthouse";
    runtimeNode = result.nodes.lab-lighthouse;
  };
  clientRuntimeModule = api.buildNebulaRuntimeNixosModule {
    inherit pkgs;
    nodeName = "lab-client-nebula";
    runtimeNode = result.nodes.lab-client-nebula;
  };
  clabHostModule = api.hostModule {
    hostName = "s-router-clab";
    controlPlane = cpm;
  };
  clabHostModuleOutput = clabHostModule { config = {}; inherit lib pkgs; };
  targets = builtins.attrNames cpm.control_plane_model.data.acme.lab.runtimeTargets;
  overlay = cpm.control_plane_model.data.acme.lab.overlays.nebula-layer-entry;
  require = cond: msg: if cond then true else throw msg;
in
  require (poc.boundaryInputs."renderer-input".entryBoundary == "renderer-input") "renderer mini SMT must start at renderer-input boundary"
  && require (poc.meta.rendererTargets.nebula.rendererRepo == "network-renderer-nebula") "wrong nebula renderer repo"
  && require (cpm.control_plane_model.meta.traceId == "FS-166-HDS-010-SDS-010-SMS-906") "nebula source trace mismatch"
  && require (builtins.attrNames cpm.deploymentHosts == [ "s-router-nixos" ]) "nebula row must expose only the Nebula-capable s-router-nixos host"
  && require (targets == [ "lab-client-nebula" "lab-lighthouse" ]) "nebula row must declare exactly the client and lighthouse runtime targets"
  && require (cpm.control_plane_model.data.acme.lab.runtimeTargets.lab-lighthouse.placement.host == "s-router-nixos") "nebula lighthouse must target s-router-nixos"
  && require (cpm.control_plane_model.data.acme.lab.runtimeTargets.lab-client-nebula.placement.host == "s-router-nixos") "nebula client must target s-router-nixos"
  && require (overlay.nebula.lighthouse.node == "lab-lighthouse") "nebula overlay lighthouse mismatch"
  && require (overlay.runtimeNodes.lab-lighthouse.service.interface == "nebula1") "nebula lighthouse interface mismatch"
  && require (overlay.runtimeNodes.lab-lighthouse.service.listenHost == "100.96.90.1") "nebula lighthouse listen host mismatch"
  && require (overlay.runtimeNodes.lab-lighthouse.service.port == 4242) "nebula lighthouse listen port mismatch"
  && require (overlay.runtimeNodes.lab-client-nebula.service.interface == "nebula1") "nebula client interface mismatch"
  && require (overlay.runtimeNodes.lab-client-nebula.service.listenHost == "100.96.90.2") "nebula client listen host mismatch"
  && require (overlay.runtimeNodes.lab-client-nebula.service.port == 4242) "nebula client listen port mismatch"
  && require (builtins.attrNames result.overlays == [ "acme::lab::nebula-layer-entry" ]) "nebula overlay mismatch"
  && require (builtins.attrNames result.nodes == [ "lab-client-nebula" "lab-lighthouse" ]) "nebula nodes mismatch"
  && require (result.nodes.lab-lighthouse.groups == [ "lighthouse" ]) "nebula lighthouse group mismatch"
  && require (result.nodes.lab-client-nebula.groups == [ "client" ]) "nebula client group mismatch"
  && require (lighthouseRuntimeModule.services.nebula.networks.runtime.listen.host == "100.96.90.1") "nebula lighthouse runtime module listen host mismatch"
  && require (lighthouseRuntimeModule.services.nebula.networks.runtime.listen.port == 4242) "nebula lighthouse runtime module listen port mismatch"
  && require (clientRuntimeModule.services.nebula.networks.runtime.listen.host == "100.96.90.2") "nebula client runtime module listen host mismatch"
  && require (clientRuntimeModule.services.nebula.networks.runtime.listen.port == 4242) "nebula client runtime module listen port mismatch"
  && require (builtins.attrNames hosted.nodes == [ "lab-client-nebula" "lab-lighthouse" ]) "nebula hosted plan must select the row runtime nodes on s-router-nixos"
  && require (api.runtimeContainerNameForHost { cpmData = cpm.control_plane_model.data; hostName = "s-router-nixos"; logicalName = "lab-lighthouse"; } == "lab-lighthouse") "nebula lighthouse container name mismatch"
  && require (api.runtimeContainerNameForHost { cpmData = cpm.control_plane_model.data; hostName = "s-router-nixos"; logicalName = "lab-client-nebula"; } == "lab-client-nebula") "nebula client container name mismatch"
  && require (builtins.attrNames hostModuleOutput.containers == [ "lab-client-nebula" "lab-lighthouse" ]) "nebula hostModule must materialize both row runtime containers"
  && require (hostModuleOutput.containers.lab-lighthouse.config._type == "merge") "nebula lighthouse container must carry a runtime module"
  && require (hostModuleOutput.containers.lab-client-nebula.config._type == "merge") "nebula client container must carry a runtime module"
  && require ((clabHostModuleOutput.containers or { }) == { }) "nebula hostModule must not materialize row runtime containers on s-router-clab"
' >/dev/null

echo "PASS active-lab mini SMT nebula renderer-only POC"
