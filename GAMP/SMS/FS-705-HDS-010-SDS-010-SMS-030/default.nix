{
  layer = "SMS";
  traceId = "FS-705-HDS-010-SDS-010-SMS-030";
  parentSds = ../../SDS/FS-705-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-705-HDS-010-SDS-010-SMS-030-validation-profile-posture-reuse.md";
  titleSlug = "validation-profile-posture-reuse";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-705-HDS-010-SDS-010-SMS-030";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-705-HDS-010-SDS-010-SMS-030/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
