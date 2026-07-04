{
  layer = "SMS";
  traceId = "FS-160-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-160-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-160-HDS-010-SDS-010-SMS-010-portability-limitation-reporting.md";
  titleSlug = "portability-limitation-reporting";
  purpose = "Portability Limitation Reporting (construction-only).";
  evidenceBoundary = "construction-only";
  sourceInputs = {
    "row-local" = {
      traceId = "FS-160-HDS-010-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-160-HDS-010-SDS-010-SMS-010/intent.nix";
      test = "tests/test-gamp-sds-sms-template-mapping.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
