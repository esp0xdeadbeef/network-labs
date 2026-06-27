{
  layer = "SMS";
  traceId = "FS-350-HDS-010-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-350-HDS-010-SDS-010;
  purpose = "Reserved prefix denial: consume reservation state, deny advertisement/route/translation/assignment/exposure consumers from using reserved or unassigned space, emit denied-space records (construction-only).";
  evidenceBoundary = "construction-only";
  sourceInputs = {
    "row-local" = {
      traceId = "FS-350-HDS-010-SDS-010-SMS-020";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-350-HDS-010-SDS-010-SMS-020/intent.nix";
      test = "tests/test-gamp-row-source-stubs.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
