{
  layer = "SMS";
  traceId = "FS-162-HDS-010-SDS-020-SMS-010";
  parentSds = ../../SDS/FS-162-HDS-010-SDS-020;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-162-HDS-010-SDS-020-SMS-010-openconfig-yang-model-validation.md";
  titleSlug = "openconfig-yang-model-validation";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-162-HDS-010-SDS-020-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-162-HDS-010-SDS-020-SMS-010/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
