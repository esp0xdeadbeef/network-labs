{
  layer = "SMS";
  traceId = "FS-370-HDS-010-SDS-010-SMS-101";
  parentSds = ../../SDS/FS-370-HDS-010-SDS-010;
  purpose = "Row-local SMT/SIT source stub for FS-370-HDS-010-SDS-010-SMS-101.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "row-local" = {
      traceId = "FS-370-HDS-010-SDS-010-SMS-101";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-101/intent.nix";
      test = "tests/test-gamp-row-source-stubs.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
    "tests/test-gamp-row-source-stubs.sh"
  ];
}
