{
  layer = "SMS";
  traceId = "FS-770-HDS-010-SDS-030-SMS-020";
  parentSds = ../../SDS/FS-770-HDS-010-SDS-030;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-770-HDS-010-SDS-030-SMS-020-source-shape-adapter-selection.md";
  titleSlug = "source-shape-adapter-selection";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-770-HDS-010-SDS-030-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-770-HDS-010-SDS-030-SMS-020/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
