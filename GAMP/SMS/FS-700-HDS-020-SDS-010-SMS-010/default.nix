{
  layer = "SMS";
  traceId = "FS-700-HDS-020-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-700-HDS-020-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-700-HDS-020-SDS-010-SMS-010-lab-source-validation-boundary.md";
  titleSlug = "lab-source-validation-boundary";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-700-HDS-020-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-700-HDS-020-SDS-010-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
