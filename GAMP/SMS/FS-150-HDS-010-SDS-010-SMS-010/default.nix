{
  layer = "SMS";
  traceId = "FS-150-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-150-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-150-HDS-010-SDS-010-SMS-010-portable-meaning-contract.md";
  titleSlug = "portable-meaning-contract";
  purpose = "Portable Meaning Contract (construction-only).";
  evidenceBoundary = "construction-only";
  sourceInputs = {
    "row-local" = {
      traceId = "FS-150-HDS-010-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-150-HDS-010-SDS-010-SMS-010/intent.nix";
      test = "tests/test-gamp-row-source-stubs.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
