{
  layer = "SMS";
  traceId = "FS-162-HDS-010-SDS-040-SMS-010";
  parentSds = ../../SDS/FS-162-HDS-010-SDS-040;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-162-HDS-010-SDS-040-SMS-010-s-router-prod-comparable-projection.md";
  titleSlug = "s-router-prod-comparable-projection";
  purpose = "Three-peer construction proof from one isolated FS-230 canonical bundle.";
  evidenceBoundary = "construction-only";
  sourceInputs.fs230CanonicalBundle = {
    traceId = "FS-162-HDS-010-SDS-040-SMS-010";
    kind = "validated-canonical-bundle";
    semanticSource = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-040/intent.nix";
    firstActiveBoundary = "network-compiler";
    rendererTargets = [
      "nixos"
      "clab"
      "openconfig"
    ];
    requireSameBundleIdentity = true;
    requireValidatedPlatformBindingBundle = true;
  };
}
