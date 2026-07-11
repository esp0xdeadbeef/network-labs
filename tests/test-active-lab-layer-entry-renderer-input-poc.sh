#!/usr/bin/env bash
# GAMP-ID: FS-166-HDS-010-SDS-010-SMS-900
# GAMP-SCOPE: active-lab renderer-entry POC; not HAT/SAT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
nixos_renderer_root="${NETWORK_RENDERER_NIXOS_ROOT:-${repo_root}/../network-renderer-nixos}"
access_endpoint_renderer_root="${NETWORK_RENDERER_NIXOS_CLIENTS_ROOT:-${NETWORK_RENDERER_ACCESS_ENDPOINT_NIXOS_ROOT:-${repo_root}/../network-renderer-access-endpoint-nixos}}"
clab_renderer_root="${NETWORK_RENDERER_CLAB_ROOT:-${repo_root}/../network-renderer-containerlab-linux-backend}"
wireguard_renderer_root="${NETWORK_RENDERER_WIREGUARD_ROOT:-${repo_root}/../network-renderer-wireguard}"
nebula_renderer_root="${NETWORK_RENDERER_NEBULA_ROOT:-${repo_root}/../network-renderer-nebula}"
compiler_root="${NETWORK_COMPILER_ROOT:-${repo_root}/../network-compiler}"
nfm_root="${NETWORK_FORWARDING_MODEL_ROOT:-${repo_root}/../network-forwarding-model}"
cpm_root="${NETWORK_CONTROL_PLANE_MODEL_ROOT:-${repo_root}/../network-control-plane-model}"
poc_file="${repo_root}/GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/layer-entry-poc/default.nix"

fail() {
  echo "FAIL active-lab-layer-entry-renderer-input-poc: $*" >&2
  exit 1
}

[[ -d "${nixos_renderer_root}" ]] || fail "missing network-renderer-nixos repo at ${nixos_renderer_root}"
[[ -d "${access_endpoint_renderer_root}" ]] || fail "missing network-renderer-access-endpoint-nixos repo at ${access_endpoint_renderer_root}"
[[ -d "${clab_renderer_root}" ]] || fail "missing network-renderer-containerlab-linux-backend repo at ${clab_renderer_root}"
[[ -d "${wireguard_renderer_root}" ]] || fail "missing network-renderer-wireguard repo at ${wireguard_renderer_root}"
[[ -d "${nebula_renderer_root}" ]] || fail "missing network-renderer-nebula repo at ${nebula_renderer_root}"
[[ -d "${compiler_root}" ]] || fail "missing network-compiler repo at ${compiler_root}"
[[ -d "${nfm_root}" ]] || fail "missing network-forwarding-model repo at ${nfm_root}"
[[ -d "${cpm_root}" ]] || fail "missing network-control-plane-model repo at ${cpm_root}"
[[ -f "${poc_file}" ]] || fail "missing ${poc_file}"

result_json="$(mktemp)"
eval_stderr="$(mktemp)"
clab_dir="$(mktemp -d)"
trap 'rm -f "${result_json}" "${eval_stderr}"; rm -rf "${clab_dir}"' EXIT

