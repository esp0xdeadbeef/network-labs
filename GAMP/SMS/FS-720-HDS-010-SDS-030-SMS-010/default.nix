{
  layer = "SMS";
  traceId = "FS-720-HDS-010-SDS-030-SMS-010";
  parentSds = ../../SDS/FS-720-HDS-010-SDS-030;
  purpose = "Row-local SMT/SIT source stub for FS-720-HDS-010-SDS-030-SMS-010.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "row-local" = {
      traceId = "FS-720-HDS-010-SDS-030-SMS-010";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-720-HDS-010-SDS-030-SMS-010/intent.nix";
      test = "tests/test-gamp-row-source-stubs.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
    "tests/test-gamp-row-source-stubs.sh"
  ];
}
