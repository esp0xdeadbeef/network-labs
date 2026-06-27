{
  layer = "SMS";
  traceId = "FS-030-HDS-010-SDS-040-SMS-010";
  parentSds = ../../SDS/FS-030-HDS-010-SDS-040;
  purpose = "Row-local SMT/SIT source stub for FS-030-HDS-010-SDS-040-SMS-010.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "row-local" = {
      traceId = "FS-030-HDS-010-SDS-040-SMS-010";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-040-SMS-010/intent.nix";
      test = "tests/test-gamp-row-source-stubs.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
    "tests/test-gamp-row-source-stubs.sh"
  ];
}
