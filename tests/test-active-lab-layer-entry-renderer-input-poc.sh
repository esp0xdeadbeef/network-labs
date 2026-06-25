#!/usr/bin/env bash
# GAMP-ID: FS-166-HDS-010-SDS-010-SMS-900
# GAMP-SCOPE: active-lab renderer-entry POC; not HAT/SAT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
renderer_root="${NETWORK_RENDERER_NIXOS_ROOT:-${repo_root}/../network-renderer-nixos}"
poc_file="${repo_root}/active-lab/layer-entry-poc/default.nix"

fail() {
  echo "FAIL active-lab-layer-entry-renderer-input-poc: $*" >&2
  exit 1
}

[[ -d "${renderer_root}" ]] || fail "missing network-renderer-nixos repo at ${renderer_root}"
[[ -f "${poc_file}" ]] || fail "missing ${poc_file}"

result_json="$(mktemp)"
eval_stderr="$(mktemp)"
trap 'rm -f "${result_json}" "${eval_stderr}"' EXIT

if ! env REPO_ROOT="${repo_root}" RENDERER_ROOT="${renderer_root}" \
  nix eval \
    --extra-experimental-features 'nix-command flakes' \
    --impure --json --expr '
      let
        repoRoot = builtins.getEnv "REPO_ROOT";
        rendererRoot = builtins.getEnv "RENDERER_ROOT";
        poc = import (repoRoot + "/active-lab/layer-entry-poc");
        cpm = import poc.boundaryInputs."renderer-input".suppliedArtifact.fixture;
        renderer = builtins.getFlake ("path:" + rendererRoot);
        lib = renderer.inputs.nixpkgs.lib;
        system = builtins.currentSystem;

        host = renderer.libBySystem.${system}.renderer.buildHostFromControlPlane {
          controlPlaneOut = cpm;
          selector = "lab-host";
          inherit system;
          containerDefaults = { autoStart = true; };
          disabled = { };
        };

        containers = host.renderedHost.containers or { };
        containerNames = builtins.attrNames containers;
        evaluated = lib.nixosSystem {
          inherit system;
          modules = [ containers.poc-router.config ];
        };

        checks = {
          renderer_input_boundary_declared =
            poc.boundaryInputs."renderer-input".entryBoundary == "renderer-input";
          compiler_nfm_cpm_are_declared_skipped =
            poc.boundaryInputs."renderer-input".skippedUpstreamLayers == [
              "intent-source"
              "network-compiler"
              "network-forwarding-model"
              "network-control-plane-model"
            ];
          cpm_input_is_supplied_by_network_labs = cpm ? control_plane_model;
          renderer_materializes_container = containerNames == [ "poc-router" ];
          nixos_container_autostart_shape = (containers.poc-router.autoStart or false) == true;
          nixos_container_config_evaluates = evaluated.config.system.build ? toplevel;
        };
      in
      {
        ok = builtins.all (name: checks.${name}) (builtins.attrNames checks);
        failed = builtins.filter (name: !(checks.${name})) (builtins.attrNames checks);
        inherit checks;
      }
    ' >"${result_json}" 2>"${eval_stderr}"; then
  cat "${eval_stderr}" >&2
  fail "nix eval crashed"
fi

if [[ "$(nix run --no-write-lock-file --extra-experimental-features 'nix-command flakes' "path:${renderer_root}#jq" -- -r '.ok' "${result_json}")" != "true" ]]; then
  nix run --no-write-lock-file --extra-experimental-features 'nix-command flakes' "path:${renderer_root}#jq" -- -S '.checks' "${result_json}" >&2
  fail "renderer-entry POC checks failed"
fi

echo "PASS active-lab-layer-entry-renderer-input-poc"
