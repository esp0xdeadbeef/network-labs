{
  layer = "SMS";
  traceId = "FS-410-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-410-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-410-HDS-010-SDS-010-SMS-020-host128-authority-boundary.md";
  titleSlug = "host128-authority-boundary";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-410-HDS-010-SDS-010-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-410-HDS-010-SDS-010-SMS-020/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
