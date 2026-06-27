{
  layer = "SMS";
  traceId = "FS-720-HDS-010-SDS-050-SMS-010";
  parentSds = ../../SDS/FS-720-HDS-010-SDS-050;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-720-HDS-010-SDS-050-SMS-010-fixture-non-authority.md";
  titleSlug = "fixture-non-authority";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-720-HDS-010-SDS-050-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-720-HDS-010-SDS-050-SMS-010/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
