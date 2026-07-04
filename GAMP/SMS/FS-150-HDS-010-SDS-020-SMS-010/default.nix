{
  layer = "SMS";
  traceId = "FS-150-HDS-010-SDS-020-SMS-010";
  parentSds = ../../SDS/FS-150-HDS-010-SDS-020;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-150-HDS-010-SDS-020-SMS-010-portability-comparison-record.md";
  titleSlug = "portability-comparison-record";
  purpose = "Portability Comparison Record (construction-only).";
  evidenceBoundary = "construction-only";
  sourceInputs = {
    "row-local" = {
      traceId = "FS-150-HDS-010-SDS-020-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-150-HDS-010-SDS-020-SMS-010/intent.nix";
      test = "tests/test-gamp-sds-sms-template-mapping.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
