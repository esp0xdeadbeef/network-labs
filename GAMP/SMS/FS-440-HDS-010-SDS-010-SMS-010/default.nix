{
  layer = "SMS";
  traceId = "FS-440-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-440-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-440-HDS-010-SDS-010-SMS-010-provider-profile-classification.md";
  titleSlug = "provider-profile-classification";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-440-HDS-010-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-440-HDS-010-SDS-010-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
