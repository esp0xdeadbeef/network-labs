{
  layer = "SMS";
  traceId = "FS-310-HDS-050-SDS-010-SMS-220";
  parentSds = ../../SDS/FS-310-HDS-050-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-310-HDS-050-SDS-010-SMS-220-test-input-pinning.md";
  titleSlug = "test-input-pinning";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-310-HDS-050-SDS-010-SMS-220";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-310-HDS-050-SDS-010-SMS-220/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