if ! env \
  REPO_ROOT="${repo_root}" \
  NIXOS_RENDERER_ROOT="${nixos_renderer_root}" \
  ACCESS_ENDPOINT_RENDERER_ROOT="${access_endpoint_renderer_root}" \
  WIREGUARD_RENDERER_ROOT="${wireguard_renderer_root}" \
  NEBULA_RENDERER_ROOT="${nebula_renderer_root}" \
  COMPILER_ROOT="${compiler_root}" \
  NFM_ROOT="${nfm_root}" \
  CPM_ROOT="${cpm_root}" \
  nix eval \
    --extra-experimental-features 'nix-command flakes' \
    --impure --json --expr '
      let
        repoRoot = builtins.getEnv "REPO_ROOT";
        nixosRendererRoot = builtins.getEnv "NIXOS_RENDERER_ROOT";
        accessEndpointRendererRoot = builtins.getEnv "ACCESS_ENDPOINT_RENDERER_ROOT";
        wireguardRendererRoot = builtins.getEnv "WIREGUARD_RENDERER_ROOT";
        nebulaRendererRoot = builtins.getEnv "NEBULA_RENDERER_ROOT";
        compilerRoot = builtins.getEnv "COMPILER_ROOT";
        nfmRoot = builtins.getEnv "NFM_ROOT";
        cpmRoot = builtins.getEnv "CPM_ROOT";
        poc = import (repoRoot + "/GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/layer-entry-poc");
        cpm = import poc.meta.rendererTargets.nixos.fixture;
        nixosRenderer = builtins.getFlake ("path:" + nixosRendererRoot);
        accessEndpointRenderer = builtins.getFlake ("path:" + accessEndpointRendererRoot);
        wireguardRenderer = builtins.getFlake ("path:" + wireguardRendererRoot);
        nebulaRenderer = builtins.getFlake ("path:" + nebulaRendererRoot);
        compiler = builtins.getFlake ("path:" + compilerRoot);
        nfm = builtins.getFlake ("path:" + nfmRoot);
        cpmRepo = builtins.getFlake ("path:" + cpmRoot);
        lib = nixosRenderer.inputs.nixpkgs.lib;
        system = builtins.currentSystem;

        host = nixosRenderer.libBySystem.${system}.renderer.buildHostFromControlPlane {
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
        compilerSkipped = compiler.libBySystem.${system}.layerEntryEnvelope {
          entryBoundary = "forwarding-model-input";
          input = import poc.boundaryInputs."forwarding-model-input".suppliedArtifact.fixture;
        };
        nfmSkipped = nfm.libBySystem.${system}.layerEntryEnvelope {
          entryBoundary = "control-plane-input";
          input = import poc.boundaryInputs."control-plane-input".suppliedArtifact.fixture;
        };
        cpmSkipped = cpmRepo.libBySystem.${system}.layerEntryEnvelope {
          entryBoundary = "renderer-input";
          input = cpm;
        };
        warningCodes = payload: map (warning: warning.code) payload.warnings;
        wireguardContract = import poc.meta.rendererTargets.wireguard.fixture;
        wireguardResult =
          wireguardRenderer.libBySystem.${system}.renderer.buildWireGuardProviderRenderResult wireguardContract;
        nebulaCpm = import poc.meta.rendererTargets.nebula.fixture;
        nebulaPlan = nebulaRenderer.libBySystem.${system}.renderer.buildNebulaPlan {
          controlPlane = nebulaCpm;
        };
        accessEndpointInput = import poc.meta.rendererTargets."nixos-clients".fixture;
        accessEndpointModule =
          accessEndpointRenderer.libBySystem.${system}.renderer.hostModule {
            hostName = "s-router-test-clients";
            labSource = "active-lab";
            cpm = accessEndpointInput.controlPlane;
            controlPlane = accessEndpointInput.controlPlane;
            rendererInventory = accessEndpointInput.rendererInventory;
            siteName = "site-a";
          };
        accessEndpointResult = accessEndpointModule { config = {}; };
        accessEndpointContainers = accessEndpointResult.containers or { };

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
          skip_decision_names_are_declared =
            builtins.attrNames poc.skipDecisions == [
              "skip-network-compiler"
              "skip-network-compiler-and-nfm"
              "skip-network-compiler-nfm-and-cpm"
            ];
          compiler_skip_warning_comes_from_compiler_contract =
            compilerSkipped.repo == "network-compiler"
            && compilerSkipped.repoSkipped
            && compilerSkipped.inputTreatment == "pass-through"
            && compilerSkipped.normalizedTo == "nix-attrset"
            && builtins.elem "WARN_LAYER_ENTRY_SKIPS_NETWORK_COMPILER" (warningCodes compilerSkipped)
            && compilerSkipped.input == compilerSkipped.output;
          nfm_skip_warning_comes_from_nfm_contract =
            nfmSkipped.repo == "network-forwarding-model"
            && nfmSkipped.repoSkipped
            && warningCodes nfmSkipped == [ "WARN_LAYER_ENTRY_SKIPS_NFM" ]
            && nfmSkipped.input == nfmSkipped.output;
          cpm_skip_warning_comes_from_cpm_contract =
            cpmSkipped.repo == "network-control-plane-model"
            && cpmSkipped.repoSkipped
            && warningCodes cpmSkipped == [ "WARN_LAYER_ENTRY_SKIPS_CPM" ]
            && cpmSkipped.input == cpmSkipped.output;
          cpm_input_is_supplied_by_network_labs = cpm ? control_plane_model;
          renderer_materializes_container = containerNames == [ "poc-router" ];
          nixos_container_autostart_shape = (containers.poc-router.autoStart or false) == true;
          nixos_container_config_evaluates = evaluated.config.system.build ? toplevel;
          renderer_targets_are_declared =
            builtins.attrNames poc.meta.rendererTargets == [
              "clab"
              "nebula"
              "nixos"
              "nixos-clients"
              "wireguard"
            ];
          nixos_clients_renderer_materializes_endpoint_container =
            builtins.attrNames accessEndpointContainers == [ "poc-client" ]
            && accessEndpointContainers.poc-client.hostBridge == "client"
            && (accessEndpointContainers.poc-client.autoStart or false) == true;
          wireguard_renderer_materializes_provider_result =
            wireguardResult.targetRenderer == "wireguard-provider"
            && wireguardResult.rendererClass == "provider"
            && wireguardResult.artifacts.nixosModules ? providerRuntime
            && wireguardResult.diagnostics == [ ];
          nebula_renderer_materializes_runtime_plan =
            builtins.attrNames nebulaPlan.overlays == [ "acme::lab::nebula-layer-entry" ]
            && builtins.attrNames nebulaPlan.nodes == [ "lab-client-nebula" "lab-lighthouse" ]
            && nebulaPlan.nodes.lab-client-nebula.relay.relays == [ "100.96.90.1" ]
            && nebulaPlan.nodes.lab-client-nebula.unsafeRoutes == [ ];
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

if [[ "$(nix run --no-write-lock-file --extra-experimental-features 'nix-command flakes' "path:${nixos_renderer_root}#jq" -- -r '.ok' "${result_json}")" != "true" ]]; then
  nix run --no-write-lock-file --extra-experimental-features 'nix-command flakes' "path:${nixos_renderer_root}#jq" -- -S '.checks' "${result_json}" >&2
  fail "renderer-entry POC checks failed"
fi

# CLAB renderer invocation removed per FS-985-HDS-010-SDS-010-SMS-020 (repo-local test boundary).
# CLAB rendering validation belongs in network-renderer-containerlab-linux-backend/tests/.

echo "PASS active-lab layer-entry renderer-input POC (data validation only, CLAB invocation removed per SMS-020)"
