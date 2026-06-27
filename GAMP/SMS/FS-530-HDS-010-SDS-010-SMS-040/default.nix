{
  layer = "SMS";
  traceId = "FS-530-HDS-010-SDS-010-SMS-040";
  parentSds = ../../SDS/FS-530-HDS-010-SDS-010;
  purpose = "Renderer Default Advertisement Denial Module (construction-only).";
  evidenceBoundary = "construction-only";
  sourceInputs = {
    "row-local" = {
      traceId = "FS-530-HDS-010-SDS-010-SMS-040";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-530-HDS-010-SDS-010-SMS-040/intent.nix";
      test = "tests/test-gamp-row-source-stubs.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
