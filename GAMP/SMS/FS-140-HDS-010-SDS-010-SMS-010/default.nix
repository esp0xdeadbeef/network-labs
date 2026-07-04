{
  layer = "SMS";
  traceId = "FS-140-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-140-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-140-HDS-010-SDS-010-SMS-010-scoped-output-boundary.md";
  titleSlug = "scoped-output-boundary";
  purpose = "Scoped Output Boundary (construction-only).";
  evidenceBoundary = "construction-only";
  sourceInputs = {
    "row-local" = {
      traceId = "FS-140-HDS-010-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-140-HDS-010-SDS-010-SMS-010/intent.nix";
      test = "tests/test-gamp-row-source-stubs.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
