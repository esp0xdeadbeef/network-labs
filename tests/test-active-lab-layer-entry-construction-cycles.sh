#!/usr/bin/env bash
# GAMP-ID: FS-166-HDS-010-SDS-010-SMS-900
# GAMP-SCOPE: active-lab layer-entry construction cycles; not HAT/SAT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
nixos_renderer_root="${NETWORK_RENDERER_NIXOS_ROOT:-${repo_root}/../network-renderer-nixos}"
compiler_root="${NETWORK_COMPILER_ROOT:-${repo_root}/../network-compiler}"
nfm_root="${NETWORK_FORWARDING_MODEL_ROOT:-${repo_root}/../network-forwarding-model}"
cpm_root="${NETWORK_CONTROL_PLANE_MODEL_ROOT:-${repo_root}/../network-control-plane-model}"
poc_file="${repo_root}/active-lab/layer-entry-poc/default.nix"

fail() {
  echo "FAIL active-lab-layer-entry-construction-cycles: $*" >&2
  exit 1
}

[[ -d "${nixos_renderer_root}" ]] || fail "missing network-renderer-nixos repo at ${nixos_renderer_root}"
[[ -d "${compiler_root}" ]] || fail "missing network-compiler repo at ${compiler_root}"
[[ -d "${nfm_root}" ]] || fail "missing network-forwarding-model repo at ${nfm_root}"
[[ -d "${cpm_root}" ]] || fail "missing network-control-plane-model repo at ${cpm_root}"
[[ -f "${poc_file}" ]] || fail "missing ${poc_file}"

result_json="$(mktemp)"
eval_stderr="$(mktemp)"
trap 'rm -f "${result_json}" "${eval_stderr}"' EXIT

