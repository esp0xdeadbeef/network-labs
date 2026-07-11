{
  layer = "SMS";
  traceId = "FS-705-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-705-HDS-010-SDS-010;
  purpose = "Lab profile selection metadata template (construction-only).";
  evidenceBoundary = "construction-only";
  sourceInputs = {
    "row-local" = {
      traceId = "FS-705-HDS-010-SDS-010-SMS-010";
      kind = "construction-only";
      sourcePath = "GAMP/SMT/FS-705-HDS-010-SDS-010-SMS-010/default.nix";
      test = "tests/test-gamp-sds-sms-template-mapping.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
