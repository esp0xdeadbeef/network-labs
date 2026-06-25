#!/usr/bin/env bash
# GAMP-ID: FS-TEMPLATE-RENAME-TO-CORRECT-LAYER-ENTRY-SCENARIOS-SMS-000
# GAMP-SCOPE: software-module-test template guard
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
scenario_file="${repo_root}/GAMP/templates/layer-entry-scenarios/scenarios.nix"
readme="${repo_root}/GAMP/templates/layer-entry-scenarios/README.md"

fail() {
  echo "FAIL gamp-layer-entry-scenario-templates: $*" >&2
  exit 1
}

[[ -f "${scenario_file}" ]] || fail "missing ${scenario_file}"
[[ -f "${readme}" ]] || fail "missing ${readme}"

grep -Fq "FS-TEMPLATE-RENAME-TO-CORRECT-" "${readme}" \
  || fail "README must make the placeholder rename requirement visible"
grep -Fq "GAMP/templates/on-prem-vlan2-host-adapter/inventory.nix" "${readme}" \
  || fail "README must preserve the VLAN2 host-adapter requirement for on-prem scenarios"
grep -Fq "skippedUpstreamLayers" "${readme}" \
  || fail "README must document skipped upstream layers"
grep -Fq "expectedWarnings" "${readme}" \
  || fail "README must document skip warning expectations"
grep -Fq "HAT" "${readme}" \
  || fail "README must state the HAT/SAT full-approval boundary"

