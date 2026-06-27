{
  layer = "SMS";
  traceId = "FS-100-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-100-HDS-010-SDS-010;
  purpose = "Emitter repository provenance recording template (construction-only).";
  evidenceBoundary = "construction-only";
  sourceInputs = {
    "row-local" = {
      traceId = "FS-100-HDS-010-SDS-010-SMS-010";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-100-HDS-010-SDS-010-SMS-010/intent.nix";
      test = "tests/test-gamp-row-source-stubs.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
