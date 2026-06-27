{
  layer = "SMS";
  traceId = "FS-982-HDS-010-SDS-010-SMS-100";
  parentSds = ../../SDS/FS-982-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-982-HDS-010-SDS-010-SMS-100-profile-metadata-field-declaration.md";
  titleSlug = "profile-metadata-field-declaration";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-982-HDS-010-SDS-010-SMS-100";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-982-HDS-010-SDS-010-SMS-100/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
