{
  layer = "SMS";
  traceId = "FS-940-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-940-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-940-HDS-010-SDS-010-SMS-020-stage-budget-cardinality-benchmark.md";
  titleSlug = "stage-budget-cardinality-benchmark";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-940-HDS-010-SDS-010-SMS-020";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-940-HDS-010-SDS-010-SMS-020/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
