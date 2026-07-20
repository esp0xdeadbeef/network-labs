{
  layer = "SMS";
  traceId = "FS-310-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-310-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-010-SDS-010-SMS-020-renderer-target-capability-limitation.md";
  titleSlug = "renderer-target-capability-limitation";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-310-HDS-010-SDS-010-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-310-HDS-010-SDS-010-SMS-020/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
