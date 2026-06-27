{
  layer = "SMS";
  traceId = "FS-720-HDS-010-SDS-010-SMS-040";
  parentSds = ../../SDS/FS-720-HDS-010-SDS-010;
  purpose = "s-router-test-clients Persistence And Management Boundary (construction-only).";
  evidenceBoundary = "construction-only";
  sourceInputs = {
    "row-local" = {
      traceId = "FS-720-HDS-010-SDS-010-SMS-040";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-720-HDS-010-SDS-010-SMS-040/intent.nix";
      test = "tests/test-gamp-row-source-stubs.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