if ! env \
  REPO_ROOT="${repo_root}" \
  NIXOS_RENDERER_ROOT="${nixos_renderer_root}" \
  COMPILER_ROOT="${compiler_root}" \
  NFM_ROOT="${nfm_root}" \
  CPM_ROOT="${cpm_root}" \
  nix eval \
    --extra-experimental-features 'nix-command flakes' \
    --impure --json --expr '
      let
        repoRoot = builtins.getEnv "REPO_ROOT";
        nixosRendererRoot = builtins.getEnv "NIXOS_RENDERER_ROOT";
        compilerRoot = builtins.getEnv "COMPILER_ROOT";
        nfmRoot = builtins.getEnv "NFM_ROOT";
        cpmRoot = builtins.getEnv "CPM_ROOT";

        poc = import (repoRoot + "/active-lab/layer-entry-poc");
        forwardingInput = import poc.boundaryInputs."forwarding-model-input".suppliedArtifact.fixture;
        cpmInput = import poc.boundaryInputs."control-plane-input".suppliedArtifact.fixture;
        rendererCpm = import poc.meta.rendererTargets.nixos.fixture;

        compiler = builtins.getFlake ("path:" + compilerRoot);
        nfm = builtins.getFlake ("path:" + nfmRoot);
        cpmRepo = builtins.getFlake ("path:" + cpmRoot);
        nixosRenderer = builtins.getFlake ("path:" + nixosRendererRoot);
        system = builtins.currentSystem;
        traceId = poc.meta.traceId;

        warningCodes = payload: map (warning: warning.code) payload.warnings;
        hasWarning = code: payload: builtins.elem code (warningCodes payload);
        site = payload: payload.control_plane_model.data.esp0xdeadbeef."site-a";
        render = payload:
          nixosRenderer.libBySystem.${system}.renderer.buildHostFromControlPlane {
            controlPlaneOut = payload;
            selector = "lab-host";
            inherit system;
            containerDefaults = { autoStart = true; };
            disabled = { };
          };
        renderNames = payload: builtins.attrNames ((render payload).renderedHost.containers or { });

        compilerSkippedForNfm = compiler.libBySystem.${system}.layerEntryEnvelope {
          entryBoundary = "forwarding-model-input";
          input = forwardingInput;
        };
        nfmOutFromNfmEntry = nfm.libBySystem.${system}.build {
          input = compilerSkippedForNfm.output;
        };
        cpmOutFromNfmEntry = cpmRepo.libBySystem.${system}.build {
          input = nfmOutFromNfmEntry;
          inventory = cpmInput.inventory;
        };

        compilerSkippedForCpm = compiler.libBySystem.${system}.layerEntryEnvelope {
          entryBoundary = "control-plane-input";
          input = cpmInput;
        };
        nfmSkippedForCpm = nfm.libBySystem.${system}.layerEntryEnvelope {
          entryBoundary = "control-plane-input";
          input = compilerSkippedForCpm.output;
        };
        cpmConsumed = cpmRepo.libBySystem.${system}.layerEntryEnvelope {
          entryBoundary = "control-plane-input";
          input = nfmSkippedForCpm.output.forwardingModel;
        };
        cpmOutFromCpmEntry = cpmRepo.libBySystem.${system}.build {
          input = cpmConsumed.output;
          inventory = nfmSkippedForCpm.output.inventory;
        };

        compilerSkippedForRenderer = compiler.libBySystem.${system}.layerEntryEnvelope {
          entryBoundary = "renderer-input";
          input = rendererCpm;
        };
        nfmSkippedForRenderer = nfm.libBySystem.${system}.layerEntryEnvelope {
          entryBoundary = "renderer-input";
          input = compilerSkippedForRenderer.output;
        };
        cpmSkippedForRenderer = cpmRepo.libBySystem.${system}.layerEntryEnvelope {
          entryBoundary = "renderer-input";
          input = nfmSkippedForRenderer.output;
        };

        checks = {
          skip_compiler_declared_by_network_labs =
            poc.skipDecisions."skip-network-compiler".entryBoundary == "forwarding-model-input";
          skip_compiler_warning_from_compiler =
            compilerSkippedForNfm.repoSkipped
            && hasWarning "WARN_LAYER_ENTRY_SKIPS_NETWORK_COMPILER" compilerSkippedForNfm
            && compilerSkippedForNfm.input == compilerSkippedForNfm.output;
          nfm_entry_consumes_synthetic_input =
            nfmOutFromNfmEntry.enterprise.esp0xdeadbeef.site."site-a".siteName == "esp0xdeadbeef.site-a"
            && builtins.any
              (path: (path.relationId or null) == traceId)
              nfmOutFromNfmEntry.enterprise.esp0xdeadbeef.site."site-a".trafficPaths;
          nfm_entry_cpm_builds =
            (site cpmOutFromNfmEntry).relations != [ ]
            && builtins.length (builtins.attrNames (site cpmOutFromNfmEntry).runtimeTargets) == 5;
          nfm_entry_nixos_renderer_materializes =
            renderNames cpmOutFromNfmEntry == [
              "access-client"
              "core-wan"
              "downstream"
              "policy"
              "upstream"
            ];

          skip_compiler_nfm_declared_by_network_labs =
            poc.skipDecisions."skip-network-compiler-and-nfm".entryBoundary == "control-plane-input";
          cpm_entry_compiler_warning_from_compiler =
            compilerSkippedForCpm.repoSkipped
            && hasWarning "WARN_LAYER_ENTRY_SKIPS_NETWORK_COMPILER" compilerSkippedForCpm;
          cpm_entry_nfm_warning_from_nfm =
            nfmSkippedForCpm.repoSkipped
            && warningCodes nfmSkippedForCpm == [ "WARN_LAYER_ENTRY_SKIPS_NFM" ]
            && nfmSkippedForCpm.input == nfmSkippedForCpm.output;
          cpm_entry_cpm_consumes_without_skip_warning =
            cpmConsumed.repo == "network-control-plane-model"
            && cpmConsumed.repoSkipped == false
            && cpmConsumed.warnings == [ ];
          cpm_entry_cpm_builds =
            (site cpmOutFromCpmEntry).relations != [ ]
            && builtins.length (builtins.attrNames (site cpmOutFromCpmEntry).runtimeTargets) == 5;
          cpm_entry_nixos_renderer_materializes =
            renderNames cpmOutFromCpmEntry == [
              "access-client"
              "core-wan"
              "downstream"
              "policy"
              "upstream"
            ];

          skip_compiler_nfm_cpm_declared_by_network_labs =
            poc.skipDecisions."skip-network-compiler-nfm-and-cpm".entryBoundary == "renderer-input";
          renderer_entry_all_skip_warnings_are_issued_by_skipped_repos =
            hasWarning "WARN_LAYER_ENTRY_SKIPS_NETWORK_COMPILER" compilerSkippedForRenderer
            && warningCodes nfmSkippedForRenderer == [ "WARN_LAYER_ENTRY_SKIPS_NFM" ]
            && warningCodes cpmSkippedForRenderer == [ "WARN_LAYER_ENTRY_SKIPS_CPM" ];
          renderer_entry_nixos_renderer_materializes =
            renderNames cpmSkippedForRenderer.output == [ "poc-router" ];
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
  fail "construction cycle checks failed"
fi

echo "PASS active-lab-layer-entry-construction-cycles"
