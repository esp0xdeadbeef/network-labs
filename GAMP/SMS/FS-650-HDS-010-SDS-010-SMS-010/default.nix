{
  layer = "SMS";
  traceId = "FS-650-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-650-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-650-HDS-010-SDS-010-SMS-010-deployment-profile-manifest.md";
  titleSlug = "deployment-profile-manifest";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-650-HDS-010-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-650-HDS-010-SDS-010-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
