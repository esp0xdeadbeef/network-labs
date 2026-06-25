#!/usr/bin/env bash
# GAMP-ID: FS-166-HDS-010-SDS-010-SMS-900
# GAMP-SCOPE: active-lab layer-entry POC source contract; not HAT/SAT evidence
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
poc_file="${repo_root}/active-lab/layer-entry-poc/default.nix"

fail() {
  echo "FAIL active-lab-layer-entry-poc-boundary-inputs: $*" >&2
  exit 1
}

[[ -f "${poc_file}" ]] || fail "missing ${poc_file}"

nix eval --impure --expr "
  let
    poc = import ${poc_file};
    require = cond: msg: if cond then true else throw msg;
    has = builtins.hasAttr;
    boundaries = poc.boundaryInputs;
    boundaryNames = builtins.attrNames boundaries;
    rendererTargets = poc.meta.rendererTargets;
    rendererTargetNames = builtins.attrNames rendererTargets;
    expectedBoundaries = [
      \"intent-source\"
      \"compiler-output\"
      \"forwarding-model-input\"
      \"control-plane-input\"
      \"renderer-input\"
    ];
    expectedRendererTargets = [
      \"clab\"
      \"nebula\"
      \"nixos\"
      \"nixos-clients\"
      \"wireguard\"
    ];
    skippedForBoundary = {
      intent-source = [ ];
      compiler-output = [ \"intent-source\" ];
      forwarding-model-input = [ \"intent-source\" \"network-compiler\" ];
      control-plane-input = [ \"intent-source\" \"network-compiler\" \"network-forwarding-model\" ];
      renderer-input = [ \"intent-source\" \"network-compiler\" \"network-forwarding-model\" \"network-control-plane-model\" ];
    };
    fixtureFor = boundary:
      let artifact = boundaries.\${boundary}.suppliedArtifact;
      in artifact.fixture or artifact.intent or null;
    validateBoundary = boundary:
      let scenario = boundaries.\${boundary};
      in
        require (scenario.entryBoundary == boundary)
          \"\${boundary} must name its own entryBoundary\"
        && require (scenario.skippedUpstreamLayers == skippedForBoundary.\${boundary})
          \"\${boundary} has wrong skippedUpstreamLayers\"
        && require (scenario.downstreamPath != [ ])
          \"\${boundary} must declare downstreamPath\"
        && require (has \"suppliedArtifact\" scenario)
          \"\${boundary} must declare suppliedArtifact\"
        && require (fixtureFor boundary != null)
          \"\${boundary} must point at a fixture or intent source\";
    compilerFixture = import boundaries.\"compiler-output\".suppliedArtifact.fixture;
    forwardingFixture = import boundaries.\"forwarding-model-input\".suppliedArtifact.fixture;
    cpmInputFixture = import boundaries.\"control-plane-input\".suppliedArtifact.fixture;
    skipCompiler = poc.skipDecisions.\"skip-network-compiler\";
    skipCompilerNfm = poc.skipDecisions.\"skip-network-compiler-and-nfm\";
    skipCompilerNfmCpm = poc.skipDecisions.\"skip-network-compiler-nfm-and-cpm\";
    rendererTargetValid = name:
      let target = rendererTargets.\${name};
      in
        require (target ? rendererRepo)
          \"renderer target \${name} must declare rendererRepo\"
        && require (target ? fixture)
          \"renderer target \${name} must declare network-labs-owned input fixture\"
        && require (target ? materializer)
          \"renderer target \${name} must declare materializer\"
        && require (import target.fixture != null)
          \"renderer target \${name} fixture must import\";
  in
    require (poc.meta.contract == \"active-lab layer-entry runtime POC\")
      \"POC contract name changed\"
    && require (poc.meta.scope == \"SMT/SIT construction helper only; not HAT/SAT approval\")
      \"POC must not claim HAT/SAT approval\"
    && require (poc.meta.traceId == \"FS-166-HDS-010-SDS-010-SMS-900__allow-client-to-testnet-host-isp\")
      \"POC must carry the active-lab emulated SMS trace\"
    && require (
      builtins.all (boundary: builtins.elem boundary boundaryNames) expectedBoundaries
      && builtins.all (boundary: builtins.elem boundary expectedBoundaries) boundaryNames
    )
      \"POC must expose exactly the expected layer-entry boundaries\"
    && require (builtins.all validateBoundary expectedBoundaries)
      \"all POC boundaries must validate\"
    && require (
      builtins.all (name: builtins.elem name rendererTargetNames) expectedRendererTargets
      && builtins.all (name: builtins.elem name expectedRendererTargets) rendererTargetNames
    )
      \"POC must expose nixos, clab, wireguard, and nebula renderer targets\"
    && require (builtins.all rendererTargetValid expectedRendererTargets)
      \"all renderer target fixtures must validate\"
    && require (
      skipCompiler.entryBoundary == \"forwarding-model-input\"
      && skipCompiler.skippedRepos == [ \"network-compiler\" ]
      && skipCompiler.expectedRepoWarnings.\"network-compiler\" == \"WARN_LAYER_ENTRY_SKIPS_NETWORK_COMPILER\"
    )
      \"skip-network-compiler decision must be explicit\"
    && require (
      skipCompilerNfm.entryBoundary == \"control-plane-input\"
      && skipCompilerNfm.skippedRepos == [ \"network-compiler\" \"network-forwarding-model\" ]
      && skipCompilerNfm.expectedRepoWarnings.\"network-forwarding-model\" == \"WARN_LAYER_ENTRY_SKIPS_NFM\"
    )
      \"skip-network-compiler-and-nfm decision must be explicit\"
    && require (
      skipCompilerNfmCpm.entryBoundary == \"renderer-input\"
      && skipCompilerNfmCpm.skippedRepos == [
        \"network-compiler\"
        \"network-forwarding-model\"
        \"network-control-plane-model\"
      ]
      && skipCompilerNfmCpm.rendererTargets == expectedRendererTargets
      && skipCompilerNfmCpm.expectedRepoWarnings.\"network-control-plane-model\" == \"WARN_LAYER_ENTRY_SKIPS_CPM\"
    )
      \"skip-network-compiler-nfm-and-cpm decision must be explicit\"
    && require (compilerFixture.pocKind == \"synthetic-compiler-output\")
      \"compiler-output fixture must import\"
    && require (forwardingFixture.pocKind == \"synthetic-forwarding-model-input\")
      \"forwarding-model-input fixture must import\"
    && require (cpmInputFixture.pocKind == \"synthetic-control-plane-input\")
      \"control-plane-input fixture must import\"
    && require (boundaries.\"renderer-input\".suppliedArtifact.kind == \"network-labs-owned-cpm-input\")
      \"renderer-input must be a network-labs-owned CPM input\"
    && require ((import boundaries.\"renderer-input\".suppliedArtifact.fixture) ? control_plane_model)
      \"renderer-input fixture must be an importable CPM-shaped input\"
" >/dev/null || fail "boundary input contract failed"

echo "PASS active-lab-layer-entry-poc-boundary-inputs"
