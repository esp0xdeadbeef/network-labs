{
  layer = "SMS";
  traceId = "FS-310-HDS-040-SDS-010-SMS-170";
  parentSds = ../../SDS/FS-310-HDS-040-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-040-SDS-010-SMS-170-cpm-forwarding-intent-preservation.md";
  titleSlug = "cpm-forwarding-intent-preservation";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-310-HDS-040-SDS-010-SMS-170";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-310-HDS-040-SDS-010-SMS-170/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
