{
  layer = "SMS";
  traceId = "FS-940-HDS-010-SDS-010-SMS-030";
  parentSds = ../../SDS/FS-940-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-940-HDS-010-SDS-010-SMS-030-stage-cardinality-benchmark.md";
  titleSlug = "stage-cardinality-benchmark";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-940-HDS-010-SDS-010-SMS-030";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-940-HDS-010-SDS-010-SMS-030/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
