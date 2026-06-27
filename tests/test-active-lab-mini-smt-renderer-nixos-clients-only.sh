#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
nixos_clients_renderer_root="${NETWORK_RENDERER_NIXOS_CLIENTS_ROOT:-/home/deadbeef/github/network-renderer-access-endpoint-nixos}"

REPO_ROOT="${repo_root}" \
NIXOS_CLIENTS_RENDERER_ROOT="${nixos_clients_renderer_root}" \
nix eval --impure --expr '
let
  repoRoot = builtins.getEnv "REPO_ROOT";
  rendererRoot = builtins.getEnv "NIXOS_CLIENTS_RENDERER_ROOT";
  system = builtins.currentSystem;
  poc = import (repoRoot + "/GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/layer-entry-poc");
  renderer = builtins.getFlake ("path:" + rendererRoot);
  input = import poc.meta.rendererTargets."nixos-clients".fixture;
  module =
    renderer.libBySystem.${system}.renderer.hostModule {
      hostName = "s-router-test-clients";
      labSource = "active-lab";
      cpm = input.controlPlane;
      controlPlane = input.controlPlane;
      rendererInventory = input.rendererInventory;
      siteName = "site-a";
    };
  result = module { config = {}; };
  containers = result.containers or {};
  names = builtins.attrNames containers;
  require = cond: msg: if cond then true else throw msg;
  client = containers.poc-client;
in
  require (poc.boundaryInputs."renderer-input".entryBoundary == "renderer-input") "renderer mini SMT must start at renderer-input boundary"
  && require (poc.meta.rendererTargets."nixos-clients".rendererRepo == "network-renderer-access-endpoint-nixos") "wrong nixos-clients renderer repo"
  && require (names == [ "poc-client" ]) "nixos-clients renderer should materialize exactly poc-client"
  && require (client.hostBridge == "client") "poc-client hostBridge should be client"
  && require (client.autoStart == true) "poc-client should be autostarted"
' >/dev/null

echo "PASS active-lab mini SMT nixos-clients renderer-only POC"