nix eval --impure --expr "
  let
    source = import ${scenario_file};
    require = cond: msg: if cond then true else throw msg;
    all = builtins.all;
    any = builtins.any;
    hasPrefix = prefix: value:
      builtins.substring 0 (builtins.stringLength prefix) value == prefix;
    hasValue = value: list: builtins.elem value list;
    names = builtins.attrNames source.scenarios;
    values = builtins.attrValues source.scenarios;
    allowedExpectedKinds = [
      \"positive-process\"
      \"positive-render\"
      \"negative-fail-closed\"
      \"runtime-guard\"
    ];
    skippedForBoundary = {
      intent-source = [ ];
      compiler-output = [ \"intent-source\" ];
      forwarding-model-input = [ \"intent-source\" \"network-compiler\" ];
      control-plane-input = [ \"intent-source\" \"network-compiler\" \"network-forwarding-model\" ];
      renderer-input = [ \"intent-source\" \"network-compiler\" \"network-forwarding-model\" \"network-control-plane-model\" ];
      runtime-artifact = [ \"intent-source\" \"network-compiler\" \"network-forwarding-model\" \"network-control-plane-model\" \"renderer\" ];
    };
    fullApprovalPath = [
      \"network-labs\"
      \"network-compiler\"
      \"network-forwarding-model\"
      \"network-control-plane-model\"
      \"network-renderer-nixos\"
      \"nixos-runtime\"
    ];
    expectedWarningsFor = scenario:
      map (layer: source.meta.expectedWarningBySkippedLayer.\${layer}) scenario.skippedUpstreamLayers;
    validateApprovalProfile = name:
      let profile = source.meta.approvalProfiles.\${name};
      in
        require (profile.entryBoundary == \"intent-source\")
          \"\${name} approval must start from intent-source\"
        && require (profile.skippedUpstreamLayers == [ ])
          \"\${name} approval must not skip compiler/NFM/CPM/renderer/runtime stages\"
        && require (profile.requiredPath == fullApprovalPath)
          \"\${name} approval must require the complete repo/runtime path\";
    validateOnPrem = name: scenario:
      let attachment = scenario.onPremHostAttachment or { required = false; };
      in
        require (attachment ? required)
          \"\${name} must state whether an on-prem host attachment is required\"
        && require (
          if attachment.required
          then
            (attachment ? template)
            && attachment.template == source.meta.vlan2Template
            && attachment.template == \"GAMP/templates/on-prem-vlan2-host-adapter/inventory.nix\"
          else !(attachment ? template)
        )
          \"\${name} must either reference the VLAN2 template exactly or omit a template when no on-prem attachment is required\";
    validateEvidence = name: scenario:
      require (scenario.evidenceContext ? kind && scenario.evidenceContext.kind == \"template-source\")
        \"\${name} evidenceContext.kind must be template-source\"
      && require (scenario.evidenceContext ? maySupport && builtins.isList scenario.evidenceContext.maySupport)
        \"\${name} evidenceContext.maySupport must be a list\"
      && require (scenario.evidenceContext ? mustNotClaim && builtins.isList scenario.evidenceContext.mustNotClaim)
        \"\${name} evidenceContext.mustNotClaim must be a list\"
      && require (hasValue \"HAT\" scenario.evidenceContext.mustNotClaim)
        \"\${name} must not claim HAT evidence from this template\"
      && require (hasValue \"SAT\" scenario.evidenceContext.mustNotClaim)
        \"\${name} must not claim SAT evidence from this template\"
      && require (scenario.evidenceContext ? requiredBeforePromotion && scenario.evidenceContext.requiredBeforePromotion != [ ])
        \"\${name} must list promotion prerequisites\";
    validateScenario = name:
      let scenario = source.scenarios.\${name};
      in
        require (scenario.id == name)
          \"\${name} id must match the attr name\"
        && require (hasPrefix source.meta.placeholderIdPrefix scenario.id)
          \"\${name} must use the placeholder prefix until renamed to a real FS chain\"
        && require (scenario.renameRequired == true)
          \"\${name} must force explicit rename before promotion\"
        && require (hasValue scenario.entryBoundary source.meta.allowedEntryBoundaries)
          \"\${name} uses an unknown entryBoundary\"
        && require (scenario.skippedUpstreamLayers == skippedForBoundary.\${scenario.entryBoundary})
          \"\${name} skippedUpstreamLayers must match its entryBoundary\"
        && require (scenario.expectedWarnings == expectedWarningsFor scenario)
          \"\${name} expectedWarnings must match skippedUpstreamLayers\"
        && require (builtins.isAttrs scenario.suppliedArtifact)
          \"\${name} must declare suppliedArtifact\"
        && require (scenario.suppliedArtifact ? kind && scenario.suppliedArtifact ? contract && scenario.suppliedArtifact ? requiredShape)
          \"\${name} suppliedArtifact must declare kind, contract, and requiredShape\"
        && require (scenario.suppliedArtifact.requiredShape != [ ])
          \"\${name} suppliedArtifact.requiredShape must not be empty\"
        && require (scenario.downstreamPath != [ ])
          \"\${name} downstreamPath must not be empty\"
        && require (scenario.expected ? kind && hasValue scenario.expected.kind allowedExpectedKinds)
          \"\${name} expected.kind is not allowed\"
        && require (scenario.expected ? includedLayers && scenario.expected.includedLayers == scenario.downstreamPath)
          \"\${name} expected.includedLayers must equal downstreamPath\"
        && require (scenario.expected ? assertions && scenario.expected.assertions != [ ])
          \"\${name} expected.assertions must not be empty\"
        && require (scenario ? owningLayerForInvalidInput && builtins.isString scenario.owningLayerForInvalidInput)
          \"\${name} must declare owningLayerForInvalidInput\"
        && validateEvidence name scenario
        && validateOnPrem name scenario;
  in
    require (source.meta.contract == \"FS-166 layer-entry scenario examples\")
      \"scenario template must declare the FS-166 contract\"
    && require (source.meta.renameRequired == true)
      \"template set must require renaming before promotion\"
    && require (validateApprovalProfile \"HAT\" && validateApprovalProfile \"SAT\")
      \"HAT/SAT approval profiles must require the full pipeline\"
    && require (builtins.length names >= 5)
      \"template set must include a few scenario examples\"
    && require (all validateScenario names)
      \"all scenario templates must validate\"
    && require (any (scenario: scenario.entryBoundary == \"forwarding-model-input\") values)
      \"template set must include an NFM-entry example\"
    && require (any (scenario: scenario.entryBoundary == \"control-plane-input\") values)
      \"template set must include a CPM-entry example\"
    && require (any (scenario: scenario.entryBoundary == \"renderer-input\") values)
      \"template set must include a renderer-entry example\"
    && require (any (scenario: scenario.entryBoundary == \"runtime-artifact\") values)
      \"template set must include a runtime-artifact example\"
    && require (any (scenario: scenario.expected.kind == \"negative-fail-closed\") values)
      \"template set must include a negative fail-closed example\"
    && require (any (scenario: (scenario.onPremHostAttachment or { required = false; }).required) values)
      \"template set must include an on-prem VLAN2-preserving example\"
" >/dev/null || fail "scenario templates did not evaluate against the FS-166 guard"

echo "PASS gamp-layer-entry-scenario-templates"
