{
  layer = "SMS";
  traceId = "FS-840-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-840-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-840-HDS-010-SDS-010-SMS-010-scoped-runtime-secret-delivery.md";
  titleSlug = "scoped-runtime-secret-delivery";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-840-HDS-010-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-840-HDS-010-SDS-010-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
