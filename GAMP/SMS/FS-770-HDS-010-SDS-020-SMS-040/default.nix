{
  layer = "SMS";
  traceId = "FS-770-HDS-010-SDS-020-SMS-040";
  parentSds = ../../SDS/FS-770-HDS-010-SDS-020;
  purpose = "Realization Fact Intent Mutation Rejection (construction-only).";
  evidenceBoundary = "construction-only";
  sourceInputs = {
    "row-local" = {
      traceId = "FS-770-HDS-010-SDS-020-SMS-040";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-770-HDS-010-SDS-020-SMS-040/intent.nix";
      test = "tests/test-gamp-row-source-stubs.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
