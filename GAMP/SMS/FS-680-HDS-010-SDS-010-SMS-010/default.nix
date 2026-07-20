{
  layer = "SMS";
  traceId = "FS-680-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-680-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-680-HDS-010-SDS-010-SMS-010-shared-service-matrix.md";
  titleSlug = "shared-service-matrix";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-680-HDS-010-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-680-HDS-010-SDS-010-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
