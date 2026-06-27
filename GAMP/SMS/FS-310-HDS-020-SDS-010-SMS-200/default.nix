{
  layer = "SMS";
  traceId = "FS-310-HDS-020-SDS-010-SMS-200";
  parentSds = ../../SDS/FS-310-HDS-020-SDS-010;
  purpose = "Row-local SMT/SIT source stub for FS-310-HDS-020-SDS-010-SMS-200.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "row-local" = {
      traceId = "FS-310-HDS-020-SDS-010-SMS-200";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-310-HDS-020-SDS-010-SMS-200/intent.nix";
      test = "tests/test-gamp-row-source-stubs.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
    "tests/test-gamp-row-source-stubs.sh"
  ];
}
