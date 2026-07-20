{
  layer = "SMS";
  traceId = "FS-960-HDS-010-SDS-014-SMS-010";
  parentSds = ../../SDS/FS-960-HDS-010-SDS-014;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-960-HDS-010-SDS-014-SMS-010-hotpatch-diagnostic-boundary.md";
  titleSlug = "hotpatch-diagnostic-boundary";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-960-HDS-010-SDS-014-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-960-HDS-010-SDS-014-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
